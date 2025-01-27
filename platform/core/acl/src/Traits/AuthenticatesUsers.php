<?php

namespace Botble\ACL\Traits;

use Illuminate\Contracts\Auth\Authenticatable;
use Illuminate\Contracts\Auth\StatefulGuard;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Routing\Redirector;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

trait AuthenticatesUsers
{
    use RedirectsUsers;
    use ThrottlesLogins;

    public function showLoginForm(): View|null
    {
        return null;
    }

    public function login(Request $request): Response|RedirectResponse
    {
        $this->validateLogin($request);

        // If the class is using the ThrottlesLogins trait, we can automatically throttle
        // the login attempts for this application. We'll key this by the username and
        // the IP address of the client making these requests into this application.
        if (
            method_exists($this, 'hasTooManyLoginAttempts') &&
            $this->hasTooManyLoginAttempts($request)
        ) {
            $this->fireLockoutEvent($request);

            $this->sendLockoutResponse($request);
        }

        if ($this->attemptLogin($request)) {
            return $this->sendLoginResponse($request);
        }

        // If the login attempt was unsuccessful we will increment the number of attempts
        // to log in and redirect the user back to the login form. Of course, when this
        // user surpasses their maximum number of attempts they will get locked out.
        $this->incrementLoginAttempts($request);

        return $this->sendFailedLoginResponse();
    }

    protected function validateLogin(Request $request): void
    {
        $request->validate([
            $this->username() => 'required|string',
            'password' => 'required|string',
        ]);
    }

    public function username(): string
    {
        return 'email';
    }

    protected function attemptLogin(Request $request): bool
    {
        return $this->guard()->attempt(
            $this->credentials($request),
            $request->filled('remember')
        );
    }

    protected function guard(): StatefulGuard
    {
        return Auth::guard();
    }

    protected function credentials(Request $request): array
    {
        return $request->only($this->username(), 'password');
    }

    protected function sendLoginResponse(Request $request): Response|RedirectResponse
    {
        $request->session()->regenerate();

        $this->clearLoginAttempts($request);

        $this->authenticated($request, $this->guard()->user());

        $user = $this->guard()->user();

        // Debugging: Check the role of the user
        Log::info('Authenticated User Role: ' . $user->role_id);

        // Role-based redirection
        if ($user->role == 1) {
            // Role 1 should redirect to homepage
            Log::info('Redirecting to homepage');
            return redirect('/');
        } elseif ($user->role == 2) {
            // Role 2 should redirect to the dashboard
            Log::info('Redirecting to dashboard');
            $sessionId = $this->getSessionId($user->id);

            // Update the agent_sessions table with the new session_id
            DB::table('agent_sessions')->insert([
                'agent_id' => $user->id,
                'session_id' => $sessionId
            ]);

            return redirect()->route('public.account.dashboard')->with("session_id", $sessionId);
        }

        // Default fallback if the role does not match
        Log::info('Role does not match, redirecting to default page');
        return redirect('/');
    }

    private function getSessionId(int $userId): string
    {
        // Generate a random string
        $randomString = Str::random(8); // Generates a random 8-character string

        // Concatenate with user ID and return
        return $userId . '-' . $randomString;
    }


    protected function authenticated(Request $request, Authenticatable $user)
    {
        //
    }

    protected function sendFailedLoginResponse()
    {
        throw ValidationException::withMessages([
            $this->username() => [trans('auth.failed')],
        ]);
    }

    public function logout(Request $request): Response|Redirector|RedirectResponse|Application
    {
        $this->guard()->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        $this->loggedOut($request);

        return $request->wantsJson()
            ? new Response('', 204)
            : redirect('/');
    }

    protected function loggedOut(Request $request)
    {
        //
    }
}
