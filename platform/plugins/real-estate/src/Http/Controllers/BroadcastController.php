<?php

namespace Botble\RealEstate\Http\Controllers;

use Botble\RealEstate\Models\Booking;
use Botble\Base\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class BroadcastController extends BaseController
{
    public function startBroadcast($broadcastId)
    {
        // Pass the broadcastId to the view
        return view('broadcast.start', compact('broadcastId'));
    }

    // public function joinBroadcast($broadcastId)
    // {
    //     // Pass the broadcastId to the view
    //     return view('plugins/real-estate::broadcast.join', compact('broadcastId'));
    // }
}
