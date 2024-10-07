@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<div class="container mx-auto py-8">
    <h1 class="text-3xl font-extrabold text-center mb-6 text-gray-800">Join Live Broadcast</h1>

    <div id="videoContainer" class="relative w-full max-w-4xl mx-auto mb-6 rounded-lg overflow-hidden shadow-lg">
        <video id="remoteVideo" class="video-responsive w-full h-200 bg-black" autoplay controls></video>
    </div>

    <div id="audioContainer" class="hidden">
        <audio id="remoteAudio" controls class="hidden"></audio>
    </div>

    <div class="flex space-x-6 justify-around mt-6">
        <button id="toggleAudio" class="btn btn-primary btn-base mr-2">
            <i class="fas fa-volume-up mr-1"></i>Mute Audio
        </button>
        <button id="fullScreen" class="btn btn-secondary btn-base">
            <i class="fas fa-expand mr-1"></i>Fullscreen
      </button>
    </div>
</div>

<script src="https://download.agora.io/sdk/release/AgoraRTC_N-4.22.0.js"></script>
<script>
    const appId = `{{ env('AGORA_APP_ID') }}`;
    const channel = 'my-agora-channel';
    let client;
    let uid = null;
    let token = '';
    let remoteAudioTrack = null;
    let remoteVideoTrack = null;
    let isAudioMuted = false;  // Track the audio state

    async function joinBroadcast() {
        client = AgoraRTC.createClient({
            mode: 'live',
            codec: 'vp8',
            role: 'audience'
        });

        try {
            const tokenJoin = await fetchToken(channel);
            token = tokenJoin;
            if (!appId) {
                throw new Error('Agora App ID is missing.');
            }

            await client.join(appId, channel, token, uid);

            client.on('user-published', async (user, mediaType) => {
                await client.subscribe(user, mediaType);
                if (mediaType === 'video') {
                    remoteVideoTrack = user.videoTrack;
                    remoteVideoTrack.play('remoteVideo');
                }
                if (mediaType === 'audio') {
                    remoteAudioTrack = user.audioTrack;
                    remoteAudioTrack.play('remoteAudio');
                    document.getElementById('audioContainer').classList.remove('hidden');
                }
            });

            client.on('user-unpublished', user => {
                console.log('User unpublished:', user);
            });

        } catch (error) {
            console.log('Error joining broadcast:', error);
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        joinBroadcast();
    });

    AgoraRTC.onAutoplayFailed = () => {
        console.log('Autoplay failed, user interaction required.');
    };

    // Audio Toggle Button
    const toggleAudioButton = document.getElementById('toggleAudio');
    toggleAudioButton.addEventListener('click', () => {
        if (remoteAudioTrack) {
            if (isAudioMuted) {
                remoteAudioTrack.play('remoteAudio');  // Unmute audio
                toggleAudioButton.textContent = 'Mute Audio';
                toggleAudioButton.classList.remove('bg-red-500');
                toggleAudioButton.classList.add('bg-blue-500');
                console.log('Audio unmuted');
            } else {
                remoteAudioTrack.stop();  // Mute audio
                toggleAudioButton.textContent = 'Unmute Audio';
                toggleAudioButton.classList.remove('bg-blue-500');
                toggleAudioButton.classList.add('bg-red-500');
                console.log('Audio muted');
            }
            isAudioMuted = !isAudioMuted;
        }
    });

    // Fullscreen functionality
    document.getElementById('fullScreen').addEventListener('click', () => {
        const videoElement = document.getElementById('remoteVideo');
        if (videoElement.requestFullscreen) {
            videoElement.requestFullscreen();
        } else if (videoElement.mozRequestFullScreen) { 
            videoElement.mozRequestFullScreen();
        } else if (videoElement.webkitRequestFullscreen) { 
            videoElement.webkitRequestFullscreen();
        } else if (videoElement.msRequestFullscreen) { 
            videoElement.msRequestFullscreen();
        }
    });

    async function fetchToken(channelName) {
        return axios.post(`/account/agora/token`, { channelName, uid })
            .then(response => response.data)
            .catch(error => {
                console.error('Error fetching the token:', error);
                throw error;
            });
    }
</script>

<style>
    #videoContainer {
        max-width: 100%;
    }

    @media (min-width: 1024px) {
        .video-responsive {
            height: 500px;
        }
    }

    @media (max-width: 1023px) {
        .video-responsive {
            height: auto;
        }
    }
</style>
@endsection
