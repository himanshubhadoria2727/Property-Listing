@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div class="broadcast-container">
    <h1>Live Streaming with Agora</h1>

    <!-- Buttons for controlling the broadcast -->
    <div id="controls" class="controls">
        <button id="startButton" class="btn btn-primary" onclick="startBroadcast()">Start Broadcast</button>
        <button id="stopButton" class="btn btn-danger" style="display:none;" onclick="stopBroadcast()">Stop Broadcast</button>
        <button id="muteAudioButton" class="btn btn-secondary" style="display:none;" onclick="toggleAudio()">Mute Audio</button>
        <button id="toggleVideoButton" class="btn btn-secondary" style="display:none;" onclick="toggleVideo()">Turn Video Off</button>
    </div>

    <!-- Video element for local stream -->
    <div class="video-container">
        <video id="localVideo" autoplay muted class="video-stream"></video>
    </div>

    <!-- Shareable link for viewers to join -->
    <p id="broadcastLink" style="display:none;">
        Share this link with viewers to join:
        <a href="#" id="joinLink" target="_blank"></a>
    </p>

    <!-- User interaction prompt for starting playback -->
    <div id="startPlaybackPrompt" style="display: none;">
        <p>Your browser blocked autoplay. Please click below to start the video.</p>
        <button id="startPlayback" class="btn btn-primary">Start Playback</button>
    </div>
</div>

<!-- Agora SDK script -->
<script src="https://download.agora.io/sdk/release/AgoraRTC_N-4.22.0.js"></script>
<script>
    let client;
    let localTracks = {
        videoTrack: null,
        audioTrack: null
    };
    let isBroadcasting = false;
    let audioMuted = false;
    let videoOff = false;
    let uid = 0
    const channel = 'my-agora-channel';
    let token = null;

    function fetchToken(channelName) {
        return axios.post(`/account/agora/token`, {
                channelName,
                uid
            })
            .then(response => {
                // Assuming the token is in the response data
                const token = response.data; // Remove 'a' if it exists at the front
                console.log('token fetched', token);
                return token; // Return the token
            })
            .catch(error => {
                console.error('Error fetching the token:', error);
                throw error; // Rethrow the error for handling elsewhere
            });
    }

    async function startBroadcast() {
        if (isBroadcasting) {
            console.log('Broadcast already in progress.');
            return;
        }

        // Initialize Agora client
        client = AgoraRTC.createClient({
            mode: 'live',
            codec: 'vp8',
            role: 'host'
        });

        try {
            // Fetch the token
            const response = await fetchToken(channel);
            console.log('response', response)
            const token = response; // Make sure to access the token correctly from the response
            console.log('Fetched token:', token);

            // Use a valid Agora App ID
            const appId = '{{ env('AGORA_APP_ID') }}'; // Replace with your actual Agora App ID from your environment
            console.log('app_id', appId)
            if (!appId) {
                console.error('Agora App ID is missing.');
                return;
            }

            // Join the Agora channel with the token and App ID
            await client.join(appId, channel, token, 0);

            // Create and publish local tracks (audio and video)
            const [audioTrack, videoTrack] = await AgoraRTC.createMicrophoneAndCameraTracks();
            localTracks.audioTrack = audioTrack;
            localTracks.videoTrack = videoTrack;

            // Publish the local audio and video tracks
            await client.publish([localTracks.audioTrack, localTracks.videoTrack]);

            // Play the video and audio tracks locally
            localTracks.videoTrack.play('localVideo');
            localTracks.audioTrack.play();

            // Show controls for broadcasting
            document.getElementById('startButton').style.display = 'none';
            document.getElementById('stopButton').style.display = 'inline-block';
            document.getElementById('muteAudioButton').style.display = 'inline-block';
            document.getElementById('toggleVideoButton').style.display = 'inline-block';

            // Update broadcast link for viewers
            document.getElementById('broadcastLink').style.display = 'block';
            document.getElementById('joinLink').href = `/account/join/${channel}`;
            document.getElementById('joinLink').innerText = `${window.location.origin}/account/join/${channel}`;

            isBroadcasting = true;
        } catch (error) {
            console.error('Error starting broadcast:', error);
        }
    }

    async function stopBroadcast() {
        if (!isBroadcasting) {
            console.log('No active broadcast to stop.');
            return;
        }

        try {
            await client.leave();
            if (localTracks.videoTrack) localTracks.videoTrack.stop();
            if (localTracks.audioTrack) localTracks.audioTrack.stop();

            document.getElementById('startButton').style.display = 'inline-block';
            document.getElementById('stopButton').style.display = 'none';
            document.getElementById('muteAudioButton').style.display = 'none';
            document.getElementById('toggleVideoButton').style.display = 'none';
            document.getElementById('broadcastLink').style.display = 'none';

            isBroadcasting = false;
        } catch (error) {
            console.error('Error stopping broadcast:', error);
        }
    }

    function toggleAudio() {
        if (!localTracks.audioTrack) return;
        audioMuted = !audioMuted;

        if (audioMuted) {
            localTracks.audioTrack.setEnabled(false);
            document.getElementById('muteAudioButton').innerText = 'Unmute Audio';
        } else {
            localTracks.audioTrack.setEnabled(true);
            document.getElementById('muteAudioButton').innerText = 'Mute Audio';
        }
    }

    function toggleVideo() {
        if (!localTracks.videoTrack) return;
        videoOff = !videoOff;

        if (videoOff) {
            localTracks.videoTrack.setEnabled(false);
            document.getElementById('toggleVideoButton').innerText = 'Turn Video On';
        } else {
            localTracks.videoTrack.setEnabled(true);
            document.getElementById('toggleVideoButton').innerText = 'Turn Video Off';
        }
    }
    // Handling viewer-side stream
    async function joinBroadcast() {
        if (!client) {
            client = AgoraRTC.createClient({
                mode: 'live',
                codec: 'vp8'
            });
        }

        try {
            // Fetch the token for the specified channel
            const tokenResponse = await fetchToken(channel);
            const token = tokenResponse; // Get the token from the response

            // Use the Agora App ID from the environment variable
            const appId = '{{ env('
            AGORA_APP_ID ') }}'; // Ensure no spaces within the env call

            // Join the channel with the fetched token
            await client.join(appId, channel, token, null); // Using null for the user ID

            // Subscribe to the user published event
            client.on('user-published', async (user, mediaType) => {
                await client.subscribe(user, mediaType);
                if (mediaType === 'video') {
                    const remoteVideoTrack = user.videoTrack;
                    remoteVideoTrack.play('remoteVideo'); // Ensure that remote video track is played
                }
                if (mediaType === 'audio') {
                    const remoteAudioTrack = user.audioTrack;
                    remoteAudioTrack.play('remoteAudio'); // Ensure that audio track is played
                    console.log('Playing remote audio track.');
                }
            });

        } catch (error) {
            console.error('Error joining broadcast:', error);
        }
    }

    const urlParams = new URLSearchParams(window.location.search);
    const viewChannel = urlParams.get('channel');
    if (viewChannel) joinBroadcast();
</script>
@endsection