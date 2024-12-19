@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div class="broadcast-container">
    <h1>Live Virtual Tour of Property: {{ $property->name }}</h1>
    <div style="display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 20px;">
            @foreach($property->images as $image)
            <img
                style="flex: 1 1 calc(25% - 10px); max-width: calc(25% - 10px); border-radius: 8px; height: auto; transition: transform 0.3s ease; cursor: pointer;"
                src="{{ RvMedia::getImageUrl($image, 'large', false, RvMedia::getDefaultImage()) }}"
                alt="{{ $property->name }}"
                onmouseover="this.style.transform='scale(1.1)'"
                onmouseout="this.style.transform='scale(1)'"
                onclick="openModal('{{ RvMedia::getImageUrl($image, 'large', false, RvMedia::getDefaultImage()) }}')">
            @if($loop->index == 3)
            @break
            @endif
            @endforeach
        </div>
    <!-- Buttons for controlling the broadcast -->
    <!-- Include FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<div class="video-container" style="position: relative; width: 100%; height: 100%; background-color: black;">
    <!-- Video element for local stream -->
    <video id="localVideo" autoplay muted class="video-stream" 
        style="width: 100%; height: 100%; object-fit: cover;">
    </video>

    <!-- Start button at the top -->
    <!-- Start Button -->
<button id="startButton" 
    onclick="startBroadcast()" 
    style="position: absolute; top: 20px; left: 50%; transform: translateX(-50%); 
           background-color: #333; border: none; color: white; 
           cursor: pointer; z-index: 10; border-radius: 50%; padding: 15px;">
    <i class="fas fa-play-circle" style="font-size: 30px;"></i>
</button>

<!-- Bottom Controls Container -->
<div id="controls" 
    style="position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); 
           background-color: #333; display: flex; gap: 20px; padding: 0.5vmax; 
           border-radius: 15px 15px 0 0; z-index: 10;">
    
    <!-- Stop Button -->
    <button id="stopButton" 
        style="background-color: transparent; border: none; color: red; 
               cursor: pointer; display: none; padding: 10px;" 
        onclick="stopBroadcast()">
        <i class="fas fa-stop-circle" style="font-size: 2vmax;"></i> <!-- Smaller icon size -->
    </button>
    
    <!-- Mute/Unmute Audio Button -->
    <button id="muteAudioButton" 
        style="background-color: transparent; border: none; color: white; cursor: pointer; display: none; 
               padding: 10px;" 
        onclick="toggleAudio()">
        <i class="fas fa-microphone" style="font-size: 2vmax;"></i> <!-- Smaller icon size -->
    </button>

    <!-- Turn Video On/Off Button -->
    <button id="toggleVideoButton" 
        style="background-color: transparent; border: none; color: white; cursor: pointer; display: none; 
               padding: 10px;" 
        onclick="toggleVideo()">
        <i class="fas fa-video" style="font-size: 2vmax;"></i> <!-- Smaller icon size -->
    </button>
</div>

</div>


    <!-- Shareable link for viewers to join -->
    <p id="broadcastLink" style="display:none;">
        Share this link with viewers to join:
        <a href="#" id="joinLink" target="_blank"></a>
    </p>
    
    <!-- Modal -->
    <div id="imageModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8); z-index: 1000; align-items: center; justify-content: center;">
        <span style="position: absolute; top: 20px; right: 20px; color: #fff; font-size: 2rem; cursor: pointer;" onclick="closeModal()">&times;</span>
        <img id="modalImage" style="max-width: 90%; max-height: 80%; border-radius: 8px;">
    </div>
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

    const muteAudioButton = document.getElementById('muteAudioButton');
    const muteAudioIcon = muteAudioButton.querySelector('i');

    if (audioMuted) {
        localTracks.audioTrack.setEnabled(false);
        muteAudioIcon.className = 'fas fa-microphone-slash'; // Update to muted icon
    } else {
        localTracks.audioTrack.setEnabled(true);
        muteAudioIcon.className = 'fas fa-microphone'; // Update to unmuted icon
    }
}

function toggleVideo() {
    if (!localTracks.videoTrack) return;

    videoOff = !videoOff;

    const toggleVideoButton = document.getElementById('toggleVideoButton');
    const toggleVideoIcon = toggleVideoButton.querySelector('i');

    if (videoOff) {
        localTracks.videoTrack.setEnabled(false);
        toggleVideoIcon.className = 'fas fa-video-slash'; // Update to video off icon
    } else {
        localTracks.videoTrack.setEnabled(true);
        toggleVideoIcon.className = 'fas fa-video'; // Update to video on icon
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
    function openModal(imageUrl) {
        const modal = document.getElementById('imageModal');
        const modalImage = document.getElementById('modalImage');
        modalImage.src = imageUrl;
        modal.style.display = 'flex';
    }

    function closeModal() {
        const modal = document.getElementById('imageModal');
        modal.style.display = 'none';
    }

    document.getElementById('imageModal').addEventListener('click', (e) => {
        if (e.target === e.currentTarget) {
            closeModal();
        }
    });
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
