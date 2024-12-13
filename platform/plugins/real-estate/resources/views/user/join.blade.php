@extends('plugins/real-estate::themes.dashboard.UserLayouts.userLayout')

@section('content')
<div style="max-width: 100%; margin: 0 auto; padding: 20px; font-family: Arial, sans-serif;">
    <nav style="background-color: #1F2937; padding: 10px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
        <a href="/" style="color: #fff; font-size: 1.25rem; font-weight: bold; text-decoration: none;">Home</a>
        <div style="display: flex; gap: 15px;">
            <a href="/properties" style="color: #D1D5DB; text-decoration: none; font-size: 1rem;">Properties</a>
            <a href="/live-broadcast" style="color: #D1D5DB; text-decoration: none; font-size: 1rem;">Live Broadcast</a>
            <a href="/contact" style="color: #D1D5DB; text-decoration: none; font-size: 1rem;">Contact</a>
        </div>
    </nav>

    <!-- Video Container -->
    <div id="videoContainer" style="position: relative; width: 90vw; height: 35vmax; margin: 0 auto 20px; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
        
        <!-- Thumbnail and Loader -->
        <div id="thumbnail" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: #000; display: flex; justify-content: center; align-items: center; color: #fff; font-size: 1.5rem; font-weight: bold; z-index: 10;">
            <div class="loader"> </div> <!-- Loader -->
            <div class="" style="margin-left: 13px;font-size: 2vmax;"> Please wait while stream starts</div> <!-- Loader -->
        </div>

        <video id="remoteVideo" style="width: 100%; height: 100%; background-color: #000;" autoplay controls></video>

        <!-- Control Buttons Container with Round Background -->
        <div style="position: absolute; top: 50%; right: 20px; transform: translateY(-50%); display: flex; flex-direction: column; gap: 10px; padding: 10px; background-color: rgba(0, 0, 0, 0.5); border-radius: 50px;">
            <button id="toggleAudio" style=" color: #fff;margin-bottom: 10px; border: none; font-size: 1rem; border-radius: 50px; cursor: pointer;">
                <i id="audioIcon" class="fas fa-volume-up" style="font-size: 1.2rem;"></i>
            </button>

            <button id="fullScreen" style=" color: #fff; border: none; font-size: 1rem; border-radius: 50px; cursor: pointer;">
                <i class="fas fa-expand" style="font-size: 1.2rem;"></i>
            </button>
        </div>

    </div>

    <!-- Property Details Section in Card -->
    <div style="background-color: #ffffff; border-radius: 12px; padding: 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
        <h2 style="font-size: 1.5rem; font-weight: 600; color: #1F2937; margin-bottom: 10px;">{{ $property->name }}</h2>
        <h4 style="font-size: 1rem; font-weight: 400; color: #1F2937; margin-bottom: 10px;">{{ $property->location }}</h4>

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

        <span style="margin-top: 30px; color: #4B5563; font-size: 1rem; line-height: 1.5;">
            {!! $property->content !!}
        </span>
    </div>

    <!-- Modal -->
    <div id="imageModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8); z-index: 1000; align-items: center; justify-content: center;">
        <span style="position: absolute; top: 20px; right: 20px; color: #fff; font-size: 2rem; cursor: pointer;" onclick="closeModal()">&times;</span>
        <img id="modalImage" style="max-width: 90%; max-height: 80%; border-radius: 8px;">
    </div>
</div>

<script src="https://download.agora.io/sdk/release/AgoraRTC_N-4.22.0.js"></script>
<script>
    const appId = `{{ env('AGORA_APP_ID') }}`;
    const propertyId = `{{ $property->id }}`;
    const channel = `channel-${propertyId}`;
    let client;
    let uid = null;
    let token = '';
    let remoteAudioTrack = null;
    let remoteVideoTrack = null;
    let isAudioMuted = false; // Track the audio state

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
                    // Hide thumbnail when video starts playing
                    document.getElementById('thumbnail').style.display = 'none';
                }
                if (mediaType === 'audio') {
                    remoteAudioTrack = user.audioTrack;
                    remoteAudioTrack.play('remoteAudio');
                    document.getElementById('audioContainer').style.display = 'block';
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
    const audioIcon = document.getElementById('audioIcon');
    toggleAudioButton.addEventListener('click', () => {
        if (remoteAudioTrack) {
            if (isAudioMuted) {
                remoteAudioTrack.play('remoteAudio'); // Unmute audio
                audioIcon.classList.replace('fa-volume-mute', 'fa-volume-up');
                console.log('Audio unmuted');
            } else {
                remoteAudioTrack.stop(); // Mute audio
                audioIcon.classList.replace('fa-volume-up', 'fa-volume-mute');
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
        return axios.post(`/account/agora/token`, {
                channelName,
                uid
            })
            .then(response => response.data)
            .catch(error => {
                console.error('Error fetching the token:', error);
                throw error;
            });
    }

    // Modal Functions
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
    /* Loader Style */
    .loader {
        border: 4px solid #f3f3f3; /* Light gray */
        border-top: 4px solid #3498db; /* Blue */
        border-radius: 50%;
        width: 30px;
        height: 30px;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>
@endsection
