@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div style="max-width: 1200px; margin: 0 auto; padding: 24px;">
    @auth('account')

    @php
    // Fetch the authenticated user's ID
    $userId = auth('account')->id();

    // Check if the user ID is valid
    \Log::info('Authenticated User ID:', ['user_id' => $userId]);

    // Fetch future bookings for the authenticated user with property details
    $futureBookings = \Botble\RealEstate\Models\Booking::where('user_id', $userId)
    ->where('scheduled_at', '>', now())
    ->with('property') // Eager load the property relationship
    ->get();

    // Fetch properties owned by the authenticated user
    $ownedProperties = \Botble\RealEstate\Models\Property::where('author_id', $userId)->get();

    // Log the count of owned properties
    \Log::info('Count of Owned Properties:', ['count' => $ownedProperties->count()]);

    // Count bookings for each owned property
    $propertyBookings = [];
    foreach ($ownedProperties as $property) {
    $propertyBookings[] = [
    'id' => $property->id, // Include the property ID
    'name' => $property->name,
    'bookings' => $property->bookings()->where('scheduled_at', '>', now())->with('user')->get() // Eager load user relationship
    ];
    }
    @endphp

    <!-- Main container with flex layout for the section -->
    <div style="display: flex; flex-direction: column; gap: 24px;">

        <!-- Bookings for User's Properties by Others -->
        <div style="flex: 1; background: linear-gradient(to bottom, #f3f4f6, #ffffff); padding: 24px; border-radius: 8px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1); transition: box-shadow 0.3s;">
            <h3 style="font-weight: bold; font-size: 24px; color: #1a202c; margin-bottom: 16px;">Live Tour Bookings for Your Properties</h3>

            @if (count($propertyBookings) > 0)
            @foreach ($propertyBookings as $property)
            <div style="margin-bottom: 24px;">
                <h4 style="font-size: 18px; font-weight: 600; color: #1a202c;">{{ $property['name'] }}</h4>
                @if (count($property['bookings']) > 0)
                <ul style="list-style-type: none; padding-left: 0; margin-top: 16px;">
                    @foreach ($property['bookings'] as $booking)
                    <li style="display: flex; justify-content: space-between; align-items: center; background-color: #ffffff; padding: 16px; border-radius: 8px; box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1); transition: transform 0.3s; margin-bottom: 16px;">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <div style="width: 40px; height: 40px; background-color: #e6f4f7; color: #4c9f70; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div>
                                <span style="display: block; font-size: 18px; font-weight: 600; color: #1a202c;">
                                    {{ \Carbon\Carbon::parse($booking->scheduled_at)->format('Y-m-d H:i') }}
                                </span>
                                <span style="font-size: 14px; color: #718096;">Booked by {{ $booking->user->name }}</span>
                            </div>
                        </div>
                    </li>
                    @endforeach
                </ul>
                <div style="margin-top: 16px;">
                    <a href="{{ route('bookings.index', $property['id']) }}" style="display: inline-flex; align-items: center; background-color: #4299e1; color: white; font-weight: bold; padding: 12px 24px; border-radius: 9999px; text-decoration: none; transition: background-color 0.2s;">
                        <i class="fas fa-video" style="margin-right: 8px;"></i> Broadcast
                    </a>
                </div>
                @else
                <p style="font-size: 18px; color: #4a5568;">No bookings yet.</p>
                @endif
            </div>
            @endforeach
            @else
            <p style="font-size: 20px; color: #e53e3e;">You do not own any properties.</p>
            @endif
        </div>
    </div>

    @else
    <div style="text-align: center; padding: 32px; background: linear-gradient(to bottom, #f3f4f6, #ffffff); border-radius: 8px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">
        <p style="font-size: 20px; color: #4a5568;">Please log in to view your bookings.</p>
    </div>
    @endauth
</div>
@endsection