<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use Botble\RealEstate\Models\Booking;
use Botble\RealEstate\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Botble\Base\Http\Controllers\BaseController;
use Botble\RealEstate\Models\Account;

class BookingController extends BaseController
{
    public function book(Request $request)
    {
        $request->validate([
            'property_id' => 'required|exists:re_properties,id',
            'scheduled_at' => 'required|date|after:now',
        ]);

        $account = Account::query()->findOrFail(auth('account')->id());
        Log::info('account info'. $account);
        // Check if the account exists
        if (!$account) {
            return redirect()->back()->withErrors(['error' => 'Account not found.']);
        }


        Booking::create([
            'property_id' => $request->property_id,
            'user_id' => $account->id, // Use the account ID instead of auth()->id()
            'scheduled_at' => $request->scheduled_at,
        ]);

        return redirect()->back()->with('message', 'Tour scheduled successfully!');
    }

    public function viewBookings(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::bookings.index', compact('property', 'bookings'));
    }
    public function userBooking(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::user.show', compact('property', 'bookings'));
    }
    public function show(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::bookings.show', compact('property', 'bookings'));
    }
}
