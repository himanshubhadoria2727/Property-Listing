<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use App\Events\AgentCalling;
use Botble\RealEstate\Models\Booking;
use Botble\RealEstate\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Botble\Base\Http\Controllers\BaseController;
use Botble\RealEstate\Models\Account;
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
        $request->validate([
            'userId' => 'required|exists:re_accounts,id',
            'channel' => 'required|string'
        ]);

        try {
            broadcast(new AgentCalling(
                $request->input('userId'),
                $request->input('channel')
            ))->toOthers();

            return response()->json([
                'success' => true,
                'message' => 'Call notification sent successfully'
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to send call notification: ' . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Failed to send call notification'
            ], 500);
        }
    }

}
