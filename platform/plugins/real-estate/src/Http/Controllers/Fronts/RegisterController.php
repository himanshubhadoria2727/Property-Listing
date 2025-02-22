<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use Botble\ACL\Traits\RegistersUsers;
use Botble\Base\Facades\BaseHelper;
use Botble\Base\Facades\EmailHandler;
use Botble\Base\Http\Controllers\BaseController;
use Botble\Captcha\Facades\Captcha;
use Botble\RealEstate\Facades\RealEstateHelper;
use Botble\RealEstate\Models\Account;
use Botble\RealEstate\Notifications\ConfirmEmailNotification;
use Botble\SeoHelper\Facades\SeoHelper;
use Illuminate\Support\Facades\Log;
use Botble\Theme\Facades\Theme;
use Carbon\Carbon;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Botble\ACL\Models\Role;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Facades\Validator;

class RegisterController extends BaseController
{
    use RegistersUsers;

    protected string $redirectTo = '/';

    public function __construct()
    {
        $this->redirectTo = route('public.account.dashboard');
    }

    public function showRegistrationForm()
    {
        if (! RealEstateHelper::isRegisterEnabled()) {
            abort(404);
        }

        SeoHelper::setTitle(__('Register'));

        if (view()->exists(Theme::getThemeNamespace() . '::views.real-estate.account.auth.register')) {
            return Theme::scope('real-estate.account.auth.register')->render();
        }

        return view('plugins/real-estate::account.auth.register');
    }

    public function confirm(int|string $id, Request $request)
    {
        if (! RealEstateHelper::isRegisterEnabled()) {
            abort(404);
        }

        if (! URL::hasValidSignature($request)) {
            abort(404);
        }

        $account = Account::query()->findOrFail($id);

        $account->confirmed_at = Carbon::now();
        $account->save();

        $this->guard()->login($account);

        return $this
            ->httpResponse()
            ->setNextUrl(route('public.account.dashboard'))
            ->setMessage(__('You successfully confirmed your email address.'));
    }

    protected function guard()
    {
        return auth('account');
    }

    public function resendConfirmation(Request $request)
    {
        if (! RealEstateHelper::isRegisterEnabled()) {
            abort(404);
        }

        $account = Account::query()->where('email', $request->input('email'))->first();

        if (! $account) {
            return $this
                ->httpResponse()
                ->setError()
                ->setMessage(__('Cannot find this account!'));
        }

        $this->sendConfirmationToUser($account);

        return $this
            ->httpResponse()
            ->setMessage(__('We sent you another confirmation email. You should receive it shortly.'));
    }

    protected function sendConfirmationToUser(Account $account)
    {
        $account->notify(app(ConfirmEmailNotification::class));
    }

    public function register(Request $request)
    {
        if (! RealEstateHelper::isRegisterEnabled()) {
            abort(404);
        }

        $this->validator($request->input())->validate();

        event(new Registered($account = $this->create($request->input())));

        EmailHandler::setModule(REAL_ESTATE_MODULE_SCREEN_NAME)
            ->setVariableValues([
                'account_name' => $account->name,
                'account_email' => $account->email,
            ])
            ->sendUsingTemplate('account-registered');

        if (setting('verify_account_email', false)) {
            $this->sendConfirmationToUser($account);

            $this->registered($request, $account);

            return $this
                ->httpResponse()
                ->setNextUrl($this->redirectPath())
                ->setMessage(__('Please confirm your email address.'));
        }

        $account->confirmed_at = Carbon::now();

        $account->is_public_profile = false;
        if($request->has('role')) {
            $account->role = $request->input('role');
            if($request->input('role') == 1){
                $this->redirectTo = '/';
            }
        }
        $account->save();
        // if ($request->has('role')) {
        //     // Here we assume `getRoleIdByName` is a helper method to get the role ID by name
        //     $roleId = Role::where('name', $request->input('role'))->value('id');
        //     if ($roleId) {
        //         $account->roles()->sync([$roleId]);
        //     }
        // }
        Log::info('account'. $account);
        $this->guard()->login($account);

        return $this
            ->httpResponse()
            ->setNextUrl($this->redirectPath())->setMessage(__('Registered successfully!'));
    }

    protected function validator(array $data)
    {
        $rules = [
            'first_name' => 'required|max:120',
            'last_name' => 'required|max:120',
            'username' => 'required|max:60|min:2|unique:re_accounts,username',
            'email' => 'required|email|max:255|unique:re_accounts',
            'password' => 'required|min:6|confirmed',
            // 'phone' => 'required|' . BaseHelper::getPhoneValidationRule(),
        ];

        if (
            is_plugin_active('captcha') &&
            setting('enable_captcha') &&
            setting('real_estate_enable_recaptcha_in_register_page', 0)
        ) {
            $rules += Captcha::rules();
        }

        return Validator::make($data, $rules, [], Captcha::attributes());
    }

    protected function create(array $data)
    {
        return Account::query()->forceCreate([
            'first_name' => $data['first_name'],
            'last_name' => $data['last_name'],
            'username' => $data['username'],
            'email' => $data['email'],
            // 'phone' => $data['phone'],
            'password' => Hash::make($data['password']),
        ]);
    }

    public function getVerify()
    {
        if (! RealEstateHelper::isRegisterEnabled()) {
            abort(404);
        }

        return view('plugins/real-estate::account.auth.verify');
    }
}
