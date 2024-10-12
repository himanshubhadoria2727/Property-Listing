@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div class="container mx-auto p-6">
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

    <!-- Modern Flex Layout for the main container -->
    <div class="flex flex-col md:flex-row justify-between space-y-6 md:space-y-0 md:space-x-10">

        <!-- Future Bookings by the Authenticated User -->
        <div class="flex-1 bg-gradient-to-b from-gray-100 via-white to-white dark:bg-gradient-to-b dark:from-gray-800 dark:via-gray-900 dark:to-gray-900 p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300">
            <h3 class="font-bold text-2xl text-gray-900 dark:text-white mb-4">Your Future Bookings</h3>

            @if ($futureBookings->isNotEmpty())
            <ul class="list-none space-y-4">
                @foreach ($futureBookings as $booking)
                <li class="flex justify-between items-center bg-white dark:bg-gray-800 p-4 rounded-md shadow-md transition-transform duration-300 hover:-translate-y-1">
                    <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0 w-10 h-10 bg-indigo-100 text-indigo-600 rounded-full flex items-center justify-center">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div>
                            <span class="block text-lg font-semibold text-gray-900 dark:text-white">
                                {{ \Carbon\Carbon::parse($booking->scheduled_at)->format('Y-m-d H:i') }}
                            </span>
                            <span class="text-sm text-gray-600 dark:text-gray-400">{{ $booking->property->name }}</span>
                        </div>
                    </div>
                </li>
                @endforeach
            </ul>
            <div class="mt-4">
                <a href="{{ route('broadcast.join',  $booking['property_id']) }}" class="btn btn-primary gap-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full transition-colors duration-200 ease-in-out">
                    <i class="fas fa-video gap-2 mr-2"></i> Join Broadcast
                </a>

            </div>
            @else
            <p class="text-xl text-green-600 dark:text-green-400">You have no future bookings.</p>
            @endif
        </div>

        <!-- Bookings for User's Properties by Others -->
        <div class="flex-1 bg-gradient-to-b from-gray-100 via-white to-white dark:bg-gradient-to-b dark:from-gray-800 dark:via-gray-900 dark:to-gray-900 p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300">
            <h3 class="font-bold text-2xl text-gray-900 dark:text-white mb-4">Live Tour Bookings for Your Properties</h3>

            @if (count($propertyBookings) > 0)
            @foreach ($propertyBookings as $property)
            <div class="mb-6">
                <h4 class="text-lg font-semibold text-gray-900 dark:text-white">{{ $property['name'] }}</h4>
                @if (count($property['bookings']) > 0)
                <ul class="list-none space-y-4">
                    @foreach ($property['bookings'] as $booking)
                    <li class="flex justify-between items-center bg-white dark:bg-gray-800 p-4 rounded-md shadow-md transition-transform duration-300 hover:-translate-y-1">
                        <div class="flex items-center space-x-4 justify-between">
                            <div class="flex-shrink-0 w-10 h-10 bg-indigo-100 text-indigo-600 rounded-full flex items-center justify-center">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div>
                                <span class="block text-lg font-semibold text-gray-900 dark:text-white">
                                    {{ \Carbon\Carbon::parse($booking->scheduled_at)->format('Y-m-d H:i') }}
                                </span>
                                <span class="text-sm text-gray-600 dark:text-gray-400">Booked by {{ $booking->user->name }}</span>
                            </div>
                        </div>
                    </li>
                    @endforeach
                </ul>
                <!-- Start Live Button appears once after bookings -->
                <div class="mt-4">
                    <a href="{{ route('bookings.index', $property['id']) }}" class="btn btn-primary gap-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full transition-colors duration-200 ease-in-out">
                        <i class="fas fa-video gap-2 mr-2"></i> Broadcast
                    </a>
                </div>
                @else
                <p class="text-lg text-gray-500 dark:text-gray-400">No bookings yet.</p>
                @endif
            </div>
            @endforeach
            @else
            <p class="text-xl text-red-600 dark:text-red-400">You do not own any properties.</p>
            @endif
        </div>
    </div>

    @else
    <div class="text-center p-8 bg-gradient-to-b from-gray-100 via-white to-white dark:bg-gradient-to-b dark:from-gray-800 dark:via-gray-900 dark:to-gray-900 rounded-lg shadow-lg">
        <p class="text-xl text-gray-600 dark:text-gray-300">Please log in to view your bookings.</p>
    </div>
    @endauth
</div>
@endsection