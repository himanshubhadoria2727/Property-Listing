<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class CheckUserRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        $user = Auth::guard('account')->user();

        if ($user) {
            Log::info('User role: ' . $user->role, ['user_id' => $user->id]);

            // Check if user has the required role
            if ((int)$user->role === 2) {
                Log::info('User has the required role', ['user_id' => $user->id]);
                return $next($request);
            }
        }

        // Log unauthorized access attempt
        Log::warning('Unauthorized access attempt', [
            'user_id' => $user->id ?? null,
            'ip' => $request->ip(),
            'url' => $request->fullUrl()
        ]);

        // Return a 404 error response
        abort(404);
    }
}
