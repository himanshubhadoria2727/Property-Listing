<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Broadcast;
use App\Http\Controllers\AgentSessionController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Broadcast::routes(['middleware' => ['auth:account']]);

// Route::post('/broadcasting/auth', function () {
//     return Broadcast::auth(request());
// });

Route::post('/agent/session/create/{agentId}', [AgentSessionController::class, 'createSession']);
