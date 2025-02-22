<?php

namespace Botble\RealEstate\Http\Controllers;

use Botble\Base\Events\BeforeEditContentEvent;
use Botble\Base\Events\CreatedContentEvent;
use Botble\Base\Events\DeletedContentEvent;
use Botble\Base\Events\UpdatedContentEvent;
use Botble\Base\Facades\Assets;
use Botble\RealEstate\Facades\RealEstateHelper;
use Botble\RealEstate\Forms\PropertyForm;
use Botble\RealEstate\Http\Requests\PropertyRequest;
use Botble\RealEstate\Models\Account;
use Botble\RealEstate\Models\CustomFieldValue;
use Botble\RealEstate\Models\Property;
use Botble\RealEstate\Services\SaveFacilitiesService;
use Botble\RealEstate\Services\StorePropertyCategoryService;
use Botble\RealEstate\Tables\PropertyTable;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class PropertyController extends BaseController
{
    public function __construct()
    {
        parent::__construct();

        $this
            ->breadcrumb()
            ->add(trans('plugins/real-estate::property.name'), route('property.index'));
    }

    public function index(PropertyTable $dataTable)
    {
        $this->pageTitle(trans('plugins/real-estate::property.name'));

        return $dataTable->renderTable();
    }

    public function create()
    {
        $this->pageTitle(trans('plugins/real-estate::property.create'));

        return PropertyForm::create()->renderForm();
    }

    public function store(
        PropertyRequest $request,
        StorePropertyCategoryService $propertyCategoryService,
        SaveFacilitiesService $saveFacilitiesService
    ) {
        $request->merge([
            'expire_date' => Carbon::now()->addDays(RealEstateHelper::propertyExpiredDays()),
            'images' => array_filter($request->input('images', [])),
            'author_type' => Account::class,
        ]);

        $property = new Property();
        $property = $property->fill($request->input());
        $property->moderation_status = $request->input('moderation_status');
        $property->never_expired = $request->input('never_expired');
        $property->save();

        event(new CreatedContentEvent(PROPERTY_MODULE_SCREEN_NAME, $request, $property));

        if (RealEstateHelper::isEnabledCustomFields()) {
            $this->saveCustomFields($property, $request->input('custom_fields', []));
        }

        $property->features()->sync($request->input('features', []));

        $saveFacilitiesService->execute($property, $request->input('facilities', []));

        $propertyCategoryService->execute($request, $property);

        return $this
            ->httpResponse()
            ->setPreviousUrl(route('property.index'))
            ->setNextUrl(route('property.edit', $property->id))
            ->setMessage(trans('core/base::notices.create_success_message'));
    }

    public function edit(int|string $id, Request $request)
    {
        $decodedId = json_decode($id, true);
        $propertyId = $decodedId['id'];
        Log::info('Edit property', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        $property = Property::query()->with(['features', 'author'])->findOrFail($propertyId);

        Log::info('Property found', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        Assets::addScriptsDirectly(['vendor/core/plugins/real-estate/js/duplicate-property.js']);

        $this->pageTitle(trans('plugins/real-estate::property.edit') . ' "' . $property->name . '"');

        event(new BeforeEditContentEvent($request, $property));

        Log::info('Dispatch BeforeEditContentEvent', [
            'user_id' => auth('account')->id(),
            'property_id' => $id,
        ]);

        return PropertyForm::createFromModel($property)->renderForm();
    }

    public function update(
        int|string $id,
        PropertyRequest $request,
        StorePropertyCategoryService $propertyCategoryService,
        SaveFacilitiesService $saveFacilitiesService
    ) {
        $decodedId = json_decode($id, true);
        $propertyId = $decodedId['id'];

        $property = Property::query()->findOrFail($propertyId);
        $property->fill($request->except(['expire_date']));

        $property->author_type = Account::class;
        $property->images = array_filter($request->input('images', []));
        $property->moderation_status = $request->input('moderation_status');
        $property->never_expired = $request->input('never_expired');

        $property->save();

        event(new UpdatedContentEvent(PROPERTY_MODULE_SCREEN_NAME, $request, $property));

        if (RealEstateHelper::isEnabledCustomFields()) {
            $this->saveCustomFields($property, $request->input('custom_fields', []));
        }

        $property->features()->sync($request->input('features', []));

        $saveFacilitiesService->execute($property, $request->input('facilities', []));

        $propertyCategoryService->execute($request, $property);

        return $this
            ->httpResponse()
            ->setPreviousUrl(route('property.index'))
            ->setNextUrl(route('property.edit', $property->id))
            ->setMessage(trans('core/base::notices.update_success_message'));
    }

    public function destroy(int|string $id, Request $request)
    {
        try {
            $decodedId = json_decode($id, true);
            $propertyId = $decodedId['id'];
            $property = Property::query()->find($propertyId);

            if (!$property) {
                Log::warning('Attempted to delete a non-existent property', [
                    'property_id' => $id,
                    'user_id' => auth('account')->id(),
                ]);

                return $this
                    ->httpResponse()
                    ->setError()
                    ->setMessage(trans('core/base::notices.not_found_message'));
            }

            $property->delete();

            event(new DeletedContentEvent(PROPERTY_MODULE_SCREEN_NAME, $request, $property));

            Log::info('Property deleted successfully', [
                'property_id' => $property->id,
                'user_id' => auth('account')->id(),
            ]);

            return $this
                ->httpResponse()
                ->setMessage(trans('core/base::notices.delete_success_message'));
        } catch (Exception $exception) {
            Log::error('Error deleting property', [
                'property_id' => $id,
                'user_id' => auth('account')->id(),
                'error' => $exception->getMessage(),
            ]);

            return $this
                ->httpResponse()
                ->setError()
                ->setMessage($exception->getMessage());
        }
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
