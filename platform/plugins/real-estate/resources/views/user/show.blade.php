<div class="container" style="max-width: 1280px; padding: 24px; margin: auto; overflow-y: auto;">
    @auth('account')
    @php
    $userId = auth('account')->id();

    // Fetch future bookings for the authenticated user with property details
    $futureBookings = \Botble\RealEstate\Models\Booking::where('user_id', $userId)
    ->where('scheduled_at', '>', now()->subHour())
    ->where('live', true)
    ->with('property') // Eager load the property relationship
    ->get();
    @endphp

    <div style="display: flex; flex-direction: column; gap: 16px;">
        <h2 class="dark:text-white" style="text-align: center; font-size: 1.5rem; color: #1f2937; font-weight: bold; margin-bottom: 16px;">Your Future Bookings</h2>

        @if ($futureBookings->isNotEmpty())
        @foreach ($futureBookings as $booking)
        @php 
            $property = $booking->property;
            $scheduledTime = \Carbon\Carbon::parse($booking->scheduled_at);
            $currentTime = \Carbon\Carbon::now();
            $timeDiff = $scheduledTime->diffInMinutes($currentTime);
            
            // Check if we're within one hour after the scheduled time
            $isWithinOneHourAfter = $currentTime->between(
                $scheduledTime,
                $scheduledTime->copy()->addHour()
            );
            
            // Check if we're within 5 minutes before
            $isWithinFiveMinutesBefore = $timeDiff <= 5 && $scheduledTime > $currentTime;
            
            // Show button if either condition is met
            $showJoinButton = $isWithinFiveMinutesBefore || $isWithinOneHourAfter;
        @endphp
        
        <div class="booking-strip dark:bg-gray-800"
            style="display: flex; align-items: center; justify-content: space-between; padding: 16px; background: white; border: 1px solid #e5e7eb; border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">

            <div style="flex-grow: 1; display: flex; flex-direction: column; gap: 8px;">
                <span class="dark:text-white" style="font-size: 1.1rem;font-weight: bold; color: #1f2937;">{{ $property->name }}</span>
                <span class="dark:text-white" style="font-size: 1rem; color: #374151;">{{ $property->location }}</span>
                <span class="dark:text-white" style="font-size: 1rem;  color: #374151;">{{ \Carbon\Carbon::parse($booking->scheduled_at)->format('Y-m-d H:i') }}</span>
                @if ($isWithinOneHourAfter)
                    <span style="font-size: 0.9rem; color: #10b981;">Session in progress</span>
                @endif
            </div>
            
            @if ($showJoinButton)
                <a
                    target="_blank"
                    href="{{ route('user.join', $booking['property_id']) }}"
                    style="background: #3b82f6; color: white; font-weight: bold; padding: 8px 16px; border-radius: 4px; text-decoration: none; display: inline-block; transition: background-color 0.2s ease;"
                    onmouseover="this.style.backgroundColor='#2563eb';"
                    onmouseout="this.style.backgroundColor='#3b82f6';">
                    Join
                </a>
            @endif
        </div>
        @endforeach
        @else
        <p style="text-align: center; font-size: 1.2rem; color: #10b981;">You have no future bookings.</p>
        @endif
    </div>
    @else
    <div style="text-align: center; padding: 32px; background: linear-gradient(to bottom, #f3f4f6, white); border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
        <p style="font-size: 1.2rem; color: #6b7280;">Please log in to view your bookings.</p>
    </div>
    @endauth
</div>