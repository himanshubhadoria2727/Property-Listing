<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use Botble\RealEstate\Models\Booking;
use Botble\RealEstate\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Botble\Base\Http\Controllers\BaseController;
use Botble\RealEstate\Models\Account;
use Botble\Base\Supports\Language;
use Carbon\Carbon;
use Botble\RealEstate\Forms\AccountForm;
use Botble\RealEstate\Forms\Fronts\ChangePasswordForm;
use Botble\RealEstate\Forms\Fronts\ProfileForm;

class BookingController extends BaseController
{
    public function book(Request $request)
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
            'call' => false,
            'live' => true,
        ]);

        return redirect()->back()->with('message', 'Tour scheduled successfully!');
    }

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

    public function viewBookings(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::bookings.index', compact('property', 'bookings'));
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

    public function deleteExpiredBookings()
    {
        // Fetch bookings that are 1 hour past their scheduled time
        $expiredBookings = Booking::where('scheduled_at', '<', Carbon::now()->subHour())->get();

        foreach ($expiredBookings as $booking) {
            Log::info('Deleting expired booking ID: ' . $booking->id);
            $booking->delete();
        }

        return response()->json([
            'message' => 'Expired bookings deleted successfully!',
        ]);
    }

    public function viewSettings()
    {
        $user = auth('account')->user();
        
        if (!$user) {
            return redirect()->route('public.account.login');
        }
        $profileForm = ProfileForm::createFromModel($user)
        ->renderForm();

        $changePasswordForm = ChangePasswordForm::create()
        ->renderForm();
        return view('plugins/real-estate::user.settings', compact('profileForm', 'changePasswordForm'));
    }
}
