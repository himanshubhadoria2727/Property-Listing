@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div class="broadcast-container">
    <h1>Live Virtual Tour of Property: {{ $property->name }}</h1>

    <div class="property-details">
        <div class="property-images">
            @foreach ($property->images as $image)
                <img src="{{ asset($image) }}" alt="Property Image" class="property-image">
            @endforeach
        </div>
        <div class="property-description">
            <h2>Description</h2>
            <p>{{ $property->description }}</p>
        </div>
        <!-- <div class="property-features">
            <h2>Features</h2>
            <ul>
                @foreach ($property->features as $feature)
                    <li>{{ $feature }}</li>
                @endforeach
            </ul>
        </div> -->
    </div>

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
    let uid = 0;
    const propertyId = `{{ $property->id }}`;
    const channel = `channel-${propertyId}`; // Ensure this is a valid channel name
    let token = null;

    function fetchToken(channelName) {
        return axios.post(`/account/agora/token`, {
                channelName,
                uid
            })
            .then(response => {
                const token = response.data; // Assuming token is returned directly
                console.log('token fetched', token);
                return token;
            })
            .catch(error => {
                console.error('Error fetching the token:', error);
                throw error; // Rethrow the error for handling elsewhere
            });
    }

    function isValidChannelName(channelName) {
        const regex = /^[a-zA-Z0-9 !#$%&()+\-:;<=>.?@[\]^{|}~]{1,64}$/; // Allowed characters
        return regex.test(channelName);
    }

    async function startBroadcast() {
        if (isBroadcasting) {
            console.log('Broadcast already in progress.');
            return;
        }

        // Validate channel name
        if (!isValidChannelName(channel)) {
            console.error('Invalid channel name:', channel);
            return;
        }

        // Initialize Agora client
        client = AgoraRTC.createClient({
            mode: 'live',
            codec: 'vp8',
            role: 'host'
        });

        try {
            console.log('Attempting to join channel:', channel);
            const response = await fetchToken(channel);
            const token = response; // Make sure to access the token correctly

            const appId = `{{ env('AGORA_APP_ID') }}`; // Replace with your actual Agora App ID
            if (!appId) {
                console.error('Agora App ID is missing.');
                return;
            }

            // Join the Agora channel with the token and App ID
            await client.join(appId, channel, token, uid);

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
            document.getElementById('joinLink').href = `/account/join/${propertyId}`;
            document.getElementById('joinLink').innerText = `${window.location.origin}/account/join/${propertyId}`;

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
            if (localTracks.videoTrack) {
                localTracks.videoTrack.stop();
                localTracks.videoTrack.close(); // Close the video track to turn off the camera
            }
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

        // Validate channel name before joining
        if (!isValidChannelName(channel)) {
            console.error('Invalid channel name for joining:', channel);
            return;
        }

        try {
            const tokenResponse = await fetchToken(channel);
            const token = tokenResponse;

            const appId = `{{ env('AGORA_APP_ID')}}`;
            if (!appId) {
                console.error('Agora App ID is missing.');
                return;
            }

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

<style>
    .broadcast-container {
        padding: 20px;
        max-width: 800px;
        margin: auto;
        text-align: center;
    }

    .property-details {
        margin-bottom: 20px;
    }

    .property-images {
        display: flex;
        overflow: auto;
    }

    .property-image {
        max-width: 100%;
        margin: 5px;
    }

    .video-container {
        margin-top: 20px;
    }

    .video-stream {
        width: 100%;
        height: auto;
        max-height: 480px; /* Set maximum height for video */
    }

    .controls {
        margin: 20px 0;
    }

    .btn {
        margin: 5px;
    }
</style>
@endsection
