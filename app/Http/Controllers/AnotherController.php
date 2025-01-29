<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AnotherController extends Controller
{
    public function someMethod()
    {
        $sessionId = session('session_id');

        // Use the sessionId as needed...
    }
} 