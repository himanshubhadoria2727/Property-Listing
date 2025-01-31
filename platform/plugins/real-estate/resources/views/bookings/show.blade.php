@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div class="container">
    @auth('account')

    @php
    // Fetch the authenticated user's ID
    $userId = auth('account')->id();

    // Log the authenticated user ID
    \Log::info('Authenticated User ID:', ['user_id' => $userId]);

    // Fetch properties owned by the authenticated user
    $ownedProperties = \Botble\RealEstate\Models\Property::where('author_id', $userId)->get();

    // Log the count of owned properties
    \Log::info('Count of Owned Properties:', ['count' => $ownedProperties->count()]);
    @endphp

    <!-- Main container with grid layout for the section -->
    <div class="properties-container">

        <!-- Properties Owned by User -->
        <div class="properties-card">
            <h3>Your Properties</h3>

            @if (count($ownedProperties) > 0)
            <div class="grid">
                @foreach ($ownedProperties as $property)
                <div class="property-card">
                    <div class="property-details">
                        <h4>{{ $property->name }}</h4>
                        <p>Location: {{ $property->location }}</p>
                        <p>{{ $property->description }}</p>
                    </div>
                    <div class="broadcast-button-container">
                        <a href="{{ route('bookings.index', $property['id']) }}" class="broadcast-button">
                            <i class="fas fa-video"></i>  Broadcast
                        </a>
                    </div>
                </div>
                @endforeach
            </div>
            @else
            <p class="no-properties">You do not own any properties.</p>
            @endif
        </div>
    </div>

    @else
    <div class="login-prompt">
        <p>Please log in to view your properties.</p>
    </div>
    @endauth
</div>

<style>
    .container {
        max-width: 1200px;
        margin: 0 auto;
        border-radius: 8px; /* Rounded corners for a softer look */
    }

    .properties-container {
        display: flex;
        flex-direction: column;
        gap: 24px;
    }

    .properties-card {
        background: #ffffff;
        padding: 24px;
        border-radius: 12px; /* Increased border radius for a modern feel */
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Softer shadow */
    }

    h3 {
        font-weight: bold;
        font-size: 26px; /* Slightly larger font size */
        color: #2d3748; /* Darker color for better readability */
        margin-bottom: 16px;
    }

    .grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 24px;
    }

    .property-card {
        border: 1px solid #e2e8f0;
        border-radius: 12px; /* Increased border radius */
        padding: 16px;
        display: flex;
        flex-direction: column;
        gap: 16px;
        transition: box-shadow 0.2s; /* Smooth shadow transition */
    }

    .property-card:hover {
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15); /* Shadow on hover */
    }

    .property-details {
        flex: 1;
    }

    .property-details h4 {
        font-size: 22px; /* Increased font size */
        font-weight: 600;
        color: #2d3748; /* Darker color */
    }

    .property-details p {
        font-size: 16px;
        color: #4a5568;
    }

    .broadcast-button-container {
        width: fit-content;
        display: flex;
        justify-content: flex-end;
    }

    .broadcast-button {
        width: fit-content;
        display: inline-flex;
        align-items: center;
        background-color: #3182ce; /* Updated to a more modern blue */
        color: white;
        font-weight: bold;
        gap: 10px;
        padding: 12px 24px;
        border-radius: 9999px;
        text-decoration: none;
        transition: background-color 0.2s, transform 0.2s; /* Added transform transition */
    }

    .broadcast-button:hover {
        background-color: #2b6cb0; /* Darker blue on hover */
        transform: scale(1.05); /* Slightly enlarge on hover */
    }

    .no-properties {
        font-size: 20px;
        color: #e53e3e;
    }

    .login-prompt {
        text-align: center;
        padding: 32px;
        background: linear-gradient(to bottom, #f3f4f6, #ffffff);
        border-radius: 12px; /* Increased border radius */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    @media (max-width: 768px) {
        h3 {
            font-size: 22px; /* Adjusted for smaller screens */
        }
        .broadcast-button {
            width: 100%;
            text-align: center;
            margin-top: 10px;
        }
    }
</style>
@endsection