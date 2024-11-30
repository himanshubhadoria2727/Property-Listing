    @extends('plugins/real-estate::themes.dashboard.userLayouts.userLayout')

    @section('content')
    <div class="container" style="max-width: 1280px; padding: 24px; margin: auto; overflow-y: auto;">
        @auth('account')

        @php
        // Fetch the authenticated user's ID
        $userId = auth('account')->id();

        // Fetch future bookings for the authenticated user with property details
        $futureBookings = \Botble\RealEstate\Models\Booking::where('user_id', $userId)
        ->where('scheduled_at', '>', now())
        ->with('property') // Eager load the property relationship
        ->get();

        // Fetch properties owned by the authenticated user
        $ownedProperties = \Botble\RealEstate\Models\Property::where('author_id', $userId)->get();

        // Count bookings for each owned property
        $propertyBookings = [];
        foreach ($ownedProperties as $property) {
        $propertyBookings[] = [
        'id' => $property->id,
        'name' => $property->name,
        'bookings' => $property->bookings()->where('scheduled_at', '>', now())->with('user')->get()
        ];
        }
        @endphp

        <div class="container" style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 24px;">
            <!-- Future Bookings by the Authenticated User -->
            <div class="future-bookings" style="background: linear-gradient(to bottom, #f3f4f6, white); padding: 24px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); transition: box-shadow 0.3s; cursor: pointer;" onmouseover="this.style.boxShadow='0 4px 12px rgba(0, 0, 0, 0.2)';" onmouseout="this.style.boxShadow='0 4px 6px rgba(0, 0, 0, 0.1)';">
                <h3 style="font-weight: bold; font-size: 24px; color: #1f2937; margin-bottom: 16px; text-align: center;">Your Future Bookings</h3>

                @if ($futureBookings->isNotEmpty())
                <div class="booking-grid">
                    @foreach ($futureBookings as $booking)
                    @php
                    $property = $booking->property;
                    @endphp
                    <div class="booking-card" style="width: 100%; display: flex; flex-direction: column; border: 2px solid #e5e7eb; background-color: white;margin-bottom: 16px; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); transition: transform 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)';" onmouseout="this.style.transform='translateY(0)';">
                        <div class="booking-info" style="display: flex; flex-direction: column; gap: 12px;">
                            <div style="display: flex; align-items: center; gap: 16px;">
                                <div style="width: 40px; height: 40px; background-color: #e0e7ff; color: #4338ca; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                    <i class="fas fa-calendar-alt"></i>
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 10px;">
                                    <span style="font-size: 18px; font-weight: 600; color: #1f2937;">
                                        {{ \Carbon\Carbon::parse($booking->scheduled_at)->format('Y-m-d H:i') }}
                                    </span>
                                    <span style="font-size: 18px; color: #6b7280; font-weight: 500;">{{ $booking->property->name }}</span>
                                    <span>Description: </span>
                                    <span style="font-size: 14px; color: #6b7280; text-align: justify; flex: 1; max-height: 100px; overflow-y: auto;">{{ $booking->property->description }}</span>
                                </div>
                            </div>
                        </div>

                        <div class="property-images" style="display: flex; flex-wrap: wrap; padding: 16px;">
                            @foreach(range(1, 4) as $index)
                            <span style="margin-left: 8px; margin-right: 8px;">
                                <img src="{{ RvMedia::getImageUrl($property->images[$index]) }}" alt="Property Thumbnail" style="width: 100px; height: 100px; border-radius: 8px; object-fit: cover; border: 1px solid #e5e7eb; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
                            </span>
                            @endforeach
                        </div>

                        <div style="margin-top: 16px; text-align: center;">
                            <a href="{{ route('user.join',  $booking['property_id']) }}" style="display: inline-flex; align-items: center; padding: 8px 16px; background-color: #3b82f6; color: white; font-weight: bold; border-radius: 9999px; transition: background-color 0.2s ease-in-out;" onmouseover="this.style.backgroundColor='#2563eb';" onmouseout="this.style.backgroundColor='#3b82f6';">
                                <i class="fas fa-video" style="margin-right: 8px;"></i> Join Broadcast
                            </a>
                        </div>
                    </div>
                    @endforeach
                </div>
                @else
                <p style="font-size: 20px; color: #10b981; text-align: center;">You have no future bookings.</p>
                @endif
            </div>
        </div>
        @else
        <div style="text-align: center; padding: 32px; background: linear-gradient(to bottom, #f3f4f6, white); border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
            <p style="font-size: 20px; color: #6b7280;">Please log in to view your bookings.</p>
        </div>
        @endauth
    </div>
    @endsection