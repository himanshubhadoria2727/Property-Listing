@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div style="">
    @auth('account')

    @php
    $userId = auth('account')->id();

    // Fetch call logs for the current agent with proper column names
    try {
    $callLogs = \DB::table('call_logs')
    ->join('re_accounts', 'call_logs.user_id', '=', 're_accounts.id')
    ->select('call_logs.*', 're_accounts.username as caller_name', 're_accounts.id as caller_id')
    ->where('agent_id', $userId)
    ->orderBy('created_at', 'desc')
    ->paginate(8);
    } catch (\Exception $e) {
    $callLogs = collect([]);
    $queryError = $e->getMessage();
    }
    @endphp

    <div style="display: flex; flex-direction: column; gap: 24px;">
        <!-- Call Logs Section -->
        <div style="background: #ffffff; padding: 24px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);">
            <h3 style="font-weight: bold; font-size: 24px; color: #1a202c; margin-bottom: 16px;">Your Call Logs</h3>

            @if($callLogs->count() > 0)
            <div class="table-responsive">
                <table class="table table-striped" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background-color: #f1f1f1; color: #333;">
                            <th style="padding: 12px; text-align: left;">Caller Name</th>
                            <th style="padding: 12px; text-align: left;">Date & Time</th>
                            <th style="padding: 12px; text-align: left;">Status</th>
                            <th style="padding: 12px; text-align: left;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($callLogs as $log)
                        <tr style="border-bottom: 1px solid #eaeaea;">
                            <td style="padding: 12px;">{{ $log->caller_name }}</td>
                            <td style="padding: 12px;">{{ \Carbon\Carbon::parse($log->created_at)->format('M d, Y H:i:s') }}</td>
                            <td style="padding: 12px;">
                                <span class="badge badge-{{ $log->call_type === 'connected' ? 'success' : 'warning' }}" style="padding: 6px 12px; border-radius: 12px; background-color: {{ $log->call_type === 'connected' ? '#48bb78' : '#f6ad55' }}; color: white;">
                                    {{ ucfirst($log->call_type) }}
                                </span>
                            </td>
                            <td style="padding: 12px;">
                                <button onclick="startCall('{{$log->caller_name}}','{{ $log->caller_id }}')" class="btn btn-primary btn-sm" style="background-color: #3182ce; border: none; border-radius: 5px; padding: 8px 12px; color: white;">
                                    <i class="fas fa-phone"></i>
                                </button>
                                <button onclick="deleteCallLog({{ $log->id }})" class="btn btn-danger btn-sm" style="background-color: #e53e3e; border: none; border-radius: 5px; padding: 8px 12px; color: white; margin-left: 10px;">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            <!-- Pagination Links -->
            <div style="margin-top: 20px;" class="pagination">
                {{ $callLogs->links() }}
            </div>
            @else
            <p style="font-size: 16px; color: #718096;">No call logs found.</p>
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
    <div style="text-align: center; padding: 32px; background: #ffffff; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);">
        <p style="font-size: 20px; color: #4a5568;">Please log in to view your call logs.</p>
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
    let isCallBusy = false;
    let isCalling = false;
    let uid = Math.floor(Math.random() * 100000);
    let currentCallChannel = null;
    let currentCallUserId = null;
    let currentCallId = null;
    window.addEventListener('DOMContentLoaded', () => {
        // Remove a specific item from localStorage
        localStorage.removeItem('onCall');
    });

    // Function to get session ID from local storage
    function getSessionId() {
        return localStorage.getItem('sessionId'); // Adjust this if your session ID is stored differently
    }

    // Fetch the token for Agora client
    async function fetchToken(channelName, userId) {
        try {
            const response = await axios.post('/account/agora/token', {
                channelName,
                uid,
                sessionId: getSessionId() // Include sessionId
            });
            console.log('Token fetched successfully:', response.data);
            return response.data;
        } catch (error) {
            console.error('Error fetching token:', error);
            throw error;
        }
    }

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

    // Initialize Laravel Echo listener
    window.Echo.channel(`user.${userId}`)
        .listen('.call.ringing', (data) => {
            console.log('Call ringing:', data);
            if (data.channel === currentCallChannel) {
                document.getElementById('callStatus').innerHTML =
                    '<p style="color: #4299e1;">Ringing...</p>';
            }
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



    // Start calling (audio-only)
    async function startCall(userName, userId) {
        console.log('Starting call:', userName, userId);
        try {
            currentCallUserId = userId;
            currentCallChannel = `channel-${userId}`;

            document.getElementById('callModal').style.display = 'block';
            toggleBackgroundBlur(true);

            document.getElementById('callUserName').innerText = `Calling ${userName}...`;
            document.getElementById('callStatus').innerHTML = '<p style="color: #4299e1;">Connecting...</p>';

            // Notify the backend about the call
            const response = await axios.post('/account/call/notify', {
                userId: currentCallUserId,
                channel: currentCallChannel,
                sessionId: getSessionId() // Include sessionId
            });

            // Store the call ID
            currentCallId = response.data.callId;
            console.log('Call ID:', currentCallId);

            // Set a timeout for the call
            const callTimeout = setTimeout(async () => {
                // Log missed call
                await axios.post('/create/call-logs', {
                    user_id: userId,
                    call_type: "missed",
                    agent_id: getSessionId(),
                    channel: currentCallChannel,
                });
                console.log('Missed call logged');
                endCall(); // End the call after logging
            }, 30000); // 30 seconds timeout (adjust as needed)

            // Listen for call events
            window.Echo.channel(`user.${userId}`)
                .listen('.call.busy', (event) => {
                    if (event.callerId === window.userId) {
                        isCallBusy = true;
                        document.getElementById('callStatus').innerHTML =
                            '<p style="color: #e53e3e;">User is busy</p>';
                        clearTimeout(callTimeout); // Clear the timeout
                        setTimeout(() => {
                            document.getElementById('callModal').style.display = 'none';
                            toggleBackgroundBlur(false); // Remove blur when call ends
                            stopCall();
                        }, 2000);
                    }
                })
                .listen('.call.ringing', (event) => {
                    console.log('Call ringing event received:', event);
                    if (event.channel === currentCallChannel) {
                        document.getElementById('callStatus').innerHTML =
                            '<p style="color: #4299e1;">Ringing...</p>';
                    }
                })
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
            if (error.response && error.response.status === 409) {
                document.getElementById('callStatus').innerHTML =
                    '<p style="color: #e53e3e;">User is busy</p>';
                setTimeout(() => {
                    document.getElementById('callModal').style.display = 'none';
                    toggleBackgroundBlur(false);
                }, 2000);
            } else {
                console.error('Error in startCall:', error);
                document.getElementById('callStatus').innerHTML =
                    '<p style="color: #e53e3e;">Failed to connect. Please try again.</p>';
            }
            toggleBackgroundBlur(false);
        }
    }

    // Start audio call (without video)
    async function startAudioCall(userId) {
        if (isCalling) {
            console.log('Already in a call');
            return;
        }

        const channel = `channel-${userId}`;
        const appId = '{{ env("AGORA_APP_ID") }}';

        try {
            // Fetch token
            const token = await fetchToken(channel, userId);

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
                        localStorage.setItem('onCall', 'true');
                        const data = await axios.post("/create/call-logs", {
                            user_id: userId,
                            call_type: "connected",
                            agent_id: getSessionId(),
                            channel: channel,
                        });
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

                const response = await axios.post("/agent/session/update", {
                    agentId: window.userId,
                    is_available: false,
                    session_id: getSessionId(),
                });

                console.log("Session created:", response.data.message);

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
            // Update UI to show connected state

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
                    channel: currentCallChannel,
                    sessionId: getSessionId() // Include sessionId
                });
            }
            localStorage.removeItem('onCall');
            await stopCall();
            document.getElementById('callModal').style.display = 'none';
            toggleBackgroundBlur(false); // Remove blur when call ends

            currentCallChannel = null;
            currentCallUserId = null;
        } catch (error) {
            console.error('Error ending call:', error);
            toggleBackgroundBlur(false); // Remove blur if error occurs
        }
        try {
            const response = await axios.post('/agent/session/update', {
                agentId: window.userId,
                is_available: true,
                session_id: getSessionId(),
            });
            console.log(response.data.message);
        } catch (error) {
            console.error("Error updating agent session:", error);
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

    function handleCallRejected() {
        document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Call Rejected</p>';
        setTimeout(() => {
            document.getElementById('callModal').style.display = 'none';
        }, 2000);
    }

    // Function to delete a call log
    async function deleteCallLog(logId) {
        if (confirm('Are you sure you want to delete this call log?')) {
            try {
                const response = await axios.delete(`/call-logs/${logId}`);
                if (response.status === 200) {
                    location.reload(); // Reload the page to reflect changes
                }
            } catch (error) {
                console.error('Error deleting call log:', error);
                alert('Failed to delete the call log. Please try again.');
            }
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

<!-- Call Modal Structure -->
<div id="callModal" style="display: none;">
    <div style="padding: 20px; background: white; border-radius: 8px; box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);">
        <h4 id="callUserName"></h4>
        <div id="callStatus"></div>
        <button onclick="endCall()" class="btn btn-danger">End Call</button>
    </div>
</div>

@endsection