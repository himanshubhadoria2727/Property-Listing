import AgoraRTC from "agora-rtc-sdk-ng";
import axios from "axios";
import Echo from "laravel-echo";
import Pusher from "pusher-js";

let client;
let localTracks = {
    audioTrack: null,
};
let remoteUsers = [];
let isCalling = false;
let isInCall = false;
let isMuted = false;
let uid = Math.floor(Math.random() * 100000); // Fixed userId 23 as per your requirement
const agoraAppId = process.env.AGORA_APP_ID; // Replace with your Agora App ID
window.addEventListener('DOMContentLoaded', () => {
    // Remove a specific item from localStorage
    localStorage.removeItem('onCall');
});
window.userId = userId;
window.Pusher = Pusher;
window.Echo = new Echo({
    broadcaster: "pusher",
    key: process.env.MIX_PUSHER_APP_KEY,
    cluster: process.env.MIX_PUSHER_APP_CLUSTER,
    forceTLS: true,
    enabledTransports: ['ws', 'wss'],

    disableStats: true,
    auth: {
        headers: {
            "X-CSRF-TOKEN": document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
    },
});

// Add debug logging
window.Echo.connector.pusher.connection.bind('state_change', states => {
    console.log('Pusher state changed:', states);
});

window.Echo.connector.pusher.connection.bind('connected', () => {
    console.log('Successfully connected to Pusher');
});

window.Echo.connector.pusher.connection.bind('error', error => {
    console.error('Pusher connection error:', error);
});

// Add this at the beginning of your file to verify environment variables
console.log('Environment Variables:', {
    PUSHER_KEY: process.env.MIX_PUSHER_APP_KEY,
    PUSHER_CLUSTER: process.env.MIX_PUSHER_APP_CLUSTER,
    USER_ID: userId
});

// Add this to verify channel subscription
const channel = window.Echo.channel(`author.${userId}`);
console.log('Subscribed to channel:', channel);

// Function to fetch Agora token from the server
function fetchToken(channelName) {
    return axios
        .post("/account/agora/token", {
            channelName,
            uid,
        })
        .then((response) => {
            const token = response.data;
            console.log("Token fetched:", token);
            return token;
        })
        .catch((error) => {
            console.error("Error fetching the token:", error);
            throw error;
        });
}

// Function to join an Agora audio call
async function joinAudioCall(channelName, token, activeUserId) {
    console.log("Joining audio call on channel:", channelName);
    const appId = process.env.MIX_AGORA_APP_ID;
    
    try {
        // Ensure cleanup before joining
        await cleanupClient();

        client = AgoraRTC.createClient({ 
            mode: "rtc", 
            codec: "vp8",
            enableAudioVolumeIndicator: true,
            forceSafariHTTPS: false,
            security: false
        });
        
        // Request permissions explicitly before joining
        await navigator.mediaDevices.getUserMedia({ audio: true });

        // Set up event listeners
        client.on("user-published", async (user, mediaType) => {
            await client.subscribe(user, mediaType);
            if (mediaType === "audio") {
                user.audioTrack.play();
                remoteUsers.push(user);
            }
        });

        await client.join(appId, channelName, token, uid);
        console.log("Successfully joined Agora channel:", channelName);
        localStorage.setItem('onCall', 'true');
        isInCall = true;    
        isCalling = true;
        localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack();
        await client.publish([localTracks.audioTrack]);
        console.log("Local audio track published.");

        // Call the createSession API
        const response = await axios.post("/agent/session/update", {
            agentId: activeUserId,
            is_available: false,
            sessionId: axios.defaults.headers.common['X-Session-Id'],
        });
        console.log("Agent call session activated:", response.data);
        
    } catch (error) {
        isInCall = false;
        isCalling = false;
        console.error("Error joining audio call:", error);
        await cleanupClient();
        alert("Failed to join the call. Please try again.");
    }
}

async function notifyCallEnded(channelName) {
    try {
        const response = await axios.post("/account/call/end", {
            channel: channelName,
            userId: window.userId,
        });
        localStorage.removeItem('onCall');
        
        console.log("Call ended notification sent:", response.data);
    } catch (error) {
        console.error("Error sending call ended notification:", error);
    }
    try {
        const response = await axios.post('/agent/session/update', {
            agentId: window.userId,
            is_available: true,
        });
        console.log(response.data.message);
    } catch (error) {
        console.error("Error updating agent session:", error);
    }
}

async function notifyCallBusy(channelName,callerId) {
    try {
        const response = await axios.post("/account/call/busy", {
            channelName,
            userId: window.userId,
            callerId: callerId
        });
        console.log("Call busy notification sent:", response.data);
    } catch (error) {
        console.error("Error sending call busy notification:", error);
    }
}

async function notifyCallRejected(channelName) {
    try {
        const response = await axios.post("/account/call/reject", {
            channelName,
            userId: window.userId,
        });
        console.log("Call rejected notification sent:", response.data);
    } catch (error) {
        console.error("Error sending call rejected notification:", error);
    }
}

// Add the notifyCallRinging function with the other notification functions
async function notifyCallRinging(channelName) {
    try {
        const response = await axios.post("/account/call/ringing", {
            channelName,
            userId: window.userId,
        });
        console.log("Call ringing notification sent:", response.data);
    } catch (error) {
        console.error("Error sending call ringing notification:", error);
    }
}

// Function to stop the call
async function stopCall() {
    if (!isCalling && !isInCall) return;

    const channelName = `channel-${window.userId}`;
    try {
        await notifyCallEnded(channelName);

        if (localTracks.audioTrack) {
            await localTracks.audioTrack.stop();
            await localTracks.audioTrack.close();
            localTracks.audioTrack = null;
        }

        await cleanupClient();
        isCalling = false;
        isInCall = false;
        console.log("Call ended successfully");

        removeUi();
    } catch (error) {
        console.error("Error stopping call:", error);
        isCalling = false;
        isInCall = false;
        await cleanupClient();
        removeUi();
    }
}

// Function to toggle mute/unmute
async function toggleMute() {
    if (!localTracks.audioTrack) return;

    const muteButton = document.getElementById("muteButton");
    const isMuted = !localTracks.audioTrack.enabled;

    localTracks.audioTrack.setEnabled(isMuted);
    
    muteButton.innerHTML = isMuted
        ? '<i class="fas fa-microphone"></i>'
        : '<i class="fas fa-microphone-slash"></i>';
    muteButton.style.backgroundColor = isMuted ? "#4CAF50" : "#f44336";
}

// Add this function to create backdrop
function createBackdrop() {
    const backdrop = document.createElement("div");
    backdrop.id = "call-backdrop";
    backdrop.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(3px);
        -webkit-backdrop-filter: blur(3px);
        z-index: 9998;
    `;
    return backdrop;
}

// Function to show the call popup
function showCallPopup(channelName, token, event,activeUserId) {
    
    // Add backdrop
    const backdrop = createBackdrop();
    document.body.appendChild(backdrop);
    const callerName = event.callerName;
    const modal = document.createElement("div");
    modal.id = "incoming-call-popup";
    modal.style.cssText = `
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 320px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        z-index: 9999;
        padding: 20px;
        text-align: center;
    `;

    modal.innerHTML = `
        <div style="margin-bottom: 20px;">
            <i class="fas fa-phone-volume fa-3x" style="color: #4CAF50;"></i>
        </div>
        <h3 style="margin: 0 0 10px; color: #333; font-size: 18px;">Incoming Call</h3>
        <p style="margin: 0 0 20px; color: #666; font-size: 14px;">${callerName || 'Someone'} is calling you</p>
        <div id="call-buttons" style="display: flex; justify-content: center; gap: 10px;">
            <button id="accept-call" style="
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                background-color: #4CAF50;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
            ">
                <i class="fas fa-phone"></i> Accept
            </button>
            <button id="decline-call" style="
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                background-color: #f44336;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
            ">
                <i class="fas fa-phone-slash"></i> Decline
            </button>
        </div>
        <div id="call-controls" style="display: none; justify-content: center; gap: 10px; margin-top: 20px;">
            <button id="muteButton" style="
                width: 40px;
                height: 40px;
                border: none;
                border-radius: 50%;
                background-color: #4CAF50;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
            ">
                <i class="fas fa-microphone"></i>
            </button>
            <button id="endCallButton" style="
                width: 40px;
                height: 40px;
                border: none;
                border-radius: 50%;
                background-color: #f44336;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
            ">
                <i class="fas fa-phone-slash"></i>
            </button>
        </div>
    `;
    playRingtone();

    document.body.appendChild(modal);

    // Add event listeners
    modal.querySelector('#accept-call').onclick = async () => {
        try {
            stopRingtone(); // Stop ringtone when call is accepted
            await joinAudioCall(channelName, token,activeUserId);
            // Hide call buttons and show controls
            modal.querySelector('#call-buttons').style.display = 'none';
            modal.querySelector('#call-controls').style.display = 'flex';
            // Update modal title
            modal.querySelector('h3').textContent = 'Ongoing Call';
            modal.querySelector('p').textContent = 'Call in progress';
        } catch (error) {
            console.error("Error accepting call:", error);
        }
    };
    

    modal.querySelector('#decline-call').onclick = async () => {
        stopRingtone();
        try {
            stopRingtone(); // Stop ringtone when call is declined
            await notifyCallRejected(channelName);
            modal.remove();
        } catch (error) {
            console.error("Error rejecting call:", error);
        }
    };

    // Add event listeners for call controls
    modal.querySelector('#muteButton').onclick = toggleMute;
    modal.querySelector('#endCallButton').onclick = stopCall;
}

// Helper function to update mute button state
function updateMuteButton(button) {
    const isMuted = localTracks.audioTrack && !localTracks.audioTrack.enabled;
    button.style.backgroundColor = isMuted ? '#EF4444' : '#10B981';
    button.innerHTML = isMuted ? `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" clip-rule="evenodd" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2" />
        </svg>
    ` : `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11a7 7 0 01-7 7m0 0a7 7 0 01-7-7m7 7v4m0 0H8m4 0h4m-4-8a3 3 0 01-3-3V5a3 3 0 116 0v6a3 3 0 01-3 3z" />
        </svg>
    `;
}

// Export the initiateCall function to make it available for import
async function initiateCall(userId) {
console.log("hello");
    if (!userId) {
        console.error('No userId provided to initiateCall');
        return;
    }   
    const activeUserId = window.userId; // Active user ID
    console.log("Active user ID:", activeUserId);
    const sessionId = localStorage.getItem('sessionId');
    console.log("Session ID:", sessionId);
    const channelName = `channel-${sessionId}`; // Dynamic channel name based on userId
    console.log("Channel name:", channelName);
    const token = await fetchToken(channelName);
    console.log("Listening for incoming call notification on channel:", `author.${userId}`);

    // Listen on the correct channel for the specific user
    window.Echo.channel(`user.${userId}`)
    .listen('.incoming.call', async (event) => {
        console.log("user",userId);
        console.log('Incoming call event received:', event);
        if (activeUserId === Number(event.userId) && sessionId === event.sessionId) {
            console.log('Call status check - isInCall:', isInCall, 'isCalling:', isCalling);
    
            // Check if user is already in a call
            if (localStorage.getItem('onCall') && localStorage.getItem('onCall') === 'true') {
                console.log('Already in a call, sending busy notification');
                await notifyCallBusy(event.channel, event.callerId);
                return;
            }
            // Continue with normal call flow if not busy
            await notifyCallRinging(event.channel);
            showCallPopup(channelName, token, event,activeUserId);
        }
    })
    .listen('.call.ended', (event) => {
        console.log('Call ended notification received:', event);
        const modal = document.querySelector("#incoming-call-popup");
        if (modal) {
            const statusText = modal.querySelector('p');
            statusText.textContent = 'Call ended';
            setTimeout(() => {
                handleCallEnded();
            }, 2000);
        }
    })
    .listen('.call.rejected', (event) => {
        notifyCallEnded(channelName);
        console.log('Call rejected notification received:', event);
        const modal = document.querySelector("#incoming-call-popup");
        if (modal) {
            const statusText = modal.querySelector('p');
            statusText.textContent = 'Call rejected';
            setTimeout(() => {
                handleCallRejected();
            }, 2000);
        }
    })
    .error((error) => {
        console.error('Channel error:', error);
    });

// Add new handler functions

}
function removeUi() {
    stopRingtone();
    const modal = document.querySelector("#incoming-call-popup");
    const backdrop = document.querySelector("#call-backdrop");
    
    if (modal) {
        modal.remove();
    }
    if (backdrop) {
        backdrop.remove();
    }
}
function handleCallEnded() {
    removeUi();
    stopCall();
}

function handleCallRejected() {
    removeUi();
    stopCall();
}

initiateCall(userId);
// Start the process of initiating the call
async function startAudioCall(propertyId) {
    if (!userId) {
        console.error("No userId provided to startAudioCall");
        return;
    }

    console.log("Starting audio call function...");

    if (isCalling) {
        console.log("Already in a call, returning...");
        return;
    }

    const channel = `channel-${userId}`;
    const appId = process.env.MIX_AGORA_APP_ID;
    console.log("appId:", appId);

    try {
        // Ensure client is properly cleaned up before creating a new one
        if (client) {
            await client.leave();
            client.removeAllListeners();
            client = null;
        }

        console.log("Creating Agora client...");
        client = AgoraRTC.createClient({
            mode: "rtc",
            codec: "vp8",
            enableAudioVolumeIndicator: true,
            forceSafariHTTPS: false,
            security: false
        });

        // Request permissions explicitly
        try {
            await navigator.mediaDevices.getUserMedia({ audio: true });
        } catch (err) {
            console.error("Failed to get user media permission:", err);
            throw new Error("Microphone permission denied");
        }

        // Add event listeners for remote users before joining
        client.on("user-published", async (user, mediaType) => {
            console.log("Remote user published:", user.uid, mediaType);
            await client.subscribe(user, mediaType);

            if (mediaType === "audio") {
                console.log("Playing remote audio track");
                user.audioTrack.play();
            }
        });

        client.on("user-unpublished", async (user, mediaType) => {
            console.log("Remote user unpublished:", user.uid, mediaType);
            if (mediaType === "audio") {
                user.audioTrack.stop();
            }
        });

        console.log("Joining Agora channel...");
        await client.join(appId, channel, token, uid);

        console.log("Creating audio track...");
        localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack();

        console.log("Publishing audio track...");
        await client.publish([localTracks.audioTrack]);

        isCalling = true;
        console.log("Audio call started successfully.");
    } catch (error) {
        console.error("Error starting audio call:", error);
        throw error;
    }
}
let ringtone=null;
// Update the ringtone path to use the correct public path
window.addEventListener('load', function() {
    const dummyElement = document.getElementById('dummy-element');
    dummyElement.click(); // Simulate a click event on the hidden element
});
function playRingtone() {
    ringtone = new Audio('/media/ringtone.mp3'); // Updated path
    ringtone.loop = true;
    ringtone.play().catch(error => {
        console.log("Audio playback failed:", error);
    });
}

// Add a function to check and cleanup client state
async function cleanupClient() {
    try {
        if (client) {
            if (client.connectionState === 'CONNECTED') {
                await client.leave();
            }
            else if (client.connectionState === 'CONNECTING') {
                await new Promise(resolve => setTimeout(resolve, 1000));
                await client.leave();
            }
            client.removeAllListeners();
            client = null;
            isCalling = false;
            isInCall = false;
        }
    } catch (error) {
        console.error("Error cleaning up client:", error);
        client = null;
        isCalling = false;
        isInCall = false;
    }
}

// Add function to stop ringtone
function stopRingtone() {
    if (ringtone) {
        ringtone.pause();
        ringtone.currentTime = 0;
        ringtone = null;
    }
}

export {stopCall}   