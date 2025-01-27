<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use Botble\Base\Events\BeforeEditContentEvent;
use Botble\Base\Events\CreatedContentEvent;
use Botble\Base\Events\UpdatedContentEvent;
use Botble\Base\Facades\EmailHandler;
use Botble\Base\Http\Controllers\BaseController;
use Botble\Optimize\Facades\OptimizerHelper;
use Botble\RealEstate\Enums\ModerationStatusEnum;
use Botble\RealEstate\Facades\RealEstateHelper;
use Botble\RealEstate\Forms\AccountPropertyForm;
use Botble\RealEstate\Http\Requests\AccountPropertyRequest;
use Botble\RealEstate\Models\Account;
use Botble\RealEstate\Models\AccountActivityLog;
use Botble\RealEstate\Models\CustomFieldValue;
use Botble\RealEstate\Models\Property;
use Botble\RealEstate\Repositories\Interfaces\AccountActivityLogInterface;
use Botble\RealEstate\Repositories\Interfaces\AccountInterface;
use Botble\RealEstate\Repositories\Interfaces\PropertyInterface;
use Botble\RealEstate\Services\SaveFacilitiesService;
use Botble\RealEstate\Services\StorePropertyCategoryService;
use Botble\RealEstate\Tables\AccountPropertyTable;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class AccountPropertyController extends BaseController
{
    public function __construct(
        protected AccountInterface $accountRepository,
        protected PropertyInterface $propertyRepository,
        protected AccountActivityLogInterface $activityLogRepository
    ) {
        OptimizerHelper::disable();
    }

    public function index(AccountPropertyTable $propertyTable)
    {
        $this->pageTitle(trans('plugins/real-estate::account-property.properties'));

        return $propertyTable->render('plugins/real-estate::account.table.base');
    }

    public function create()
    {
        if (! auth('account')->user()->canPost()) {
            return back()->with(['error_msg' => trans('plugins/real-estate::package.add_credit_alert')]);
        }

        $this->pageTitle(trans('plugins/real-estate::account-property.write_property'));

        return AccountPropertyForm::create()->renderForm();
    }

    public function store(
        AccountPropertyRequest $request,
        StorePropertyCategoryService $propertyCategoryService,
        SaveFacilitiesService $saveFacilitiesService
    ) {
        if (! auth('account')->user()->canPost()) {
            return back()->with(['error_msg' => trans('plugins/real-estate::package.add_credit_alert')]);
        }

        $property = new Property();

        $property->fill(array_merge($this->processRequestData($request), [
            'author_id' => auth('account')->id(),
            'author_type' => Account::class,
        ]));

        $property->expire_date = Carbon::now()->addDays(RealEstateHelper::propertyExpiredDays());

        if (setting('enable_post_approval', 1) == 0) {
            $property->moderation_status = ModerationStatusEnum::APPROVED;
        }

        $property->save();

        if (RealEstateHelper::isEnabledCustomFields()) {
            $this->saveCustomFields($property, $request->input('custom_fields', []));
        }

        $property->features()->sync($request->input('features', []));

        $saveFacilitiesService->execute($property, $request->input('facilities', []));

        $propertyCategoryService->execute($request, $property);

        event(new CreatedContentEvent(PROPERTY_MODULE_SCREEN_NAME, $request, $property));

        AccountActivityLog::query()->create([
            'action' => 'create_property',
            'reference_name' => $property->name,
            'reference_url' => route('public.account.properties.edit', $property->id),
        ]);

        if (RealEstateHelper::isEnabledCreditsSystem()) {
            $account = Account::query()->findOrFail(auth('account')->id());
            $account->credits--;
            $account->save();
        }

        EmailHandler::setModule(REAL_ESTATE_MODULE_SCREEN_NAME)
            ->setVariableValues([
                'post_name' => $property->name,
                'post_url' => route('property.edit', $property->id),
                'post_author' => $property->author->name,
            ])
            ->sendUsingTemplate('new-pending-property');

        return $this
            ->httpResponse()
            ->setPreviousUrl(route('public.account.properties.index'))
            ->setNextUrl(route('public.account.properties.edit', $property->id))
            ->setMessage(trans('core/base::notices.create_success_message'));
    }

    public function edit(int|string $id, Request $request)
    {
        // Decode the JSON string in the $id parameter
        $decodedId = json_decode($id, true);
    
        // Check if the decoded data is valid and contains the 'id' field
        if (!is_array($decodedId) || !isset($decodedId['id'])) {
            Log::warning('Invalid property ID format', [
                'user_id' => auth('account')->id(),
                'property_id' => $id,
            ]);
            abort(400, 'Invalid property ID format');
        }
    
        // Extract the actual ID
        $propertyId = $decodedId['id'];
    
        Log::info("Extracted property ID", ['id' => $propertyId]);
        Log::info('Edit property', [
            'user_id' => auth('account')->id(),
            'property_id' => $propertyId,
            'request' => $request->only(['name', 'description', 'price']), // Log only necessary fields
        ]);
    
        // Fetch the property
        $property = $this->propertyRepository->getFirstBy([
            'id' => $propertyId,
            'author_id' => auth('account')->id(),
            'author_type' => Account::class,
        ]);
    
        if (!$property) {
            Log::warning('Property not found or unauthorized', [
                'user_id' => auth('account')->id(),
                'property_id' => $propertyId,
            ]);
            abort(404, 'Property not found or you do not have permission to edit it.');
        }
    
        Log::info('Property found', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);
    
        // Dispatch event
        try {
            event(new BeforeEditContentEvent($request, $property));
            Log::info('Dispatch BeforeEditContentEvent', [
                'user_id' => auth('account')->id(),
                'property_id' => $propertyId,
            ]);
        } catch (\Exception $e) {
            Log::error('Error dispatching BeforeEditContentEvent', [
                'user_id' => auth('account')->id(),
                'property_id' => $propertyId,
                'error' => $e->getMessage(),
            ]);
            abort(500, 'An error occurred while processing your request.');
        }
    
        // Set page title
        $this->pageTitle(trans('plugins/real-estate::property.edit') . ' "' . e($property->name) . '"');
    
        Log::info('Rendering form', [
            'user_id' => auth('account')->id(),
            'property_id' => $propertyId,
        ]);
    
        // Render the form
        return AccountPropertyForm::createFromModel($property)
            ->renderForm();
    }

    public function update(
        int|string $id,
        AccountPropertyRequest $request,
        StorePropertyCategoryService $propertyCategoryService,
        SaveFacilitiesService $saveFacilitiesService
    ) {
        Log::info('Updating property', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);
        $decodedId = json_decode($id, true);
        $propertyId = $decodedId['id'];

        $property = $this->propertyRepository->getFirstBy([
            'id' => $propertyId,
            'author_id' => auth('account')->id(),
            'author_type' => Account::class,
        ]);

        if (! $property) {
            Log::error('Property not found or you do not have permission to edit it.', [
                'user_id' => auth('account')->id(),
                'property_id' => $id,
            ]);
            abort(404);
        }

        Log::info('Property found', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        $property->fill($this->processRequestData($request));

        Log::info('Updating property model', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        $property->save();

        if (RealEstateHelper::isEnabledCustomFields()) {
            Log::info('Saving custom fields', [
                'user_id' => auth('account')->id(),
                'property_id' => $id,
            ]);
            $this->saveCustomFields($property, $request->input('custom_fields', []));
        }

        Log::info('Syncing features', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        $property->features()->sync($request->input('features', []));

        Log::info('Saving facilities', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        $saveFacilitiesService->execute($property, $request->input('facilities', []));

        Log::info('Saving categories', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        $propertyCategoryService->execute($request, $property);

        Log::info('Dispatching UpdatedContentEvent', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        event(new UpdatedContentEvent(PROPERTY_MODULE_SCREEN_NAME, $request, $property));

        Log::info('Creating activity log', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        AccountActivityLog::query()->create([
            'action' => 'update_property',
            'reference_name' => $property->name,
            'reference_url' => route('public.account.properties.edit', $property->id),
        ]);

        return $this
            ->httpResponse()
            ->setPreviousUrl(route('public.account.properties.index'))
            ->setNextUrl(route('public.account.properties.edit', $property->id))
            ->setMessage(trans('core/base::notices.update_success_message'));
    }

    protected function processRequestData(Request $request): array
    {
        $shortcodeCompiler = shortcode()->getCompiler();

        $request->merge([
            'content' => $shortcodeCompiler->strip($request->input('content'), $shortcodeCompiler->whitelistShortcodes()),
        ]);

        $except = [
            'is_featured',
            'author_id',
            'author_type',
            'expire_date',
        ];

        foreach ($except as $item) {
            $request->request->remove($item);
        }

        return $request->input();
    }

    public function destroy(int|string $id)
    {
        $property = $this->propertyRepository->getFirstBy([
            'id' => $id,
            'author_id' => auth('account')->id(),
            'author_type' => Account::class,
        ]);

        if (! $property) {
            abort(404);
        }

        $property->delete();

        AccountActivityLog::query()->create([
            'action' => 'delete_property',
            'reference_name' => $property->name,
        ]);

        return $this
            ->httpResponse()
            ->setMessage(__('Delete property successfully!'));
    }

    public function renew(int|string $id)
    {
        $property = Property::query()->findOrFail($id);

        $account = auth('account')->user();

        if (RealEstateHelper::isEnabledCreditsSystem() && $account->credits < 1) {
            return $this
                ->httpResponse()
                ->setError()
                ->setMessage(__('You don\'t have enough credit to renew this property!'));
        }

        $property->expire_date = $property->expire_date->addDays(RealEstateHelper::propertyExpiredDays());
        $property->save();

        if (RealEstateHelper::isEnabledCreditsSystem()) {
            $account->credits--;
            $account->save();
        }

        return $this
            ->httpResponse()
            ->setMessage(__('Renew property successfully'));
    }

    protected function saveCustomFields(Property $property, array $customFields = []): void
    {
        $customFields = CustomFieldValue::formatCustomFields($customFields);

        $property->customFields()
            ->whereNotIn('id', collect($customFields)->pluck('id')->all())
            ->delete();

        $property->customFields()->saveMany($customFields);
    }
}
