@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')
<h1>Join Live Broadcast</h1>

<video id="remoteVideo" autoplay controls></video>

<script src="https://download.agora.io/sdk/release/AgoraRTC_N-4.22.0.js"></script>
<script>
    const appId = `{{ env('AGORA_APP_ID') }}`;
    const channel = 'my-agora-channel'; // The channel name should match the one used by the broadcaster
    let client;
    let uid = 1
    let token = '007eJxTYDh09Ij+k1L/exW3Qi+XXSrlSeP9s8lgx93gk5UcpaHz7x1QYLAwMTIySDRJSbYwMzQxSUqyNDE1T0wzTE6xtDQzNTA0e8HyM60hkJHh5SwBRkYGCATxBRhyK3UT0/OLEnWTMxLz8lJzGBgAsmAl+w==';

    // Debugging helper function
    function logDebug(message, data = null) {
        console.log(`[DEBUG] ${message}`, data);
    }

    // Fetch token from the server
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

    async function joinBroadcast() {

        function testAudioContext() {
            try {
                const audioContext = new(window.AudioContext || window.webkitAudioContext)();
                console.log('AudioContext created:', audioContext);

                // Test if the context's current time is progressing
                console.log('AudioContext current time:', audioContext.currentTime);
            } catch (error) {
                console.error('Error initializing AudioContext:', error);
            }
        }

        testAudioContext();
        client = AgoraRTC.createClient({
            mode: 'live',
            codec: 'vp8',
            role: 'audience'
        });

        try {
            const tokenJoin= await fetchToken(channel);
            token = tokenJoin;
            if (!appId) {
                throw new Error('Agora App ID is missing.');
            }
            await client.join(appId, channel, token, uid);

            client.on('user-published', async (user, mediaType) => {
                await client.subscribe(user, mediaType);
                if (mediaType === 'video') {
                    const remoteVideoTrack = user.videoTrack;
                    remoteVideoTrack.play('remoteVideo');
                }
                if (mediaType === 'audio') {
                    const remoteAudioTrack = user.audioTrack;
                    if (remoteAudioTrack) {
                        remoteAudioTrack.play('remoteAudio'); // This will play the audio through the default audio output
                    }
                }
            });
            client.on('user-unpublished', user => {
                logDebug('User unpublished:', user);
                // Handle user leaving the broadcast if needed
            });
        } catch (error) {
            logDebug('Error joining broadcast:', error);
        }
    }

    joinBroadcast();
</script>
@endsection