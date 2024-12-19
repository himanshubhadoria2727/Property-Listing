@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div style="max-width: 1200px; margin: 0 auto; padding: 24px;">
    @auth('account')

    @php
    $userId = auth('account')->id();

    // Fetch future bookings for the authenticated user with property details
    $futureBookings = \Botble\RealEstate\Models\Booking::where('user_id', $userId)
    ->where('scheduled_at', '>', now())
    ->with('property')
    ->get();

    // Fetch properties owned by the authenticated user
    $ownedProperties = \Botble\RealEstate\Models\Property::where('author_id', $userId)->get();

    // Count bookings for each owned property
    $propertyBookings = [];
    foreach ($ownedProperties as $property) {
    $propertyBookings[] = [
    'id' => $property->id,
    'name' => $property->name,
    'bookings' => $property->bookings()->where('scheduled_at', '>', now())->where('call', true)->with('user')->get()
    ];
    }
    @endphp

    <div style="display: flex; flex-direction: column; gap: 24px;">
        <!-- Bookings for User's Properties by Others -->
        <div style="flex: 1; background: linear-gradient(to bottom, #f3f4f6, #ffffff); padding: 24px; border-radius: 8px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1); transition: box-shadow 0.3s;">
            <h3 style="font-weight: bold; font-size: 24px; color: #1a202c; margin-bottom: 16px;">Call Bookings for Your Properties</h3>

            @if (count($propertyBookings) > 0)
            @foreach ($propertyBookings as $property)
            <div style="margin-bottom: 24px;">
                <h4 style="font-size: 18px; font-weight: 600; color: #1a202c;">{{ $property['name'] }}</h4>
                @if (count($property['bookings']) > 0)
                @foreach ($property['bookings'] as $booking)
                <div style="margin-bottom: 24px;">
                    <div style="background-color: #ffffff; padding: 16px; border-radius: 8px; box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1); margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center;">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <div style="width: 40px; height: 40px; background-color: #e6f4f7; color: #4c9f70; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-phone-alt"></i>
                            </div>
                            <div>
                                <span style="font-size: 18px; font-weight: 600; color: #1a202c;">
                                    {{ \Carbon\Carbon::parse($booking->scheduled_at)->format('Y-m-d H:i') }}
                                </span>
                                <span style="font-size: 14px; color: #718096;">Booked by {{ $booking->user->name }}</span>
                            </div>
                        </div>

                        <div>
                            <button onclick="startCall('{{ $booking->user->name }}', '{{ $booking->user->id }}', '{{ $property['id'] }}')"
                                style="display: inline-flex; align-items: center; background-color: #4299e1; color: white; font-weight: bold; padding: 12px 24px; border-radius: 9999px; border: none; text-decoration: none; transition: background-color 0.2s, box-shadow 0.2s;">
                                <i class="fas fa-phone-alt" style="margin-right: 8px;"></i> Start Call
                            </button>
                        </div>
                    </div>
                </div>
                @endforeach
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

    <!-- Call Modal -->
    <div id="callModal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #fff; padding: 32px; border-radius: 12px; box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1); width: 450px; max-width: 100%; animation: fadeIn 0.5s ease;">
        <h4 id="callUserName" style="font-size: 20px; font-weight: 600; margin-bottom: 16px; color: #1a202c; text-align: center;">User Name</h4>

        <div id="callControls" style="display: flex; justify-content: space-around; align-items: center; gap: 16px; margin-top: 20px;">
            <button onclick="toggleMute()" id="muteButton"
                style="background-color: #48bb78; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600; display: flex; align-items: center; gap: 8px; transition: background-color 0.2s, transform 0.2s;">
                <i class="fas fa-microphone-slash" style="font-size: 18px;"></i> Mute
            </button>

            <button onclick="endCall()"
                style="background-color: #e53e3e; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600; display: flex; align-items: center; gap: 8px; transition: background-color 0.2s, transform 0.2s;">
                <i class="fas fa-phone-alt" style="font-size: 18px;"></i> End Call
            </button>
        </div>

        <!-- Call Status (Optional) -->
        <div id="callStatus" style="margin-top: 20px; text-align: center;">
            <p style="font-size: 16px; color: #4a5568;">Connecting...</p>
        </div>
    </div>

    @else
    <div style="text-align: center; padding: 32px; background: linear-gradient(to bottom, #f3f4f6, #ffffff); border-radius: 8px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">
        <p style="font-size: 20px; color: #4a5568;">Please log in to view your bookings.</p>
    </div>
    @endauth
</div>

<script src="https://download.agora.io/sdk/release/AgoraRTC_N-4.22.0.js"></script>
<script>
    let client;
    let localTracks = {
        audioTrack: null
    };
    let isCalling = false;
    let audioMuted = false;
    let uid = Math.floor(Math.random() * 1000);

    // Fetch the token for Agora client
    function fetchToken(channelName) {
        return axios.post(`/account/agora/token`, {
                channelName,
                uid
            })
            .then(response => {
                const token = response.data;
                console.log('token fetched', token);
                return token;
            })
            .catch(error => {
                console.error('Error fetching the token:', error);
                throw error;
            });
    }

    // Start calling (audio-only)
    async function startCall(userName, userId, propertyId) {
        document.getElementById('callModal').style.display = 'block';
        document.getElementById('callUserName').innerText = userName;
        await startAudioCall(userId);
        fetchToken(`channel-${userId}`);
    }

    // Start audio call (without video)
    async function startAudioCall(userId) {
    console.log('Starting audio call function...');
    
    if (isCalling) {
        console.log('Already in a call, returning...');
        return;
    }

    const channel = `channel-${userId}`;
    const appId = `{{ env('AGORA_APP_ID') }}`;

    console.log('User ID:', userId);
    console.log('Generated Channel:', channel);
    console.log('Agora App ID:', appId);

    if (!appId) {
        console.error('Agora App ID is missing.');
        return;
    }

    console.log(`Starting audio call for user: ${userId} on channel: ${channel}`);

    try {
        console.log('Fetching token...');
        const token = await fetchToken(channel);
        console.log('Fetched Token:', token);

        console.log('Creating Agora client...');
        client = AgoraRTC.createClient({
            mode: 'rtc',
            codec: 'vp8',
            role: 'host'
        });
        console.log('Agora Client:', client);

        console.log('Joining Agora channel...');
        const joinResult = await client.join(appId, channel, token, uid);

        console.log('Join Result:', joinResult);
        console.log('uid:', uid);

        console.log('Creating audio track...');
        const [audioTrack] = await AgoraRTC.createMicrophoneTracks();
        console.log('Created Audio Track:', audioTrack);

        console.log('Local Tracks before publishing:', localTracks);
        localTracks.audioTrack = audioTrack;

        console.log('Publishing audio track...');
        await client.publish([localTracks.audioTrack]);
        console.log('Audio Track Published.');

        console.log('Playing local audio track...');
        localTracks.audioTrack.play();
        console.log('Audio Track Playing.');

        isCalling = true;
        console.log('Audio call started successfully.');

    } catch (error) {
        console.error('Error starting audio call:', error);
    }
}

    // End the call
    function endCall() {
        document.getElementById('callModal').style.display = 'none';
        stopCall();
    }

    // Stop audio call
    async function stopCall() {
        if (!isCalling) return;

        try {
            await client.leave();
            if (localTracks.audioTrack) localTracks.audioTrack.close();
            isCalling = false;
        } catch (error) {
            console.error('Error stopping audio call:', error);
        }
    }

    // Mute/unmute the audio
    function toggleMute() {
        const muteButton = document.getElementById('muteButton');
        muteButton.classList.toggle('muted');
        if (muteButton.classList.contains('muted')) {
            muteButton.innerHTML = '<i class="fas fa-microphone"></i> Unmute';
            muteButton.style.backgroundColor = '#f56565'; // Change to unmute color
        } else {
            muteButton.innerHTML = '<i class="fas fa-microphone-slash"></i> Mute';
            muteButton.style.backgroundColor = '#48bb78'; // Change to mute color
        }
    }
</script>
<style>
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translate(-50%, -50%) scale(0.9);
        }

        to {
            opacity: 1;
            transform: translate(-50%, -50%) scale(1);
        }
    }

    #callModal {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: #fff;
        padding: 32px;
        border-radius: 12px;
        box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
        width: 450px;
        max-width: 100%;
        animation: fadeIn 0.5s ease-out;
    }
</style>

@endsection