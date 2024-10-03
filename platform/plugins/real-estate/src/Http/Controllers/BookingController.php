<?php

namespace Botble\RealEstate\Http\Controllers;

use Botble\RealEstate\Models\Booking;
use Botble\RealEstate\Models\Property;
use Illuminate\Http\Request;
use Botble\Base\Http\Controllers\BaseController;

class BookingController extends BaseController
{
    public function book(Request $request)
    {
        $request->validate([
            'property_id' => 'required|exists:re_properties,id',
            'scheduled_at' => 'required|date|after:now',
        ]);

        Booking::create([
            'property_id' => $request->property_id,
            'user_id' => auth()->id(),
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
}
