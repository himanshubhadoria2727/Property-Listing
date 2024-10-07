<?php

use Illuminate\Http\Request;
use Pusher\Pusher;
use Botble\Base\Http\Controllers\BaseController;


class SignalingController extends BaseController
{
    public function sendSignal(Request $request)
    {
        $pusher = new Pusher(
            env('PUSHER_APP_KEY'),
            env('PUSHER_APP_SECRET'),
            env('PUSHER_APP_ID'),
            ['cluster' => env('PUSHER_APP_CLUSTER')]
        );

        $pusher->trigger('property-channel', 'signal', [
            'type' => $request->type,
            'data' => $request->data,
            'sender' => $request->sender,
            'receiver' => $request->receiver,
        ]);

        return response()->json(['status' => 'success']);
    }
}
