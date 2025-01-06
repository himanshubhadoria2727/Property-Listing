import AgoraRTC from "agora-rtc-sdk-ng";
import axios from "axios";
import Echo from "laravel-echo";
import Pusher from "pusher-js";

let client;
let localTracks = {
    audioTrack: null,
    videoTrack: null
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
const channel = window.Echo.channel(`user.${userId}`);
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
async function joinAudioCall(channelName, token) {
    console.log("Joining audio call on channel:", channelName);
    const appId = process.env.MIX_AGORA_APP_ID;
    console.log("appId:", appId);
    
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
        try {
            await navigator.mediaDevices.getUserMedia({ audio: true });
        } catch (err) {
            console.error("Failed to get user media permission:", err);
            throw new Error("Microphone permission denied");
        }

        // Set up event listeners
        client.on("user-published", async (user, mediaType) => {
            await client.subscribe(user, mediaType);
            if (mediaType === "audio") {
                user.audioTrack.play();
                remoteUsers.push(user);
                console.log("Playing remote user audio.");
            }
        });

        client.on("user-unpublished", (user) => {
            if (user.audioTrack) {
                user.audioTrack.stop();
                remoteUsers = remoteUsers.filter((u) => u !== user);
                console.log("Remote user stopped audio.");
            }
        });

        await client.join(appId, channelName, token, uid);
        console.log("Successfully joined Agora channel:", channelName);
        isInCall = true;
        isCalling = true;

        console.log("isInCall:", isInCall, "isCalling:", isCalling);
        localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack();
        await client.publish([localTracks.audioTrack]);
        console.log("Local audio track published.");
        
    } catch (error) {
        console.error("Error joining audio call:", error);
        isInCall = false;
        isCalling = false;
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

// Add this function near other notification functions
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
    if (!isCalling) return;

    try {
        // Get the channel name before cleanup
        const channelName = client?.channelName;

        if (localTracks.audioTrack) {
            await localTracks.audioTrack.stop();
            await localTracks.audioTrack.close();
            localTracks.audioTrack = null;
        }

        await cleanupClient();
        isCalling = false;
        
        // Notify server about call ending if we have the channel name
        if (channelName) {
            await notifyCallEnded(channelName);
        }
        
        console.log("Call stopped successfully");
        removeUi();

    } catch (error) {
        console.error("Error stopping call:", error);
    }
}

// Function to toggle mute/unmute
async function toggleMute() {
    if (!localTracks.audioTrack) return;

    const muteButton = document.getElementById("muteButton");
    const isMuted = !localTracks.audioTrack.enabled;

    await localTracks.audioTrack.setEnabled(isMuted);

    muteButton.innerHTML = isMuted
        ? '<i class="fas fa-microphone"></i> Unmute'
        : '<i class="fas fa-microphone-slash"></i> Mute';
    muteButton.style.backgroundColor = isMuted ? "#f56565" : "#48bb78";
}

// Function to show the call popup
function showCallPopup(channelName, token, event) {
    // Play ringtone when showing call popup
    
    const modal = document.createElement("div");
    modal.id = "call-popup";
    modal.classList.add(
        "fixed",
        "top-0",
        "left-0",
        "w-full",
        "h-full",
        "bg-gray-900",
        "bg-opacity-70",
        "flex",
        "items-center",
        "justify-center",
        "z-[9999]",
        "transition",
        "duration-300",
        "ease-in-out"
    );
    
    const modalContent = document.createElement("div");
    modalContent.classList.add(
        "bg-white",
        "rounded-2xl",
        "shadow-2xl",
        "p-6",
        "text-center",
        "w-96",
        "relative",
        "animate-scale-in"
    );
    
    const closeButton = document.createElement("button");
    closeButton.textContent = "✕";
    closeButton.classList.add(
        "absolute",
        "top-4",
        "right-4",
        "text-gray-500",
        "hover:text-gray-800",
        "text-xl",
        "cursor-pointer"
    );
    closeButton.onclick = () => modal.remove();
    
    const header = document.createElement("h2");
    header.textContent = "Incoming Call";
    header.classList.add("text-2xl", "font-bold", "text-gray-800", "mb-2");
    
    const callerInfo = document.createElement("p");
    callerInfo.textContent = `from ${event.callerName}`;
    callerInfo.classList.add("text-lg", "text-gray-700", "mb-4");
    
    const subHeader = document.createElement("p");
    subHeader.textContent = "You have an incoming call. What would you like to do?";
    subHeader.classList.add("text-sm", "text-gray-600", "mb-6");
    
    
    const acceptButton = document.createElement("button");
    acceptButton.textContent = "Accept";
    acceptButton.classList.add(
        "bg-green-500",
        "text-white",
        "font-semibold",
        "px-6",
        "py-2",
        "rounded-full",
        "shadow-md",
        "hover:bg-green-600",
        "transition",
        "duration-300",
        "ease-in-out",
        "mr-4"
    );

    playRingtone();

    acceptButton.onclick = async () => {
        try {
            stopRingtone(); // Stop ringtone when call is accepted
            await joinAudioCall(channelName, token);
            modal.remove();
            showCallControls();
        } catch (error) {
            console.error("Error accepting the call:", error);
        }
    };
    
    const declineButton = document.createElement("button");
    declineButton.textContent = "Decline";
    declineButton.classList.add(
        "bg-red-500",
        "text-white",
        "font-semibold",
        "px-6",
        "py-2",
        "rounded-full",
        "shadow-md",
        "hover:bg-red-600",
        "transition",
        "duration-300",
        "ease-in-out"
    );
    declineButton.onclick = async () => {
        try {
            stopRingtone(); // Stop ringtone when call is declined
            await notifyCallRejected(channelName);
            removeUi();
            handleCallRejected();
        } catch (error) {
            console.error("Error rejecting the call:", error);
            removeUi();
        }
    };
    
    modalContent.appendChild(closeButton);
    modalContent.appendChild(header);
    modalContent.appendChild(callerInfo);
    modalContent.appendChild(subHeader);
    modalContent.appendChild(acceptButton);
    modalContent.appendChild(declineButton);
    modal.appendChild(modalContent);
    document.body.appendChild(modal);
}

// Function to show call controls (Mute, End Call)
function showCallControls() {
    // Create modal overlay with blur effect
    isCalling = true;
    isInCall = true;
    const modalOverlay = document.createElement("div");
    modalOverlay.id = "call-controls";
    modalOverlay.classList.add(
        "fixed",
        "inset-0",
        "bg-gray-900/50",
        "backdrop-blur-sm",
        "z-[9999]",
        "flex",
        "items-center",
        "justify-center",
        "animate-fade-in"
    );

    // Create modal container
    const modalContent = document.createElement("div");
    modalContent.classList.add(
        "bg-white",
        "rounded-2xl",
        "shadow-2xl",
        "p-8",
        "max-w-md",
        "w-full",
        "mx-4",
        "animate-scale-in",
        "text-center"
    );

    // Call Status
    const statusDiv = document.createElement("div");
    statusDiv.classList.add("mb-6");
    
    const statusIcon = document.createElement("div");
    statusIcon.innerHTML = `
        <div class="w-16 h-16 bg-green-100 rounded-full mx-auto mb-4 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
        </div>
    `;
    
    const statusText = document.createElement("h3");
    statusText.textContent = "Call Connected";
    localStorage.setItem('onCall', 'true');
    statusText.classList.add("text-xl", "font-semibold", "text-gray-800", "mb-2");

    // Call Timer
    const timerDiv = document.createElement("div");
    timerDiv.id = "call-timer";
    timerDiv.classList.add(
        "text-gray-600",
        "font-medium",
        "mb-8"
    );
    timerDiv.textContent = "00:00";

    // Start timer
    let seconds = 0;
    const timer = setInterval(() => {
        seconds++;
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        timerDiv.textContent = `${String(minutes).padStart(2, '0')}:${String(remainingSeconds).padStart(2, '0')}`;
    }, 1000);

    // Controls Container
    const controlsDiv = document.createElement("div");
    controlsDiv.classList.add(
        "flex",
        "items-center",
        "justify-center",
        "gap-6"
    );

    // Mute Button
    const muteButton = document.createElement("button");
    muteButton.id = "muteButton";
    muteButton.classList.add(
        "w-16",
        "h-16",
        "rounded-full",
        "flex",
        "items-center",
        "justify-center",
        "transition-all",
        "duration-300",
        "ease-in-out",
        "focus:outline-none",
        "focus:ring-2",
        "focus:ring-offset-2"
    );

    // End Call Button
    const endCallButton = document.createElement("button");
    endCallButton.classList.add(
        "w-16",
        "h-16",
        "bg-red-500",
        "rounded-full",
        "flex",
        "items-center",
        "justify-center",
        "transition-all",
        "duration-300",
        "ease-in-out",
        "hover:bg-red-600",
        "focus:outline-none",
        "focus:ring-2",
        "focus:ring-offset-2",
        "focus:ring-red-500"
    );
    endCallButton.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
        </svg>
    `;

    // Event Listeners
    muteButton.onclick = async () => {
        await toggleMute();
        updateMuteButton(muteButton);
    };

    endCallButton.onclick = async () => {
        stopCall();
        clearInterval(timer);
        await stopCall(); // This will now handle the notification
        modalOverlay.remove();
    };

    // Initial mute button state
    updateMuteButton(muteButton);

    // Append elements
    statusDiv.appendChild(statusIcon);
    statusDiv.appendChild(statusText);
    controlsDiv.appendChild(muteButton);
    controlsDiv.appendChild(endCallButton);
    
    modalContent.appendChild(statusDiv);
    modalContent.appendChild(timerDiv);
    modalContent.appendChild(controlsDiv);
    modalOverlay.appendChild(modalContent);
    document.body.appendChild(modalOverlay);

    // Prevent clicking outside from closing the modal
    modalOverlay.addEventListener('click', (e) => {
        if (e.target === modalOverlay) {
            e.preventDefault();
            e.stopPropagation();
        }
    });
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

// Add this at the top of the file with other global variables
let currentChannel = null;

// Update the initiateCall function to clean up existing listeners
async function initiateCall(userId) {
    console.log("hello");
    if (!userId) {
        console.error('No userId provided to initiateCall');
        return;
    }   
    const activeUserId = window.userId;
    console.log("Active user ID:", activeUserId);
    const channelName = `channel-${userId}`;
    const token = await fetchToken(channelName);
    
    // Clean up existing channel subscription if it exists
    if (currentChannel) {
        currentChannel.stopListening('.incoming.call');
        currentChannel.stopListening('.call.ended');
        currentChannel.stopListening('.call.rejected');
        currentChannel = null;
    }

    // Create new channel subscription
    currentChannel = window.Echo.channel(`user.${userId}`);
    
    console.log("Listening for incoming call notification on channel:", `user.${userId}`);

    // Set up new listeners
    currentChannel
    .listen('.incoming.call', async (event) => {
        console.log('Incoming call event received:', event);
    
        if (activeUserId === Number(event.userId)) {
            console.log('Call status check - isInCall:', isInCall, 'isCalling:', isCalling);
            // Check if user is already in a call
            if (localStorage.getItem('onCall') && localStorage.getItem('onCall') === 'true') {
                console.log('Already in a call, sending busy notification');
                await notifyCallBusy(event.channel, event.callerId);
                return;
            }
    
            // Continue with normal call flow if not busy
            await notifyCallRinging(event.channel);
            showCallPopup(event.channel, token, event);
        }
    }) 
        .listen('.call.ended', (event) => {
            console.log('Call ended notification received:', event);
            localStorage.removeItem('onCall');
            handleCallEnded();
        })
        .listen('.call.rejected', (event) => {
            console.log('Call rejected notification received:', event);
            handleCallRejected();
        })
        .error((error) => {
            console.error('Channel error:', error);
        });
}

function removeUi(){
    stopRingtone();
    const controlsDiv = document.querySelector("#call-controls");
    if (controlsDiv) {
        controlsDiv.remove();
    }
    const modal = document.querySelector("#call-popup");
    if (modal) {
        modal.remove();
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

// Add at the top with other global variables
let ringtone = null;

// Update the playRingtone function
function playRingtone() {
    try {
        // Stop any existing ringtone first
        stopRingtone();
        
        // Create new Audio instance
        ringtone = new Audio('/media/ringtone.mp3');
        ringtone.loop = true;
        
        // Add error handling for loading
        ringtone.addEventListener('error', (e) => {
            console.error('Error loading ringtone:', e);
        });

        // Play with proper promise handling
        const playPromise = ringtone.play();
        if (playPromise !== undefined) {
            playPromise
                .then(() => {
                    console.log('Ringtone playing successfully');
                })
                .catch(error => {
                    console.error('Ringtone playback failed:', error);
                });
        }
    } catch (error) {
        console.error('Error in playRingtone:', error);
    }
}

// Update the stopRingtone function
function stopRingtone() {
    if (ringtone) {
        try {
            ringtone.pause();
            ringtone.currentTime = 0;
            ringtone = null;
        } catch (error) {
            console.error('Error stopping ringtone:', error);
        }
    }
}

// Add a function to check and cleanup client state
async function cleanupClient() {
    try {
        if (client) {
            // Check if client is in connected state
            if (client.connectionState === 'CONNECTED') {
                await client.leave();
            }
            // Check if client is in connecting state
            else if (client.connectionState === 'CONNECTING') {
                await new Promise(resolve => setTimeout(resolve, 1000)); // Wait for 1 second
                await client.leave();
            }
            client.removeAllListeners();
            client = null;
        }
    } catch (error) {
        console.error("Error cleaning up client:", error);
        // Force cleanup even if there's an error
        client = null;
    }
}

export {stopCall}