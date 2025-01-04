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
    let client = null;
    let localTracks = {
        audioTrack: null
    };
    let remoteUsers = {};
    let isCalling = false;
    let uid = Math.floor(Math.random() * 100000);
    let currentCallChannel = null;
    let currentCallUserId = null;

    // Fetch the token for Agora client
    async function fetchToken(channelName,userId) {
        try {
            const response = await axios.post('/account/agora/token', {
                channelName,
                uid
            });
            console.log('Token fetched successfully:', response.data);
            return response.data;
        } catch (error) {
            console.error('Error fetching token:', error);
            throw error;
        }
    }

    // Initialize Laravel Echo listener
    window.Echo.channel(`user.${userId}`)
        .listen('.incoming.call', (data) => {
            console.log('Incoming call:', data);
            handleIncomingCall(data);
        })
        .listen('.call.ended', (data) => {
            console.log('Call ended by other party:', data);
            if (data.channel === currentCallChannel) {
                endCall();
            }
        })
        .listen('.call.rejected', (data) => {
            console.log('Call rejected:', data);
            if (data.channel === currentCallChannel) {
                handleCallRejected();
            }
        });

    // Add this function to create/remove blur overlay
    function toggleBackgroundBlur(show) {
        const existingOverlay = document.getElementById('blur-overlay');
        if (show && !existingOverlay) {
            const overlay = document.createElement('div');
            overlay.id = 'blur-overlay';
            overlay.className = 'blur-background';
            document.body.appendChild(overlay);
        } else if (!show && existingOverlay) {
            existingOverlay.remove();
        }
    }

    // Start calling (audio-only)
    async function startCall(userName, userId, propertyId) {
        try {
            currentCallUserId = userId;
            currentCallChannel = `channel-${userId}`;
            
            document.getElementById('callModal').style.display = 'block';
            toggleBackgroundBlur(true); // Add blur when call starts
            
            document.getElementById('callUserName').innerText = `Calling ${userName}...`;
            document.getElementById('callStatus').innerHTML = '<p style="color: #4299e1;">Connecting...</p>';
            
            // Notify the backend about the call
            await axios.post('/account/call/notify', {
                userId,
                channel: currentCallChannel,
            });
            window.Echo.channel(`user.${userId}`)
                .listen('.call.ended', (event) => {
                    console.log('Call ended event received:', event);
                    document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Call Ended</p>';
                    setTimeout(() => {
                        // Clean up and hide modal
                        if (localTracks.audioTrack) {
                            localTracks.audioTrack.stop();
                            localTracks.audioTrack.close();
                        }
                        if (client) {
                            client.leave();
                        }
                        localTracks.audioTrack = null;
                        remoteUsers = {};
                        isCalling = false;
                        currentCallChannel = null;
                        currentCallUserId = null;
                        endCall();
                    }, 2000);
                })
                .listen('.call.rejected', (event) => {
                    console.log('Call rejected event received:', event);
                    document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Call Rejected</p>';
                    setTimeout(() => {
                        // Clean up and hide modal
                        if (localTracks.audioTrack) {
                            localTracks.audioTrack.stop();
                            localTracks.audioTrack.close();
                        }
                        if (client) {
                            client.leave();
                        }
                        localTracks.audioTrack = null;
                        remoteUsers = {};
                        isCalling = false;
                        currentCallChannel = null;
                        currentCallUserId = null;
                        endCall();
                    }, 2000);
                });
            
            
            await startAudioCall(userId);
        } catch (error) {
            console.error('Error in startCall:', error);
            document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Failed to connect. Please try again.</p>';
            toggleBackgroundBlur(false); // Remove blur if call fails
        }
    }

    // Start audio call (without video)
    async function startAudioCall(userId) {
        if (isCalling) {
            console.log('Already in a call');
            return;
        }

        const channel = `channel-${userId}`;
        const appId = '{{ env('AGORA_APP_ID') }}';

        try {
            // Fetch token
            const token = await fetchToken(channel,userId);

            // Create client if not exists
            if (!client) {
                client = AgoraRTC.createClient({
                    mode: 'rtc',
                    codec: 'h264'
                });

         
                // Set up remote user handling
                client.on('user-published', async (remoteUser, mediaType) => {
                    console.log('Remote user published:', remoteUser.uid, mediaType);
                    
                    await client.subscribe(remoteUser, mediaType);
                    console.log('Subscribed to remote user:', remoteUser.uid);

                    if (mediaType === 'audio') {
                        remoteUsers[remoteUser.uid] = remoteUser;
                        remoteUser.audioTrack.play();
                        console.log('Playing remote audio');
                        
                        // Update UI to show connected state
                        document.getElementById('callStatus').innerHTML = 
                            '<p style="color: #48bb78;">Call Connected</p>';
                    }
                });

                client.on('user-unpublished', (remoteUser, mediaType) => {
                    if (mediaType === 'audio') {
                        if (remoteUsers[remoteUser.uid]) {
                            remoteUsers[remoteUser.uid].audioTrack.stop();
                            delete remoteUsers[remoteUser.uid];
                        }
                    }
                });

                client.on('user-left', (remoteUser) => {
                    console.log('Remote user left:', remoteUser.uid);
                    if (remoteUsers[remoteUser.uid]) {
                        remoteUsers[remoteUser.uid].audioTrack.stop();
                        delete remoteUsers[remoteUser.uid];
                    }
                });
            }

            // Join the channel
            await client.join(appId, channel, token, uid);
            console.log('Joined channel:', channel);

            // Create and publish local audio track
            localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack({
                encoderConfig: {
                    sampleRate: 48000,
                    stereo: true,
                    bitrate: 128
                }
            });

            await client.publish([localTracks.audioTrack]);
            console.log('Published local audio track');

            isCalling = true;

        } catch (error) {
            console.error('Error in startAudioCall:', error);
            document.getElementById('callStatus').innerHTML = 
                '<p style="color: #e53e3e;">Call Failed</p>';
            throw error;
        }
    }

    // Toggle mute/unmute
    async function toggleMute() {
        if (!localTracks.audioTrack) return;

        const muteButton = document.getElementById('muteButton');
        const currentState = localTracks.audioTrack.enabled;

        try {
            await localTracks.audioTrack.setEnabled(!currentState);
            
            muteButton.innerHTML = currentState ? 
                '<i class="fas fa-microphone"></i> Unmute' : 
                '<i class="fas fa-microphone-slash"></i> Mute';
            muteButton.style.backgroundColor = currentState ? '#f56565' : '#48bb78';
        } catch (error) {
            console.error('Error toggling mute:', error);
        }
    }

    // End the call
    async function endCall() {
        try {
            if (currentCallUserId && currentCallChannel) {
                await axios.post('/account/call/end', {
                    userId: currentCallUserId,
                    channel: currentCallChannel
                });
            }
            
            await stopCall();
            document.getElementById('callModal').style.display = 'none';
            toggleBackgroundBlur(false); // Remove blur when call ends
            
            currentCallChannel = null;
            currentCallUserId = null;
        } catch (error) {
            console.error('Error ending call:', error);
            toggleBackgroundBlur(false); // Remove blur if error occurs
        }
    }

    // Stop the call
    async function stopCall() {
        if (!isCalling) return;

        try {
            // Stop and close local tracks
            if (localTracks.audioTrack) {
                localTracks.audioTrack.stop();
                localTracks.audioTrack.close();
            }

            // Stop all remote audio tracks
            Object.values(remoteUsers).forEach(user => {
                if (user.audioTrack) {
                    user.audioTrack.stop();
                }
            });

            // Clear remote users
            remoteUsers = {};

            // Leave the channel
            await client?.leave();
            
            isCalling = false;
            console.log('Call ended successfully');

        } catch (error) {
            console.error('Error stopping call:', error);
        }
    }

    // Clean up when leaving the page
    window.addEventListener('beforeunload', async () => {
        await stopCall();
    });

    // Clean up when leaving the page
    window.addEventListener('beforeunload', async () => {
        await stopCall();
    });

    function handleIncomingCall(data) {
        const modal = document.getElementById('callModal');
        toggleBackgroundBlur(true); // Add blur for incoming calls
        
        const userName = data.userName || 'Unknown User';
        
        document.getElementById('callUserName').innerText = `Incoming call from ${userName}`;
        document.getElementById('callControls').innerHTML = `
            <button onclick="acceptCall('${data.channel}', ${data.userId})" 
                style="background-color: #48bb78; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600;">
                <i class="fas fa-phone-alt"></i> Accept
            </button>
            <button onclick="rejectCall('${data.channel}', ${data.userId})"
                style="background-color: #e53e3e; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600;">
                <i class="fas fa-phone-slash"></i> Reject
            </button>
        `;
        
        modal.style.display = 'block';
    }

    function handleCallRejected() {
        document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Call Rejected</p>';
        setTimeout(() => {
            document.getElementById('callModal').style.display = 'none';
        }, 2000);
    }

    async function acceptCall(channel, callerId) {
        try {
            currentCallChannel = channel;
            currentCallUserId = callerId;
            
            document.getElementById('callControls').innerHTML = `
                <button onclick="toggleMute()" id="muteButton"
                    style="background-color: #48bb78; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600;">
                    <i class="fas fa-microphone-slash"></i> Mute
                </button>
                <button onclick="endCall()"
                    style="background-color: #e53e3e; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600;">
                    <i class="fas fa-phone-alt"></i> End Call
                </button>
            `;
            
            await startAudioCall(callerId);
        } catch (error) {
            console.error('Error accepting call:', error);
        }
    }

    async function rejectCall(channel, callerId) {
        try {
            await axios.post('/account/call/reject', {
                userId: callerId,
                channel: channel
            });
            
            document.getElementById('callModal').style.display = 'none';
            toggleBackgroundBlur(false); // Remove blur when call is rejected
        } catch (error) {
            console.error('Error rejecting call:', error);
            toggleBackgroundBlur(false); // Remove blur if error occurs
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

    .blur-background {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        backdrop-filter: blur(3px);
        background-color: rgba(0, 0, 0, 0.2);
        z-index: 999;
        pointer-events: all;
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
        z-index: 1000;
    }
</style>

@endsection