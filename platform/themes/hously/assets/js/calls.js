// Import Axios for API calls and Echo for real-time broadcasting
import axios from 'axios';
import AgoraRTC from 'agora-rtc-sdk-ng';
import Echo from 'laravel-echo';
import Pusher from 'pusher-js';

// Initialize Agora client and variables
let client;
let localTracks = {
    audioTrack: null,
};
let isCalling = false;
let uid = Math.floor(Math.random() * 1000); // Generate a random UID

// Get CSRF token from meta tag
const xsrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
console.log('Retrieved CSRF token from meta:', xsrfToken);

if (!xsrfToken) {
    console.error('CSRF token not found in meta tags');
}

// Configure Laravel Echo for real-time broadcasting
window.Pusher = Pusher;
window.Echo = new Echo({
    broadcaster: 'pusher',
    key: process.env.MIX_PUSHER_APP_KEY,
    cluster: process.env.MIX_PUSHER_APP_CLUSTER,
    forceTLS: true,
    auth: {
        headers: {
            'X-CSRF-TOKEN': xsrfToken,
        },
    },
});

// Debug listeners with more detailed logging
window.Echo.connector.pusher.connection.bind('state_change', states => {
    console.log('Connection state:', states);
    console.log('Pusher key:', process.env.MIX_PUSHER_APP_KEY);
    console.log('Channel auth headers:', window.Echo.options.auth.headers);
});

window.Echo.connector.pusher.connection.bind('connected', () => {
    console.log('Successfully connected to Pusher');
    console.log('Connection details:', {
        key: process.env.MIX_PUSHER_APP_KEY,
        cluster: process.env.MIX_PUSHER_APP_CLUSTER,
        auth: window.Echo.options.auth
    });
});

window.Echo.connector.pusher.connection.bind('error', error => {
    console.error('Pusher connection error:', error);
    console.log('Current connection config:', {
        key: process.env.MIX_PUSHER_APP_KEY,
        cluster: process.env.MIX_PUSHER_APP_CLUSTER
    });
});

// Add a request interceptor to axios to always include the CSRF token
axios.defaults.headers.common['X-CSRF-TOKEN'] = xsrfToken;
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.withCredentials = true;

// Fetch Agora token from the server
function fetchToken(channelName) {
    console.log('Fetching Agora token for channel:', channelName);
    return axios.post(`/account/agora/token`, {
        channelName,
        uid,
    })
        .then(response => {
            const token = response.data;
            console.log('Token fetched:', token);
            return token;
        })
        .catch(error => {
            console.error('Error fetching the token:', error);
            throw error;
        });
}

// Join an Agora audio call
async function joinAudioCall(userId) {
    console.log('Attempting to join audio call for user:', userId);

    if (isCalling) {
        console.log('Already in a call. Returning...');
        return;
    }

    const channel = `channel-${userId}`;
    const appId = '{{ env("AGORA_APP_ID") }}';

    if (!appId) {
        console.error('Agora App ID is missing.');
        return;
    }

    try {
        // Fetch token
        const token = await fetchToken(channel);

        // Create client if not exists
        if (!client) {
            client = AgoraRTC.createClient({
                mode: 'rtc',
                codec: 'vp8',
            });
        }

        // Join channel
        await client.join(appId, channel, token, uid);

        // Create and publish audio track
        const [audioTrack] = await AgoraRTC.createMicrophoneTracks();
        localTracks.audioTrack = audioTrack;
        
        await client.publish([audioTrack]);

        // Setup client event handlers
        client.on('user-published', async (user, mediaType) => {
            await client.subscribe(user, mediaType);
            if (mediaType === 'audio') {
                user.audioTrack.play();
            }
        });

        client.on('user-unpublished', (user) => {
            if (user.audioTrack) {
                user.audioTrack.stop();
            }
        });

        isCalling = true;
        console.log(`Successfully joined channel: ${channel}`);

    } catch (error) {
        console.error('Error joining the audio call:', error);
        throw error;
    }
}

function coding() {
    console.log('coding');
}

// Setup Echo listener for incoming calls
function setupCallListener(userId) {
    console.log('Setting up call listener for user:', userId);
    console.log('Channel name:', `user.${userId}`);

    const channel = window.Echo.private(`user.${userId}`);
    
    channel.error((error) => {
        console.error('Channel error:', error);
        console.log('Channel state:', channel.subscription.state);
    });

    channel.subscribed(() => {
        console.log('Successfully subscribed to channel');
    });

    channel.listen('.incoming.call', (event) => {
        try {
            console.log('Received incoming call event:', event);

            // Validate the event payload
            if (!event.userId || !event.channel) {
                throw new Error('Invalid event payload: Missing userId or channel');
            }

            // Display modal with the call details
            const { userId: callerId, channel } = event;
            showModal(callerId, channel);
        } catch (eventError) {
            console.error('Error processing the incoming call event:', eventError);
        }
    });
}

// Show the modal pop-up
function showModal(userId, channel) {
    console.log('Displaying modal for incoming call...');
    const modal = document.createElement('div');
    modal.classList.add('modal', 'fixed', 'top-0', 'left-0', 'right-0', 'bottom-0', 'bg-gray-800', 'bg-opacity-50', 'flex', 'justify-center', 'items-center');
    
    const modalContent = document.createElement('div');
    modalContent.classList.add('bg-white', 'p-6', 'rounded-lg', 'shadow-lg', 'w-1/3', 'text-center');

    const modalHeader = document.createElement('h2');
    modalHeader.textContent = `Incoming Call from Agent in channel ${channel}`;
    modalHeader.classList.add('text-lg', 'font-bold', 'mb-4');

    const modalBody = document.createElement('p');
    modalBody.textContent = `User ID: ${userId} is calling. Would you like to join the call?`;
    modalBody.classList.add('mb-4');

    const acceptButton = document.createElement('button');
    acceptButton.textContent = 'Accept Call';
    acceptButton.classList.add('bg-green-500', 'text-white', 'py-2', 'px-4', 'rounded', 'hover:bg-green-600');
    acceptButton.onclick = async () => {
        try {
            await joinAudioCall(userId);
            closeModal(modal);
        } catch (error) {
            console.error('Failed to join call:', error);
            alert('Failed to join call. Please try again.');
        }
    };

    const declineButton = document.createElement('button');
    declineButton.textContent = 'Decline Call';
    declineButton.classList.add('bg-red-500', 'text-white', 'py-2', 'px-4', 'rounded', 'hover:bg-red-600', 'ml-4');
    declineButton.onclick = async () => {
        try {
            // Notify server about call rejection (you'll need to implement this endpoint)
            await axios.post('/account/call/reject', { userId, channel });
        } catch (error) {
            console.error('Error declining call:', error);
        }
        closeModal(modal);
    };

    modalContent.appendChild(modalHeader);
    modalContent.appendChild(modalBody);
    modalContent.appendChild(acceptButton);
    modalContent.appendChild(declineButton);

    modal.appendChild(modalContent);
    document.body.appendChild(modal);
}

async function closeModal(modal) {
    console.log('Closing the modal...');
    if (isCalling) {
        await stopCall();
    }
    modal.remove();
}

 const initialize = function(userId) {
    console.log('Initializing audio call system for user:', userId);
    setupCallListener(userId);
};

window.initialize = initialize;

export { joinAudioCall, initialize };
