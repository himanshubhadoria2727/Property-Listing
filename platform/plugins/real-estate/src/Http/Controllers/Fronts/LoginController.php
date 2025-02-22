<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use Botble\ACL\Traits\AuthenticatesUsers;
use Botble\ACL\Traits\LogoutGuardTrait;
use Botble\RealEstate\Facades\RealEstateHelper;
use Botble\RealEstate\Http\Controllers\BaseController;
use Botble\SeoHelper\Facades\SeoHelper;
use Botble\Theme\Facades\Theme;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class LoginController extends BaseController
{
    use AuthenticatesUsers, LogoutGuardTrait {
        AuthenticatesUsers::attemptLogin as baseAttemptLogin;
    }

    public string $redirectTo = '/';

    public function __construct()
    {
        parent::__construct();

         $this->redirectTo = route('public.account.dashboard');
    }

    public function showLoginForm()
    {
        if (! RealEstateHelper::isLoginEnabled()) {
            abort(404);
        }

        SeoHelper::setTitle(trans('plugins/real-estate::account.login'));

        if (view()->exists(Theme::getThemeNamespace() . '::views.real-estate.account.auth.login')) {
            return Theme::scope('real-estate.account.auth.login')->render();
        }

        return view('plugins/real-estate::account.auth.login');
    }

    protected function guard()
    {
        return auth('account');
    }

    public function login(Request $request)
    {
        if (! RealEstateHelper::isLoginEnabled()) {
            abort(404);
        }
        Log::info('user request', $request->all());
        $request->merge([$this->username() => $request->input('email')]);

        $this->validateLogin($request);
        if($request->has('role')) {
            if($request->input('role') == 1){
                $this->redirectTo = '/';
            }
        }

        // If the class is using the ThrottlesLogins trait, we can automatically throttle
        // the login attempts for this application. We'll key this by the username and
        // the IP address of the client making these requests into this application.
        if ($this->hasTooManyLoginAttempts($request)) {
            $this->fireLockoutEvent($request);

            $this->sendLockoutResponse($request);
        }

        if ($this->attemptLogin($request)) {
            return $this->sendLoginResponse($request);
        }

        // If the login attempt was unsuccessful we will increment the number of attempts
        // to login and redirect the user back to the login form. Of course, when this
        // user surpasses their maximum number of attempts they will get locked out.
        $this->incrementLoginAttempts($request);

        return $this->sendFailedLoginResponse();
    }

    protected function attemptLogin(Request $request)
    {
        if ($this->guard()->validate($this->credentials($request))) {
            $account = $this->guard()->getLastAttempted();

            if (setting(
                'verify_account_email',
                false
            ) && empty($account->confirmed_at)) {
                throw ValidationException::withMessages([
                    'confirmation' => [
                        __('The given email address has not been confirmed. <a href=":resend_link">Resend confirmation link.</a>', [
                            'resend_link' => route('public.account.resend_confirmation', ['email' => $account->email]),
                        ]),
                    ],
                ]);
            }

            return $this->baseAttemptLogin($request);
        }

        return false;
    }

    public function username()
    {
        return filter_var(request()->input('username'), FILTER_VALIDATE_EMAIL) ? 'email' : 'username';
    }

    public function logout(Request $request)
    {
        if (! RealEstateHelper::isLoginEnabled()) {
            abort(404);
        }

        $activeGuards = 0;
        $this->guard()->logout();

        foreach (config('auth.guards', []) as $guard => $guardConfig) {
            if ($guardConfig['driver'] !== 'session') {
                continue;
            }
            if ($this->isActiveGuard($request, $guard)) {
                $activeGuards++;
            }
        }

        if (! $activeGuards) {
            $request->session()->flush();
            $request->session()->regenerate();
        }
        $sessionId = $request->input('session_id');

        if ($sessionId) {
            DB::table('agent_sessions')
                ->where('session_id', $sessionId)
                ->delete();
    
            Log::info("Session with ID {$sessionId} deleted successfully.");
        } else {
            Log::warning('No session ID provided for logout.');
        }        $this->loggedOut($request);

        return redirect(route('public.index'));
    }
}
