<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use App\Events\AgentCalling;
use App\Events\UserCalling;
use Botble\RealEstate\Models\Booking;
use Botble\RealEstate\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Botble\Base\Http\Controllers\BaseController;
use Botble\RealEstate\Models\Account;
use App\Events\CallEnded;
use App\Events\CallRejected;
use App\Models\User;
use Carbon\Carbon;

class CallController extends BaseController
{
    public function bookCall(Request $request)
{
    $request->validate([
        'property_id' => 'required|exists:re_properties,id',
        'scheduled_at' => 'required|date|after:now',
        'call' => 'boolean', // Validate the 'call' field as boolean
        'live' => 'boolean', // Validate the 'live' field as boolean
    ]);

    $account = Account::query()->findOrFail(auth('account')->id());
    Log::info('account info: ' . $account);

    // Check if the account exists
    if (!$account) {
        return redirect()->back()->withErrors(['error' => 'Account not found.']);
    }

    // Create the booking with 'call' and 'live' fields
    Booking::create([
        'property_id' => $request->property_id,
        'user_id' => $account->id, // Use the account ID instead of auth()->id()
        'scheduled_at' => $request->scheduled_at,
        'call' => true,
        'live' => false,
    ]);

    return redirect()->back()->with('message', 'Call scheduled successfully!');
}
    public function startCall(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::calls.show', compact('property', 'bookings'));
    }
    public function viewCallBookings(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::calls.show', compact('property', 'bookings'));
    }

    public function notifyCall(Request $request)
{
    // Validate the input parameters
    $validated = $request->validate([
        'userId' => 'required|integer', // Adjust validation as needed
        'channel' => 'required|string|max:255',
    ]);

    Log::info('notifyCall function started', ['userId' => $request->input('userId'), 'channel' => $request->input('channel')]);

    try {
        // Broadcast the event
        broadcast(new AgentCalling(
            $request->input('userId'),
            $request->input('channel')
        ))->toOthers();

        Log::info('Call notification sent successfully', ['userId' => $request->input('userId'), 'channel' => $request->input('channel')]);

        return response()->json([
            'success' => true,
            'message' => 'Call notification sent successfully'
        ]);
    } catch (\Exception $e) {
        // Log the full exception for better debugging
        Log::error('Failed to send call notification', [
            'error' => $e->getMessage(),
            'stack' => $e->getTraceAsString(),
            'userId' => $request->input('userId'),
            'channel' => $request->input('channel')
        ]);

        return response()->json([
            'success' => false,
            'message' => 'Failed to send call notification'
        ], 500);
    }
}
    public function notifyAuthor(Request $request)
{
    // Validate the input parameters
    $validated = $request->validate([
        'userId' => 'required|integer', // Adjust validation as needed
        'channel' => 'required|string|max:255',
    ]);

    Log::info('notifyCall function started', ['userId' => $request->input('userId'), 'channel' => $request->input('channel')]);

    try {
        // Broadcast the event
        broadcast(new UserCalling(
            $request->input('userId'),
            $request->input('channel')
        ))->toOthers();

        Log::info('Call notification sent successfully', ['userId' => $request->input('userId'), 'channel' => $request->input('channel')]);

        return response()->json([
            'success' => true,
            'message' => 'Call notification sent successfully'
        ]);
    } catch (\Exception $e) {
        // Log the full exception for better debugging
        Log::error('Failed to send call notification', [
            'error' => $e->getMessage(),
            'stack' => $e->getTraceAsString(),
            'userId' => $request->input('userId'),
            'channel' => $request->input('channel')
        ]);

        return response()->json([
            'success' => false,
            'message' => 'Failed to send call notification'
        ], 500);
    }
}

public function endCall(Request $request)
{
    event(new CallEnded($request->userId, $request->channelName));
    return response()->json(['message' => 'Call ended successfully']);
}

public function rejectCall(Request $request)
{
    event(new CallRejected($request->userId, $request->channelName));
    return response()->json(['message' => 'Call rejected successfully']);
}

}
