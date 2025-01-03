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
let isMuted = false;
let uid = Math.floor(Math.random() * 100000); // Fixed userId 23 as per your requirement
const agoraAppId = process.env.AGORA_APP_ID; // Replace with your Agora App ID
window.userId = userId;
window.Pusher = Pusher;
window.Echo = new Echo({
    broadcaster: "pusher",
    key: process.env.MIX_PUSHER_APP_KEY,
    cluster: process.env.MIX_PUSHER_APP_CLUSTER,
    forceTLS: true,
    auth: {
        headers: {
            "X-CSRF-TOKEN": document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
    },
});

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

        localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack();
        await client.publish([localTracks.audioTrack]);
        console.log("Local audio track published.");

        isCalling = true;
    } catch (error) {
        console.error("Error joining audio call:", error);
        await cleanupClient();
        alert("Failed to join the call. Please try again.");
    }
}

async function notifyCallEnded(channelName) {
    try {
        const response = await axios.post("/account/call/end", {
            channelName,
        });
        console.log("Call ended notification sent:", response.data);
    } catch (error) {
        console.error("Error sending call ended notification:", error);
    }
}

async function notifyCallRejected(channelName) {
    try {
        const response = await axios.post("/account/call/reject", {
            channelName,
        });
        console.log("Call rejected notification sent:", response.data);
    } catch (error) {
        console.error("Error sending call rejected notification:", error);
    }
}
// Function to stop the call
async function stopCall() {
    if (!isCalling) return;

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
        console.log("Call ended successfully");

        // Remove UI elements
        removeUi();
    } catch (error) {
        console.error("Error stopping call:", error);
        await cleanupClient(); // Ensure cleanup even on error
        removeUi(); // Ensure UI is cleaned up even on error
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
function showCallPopup(channelName, token) {
        const modal = document.createElement("div");
        modal.id = "call-popup"; // Add an ID to easily target the popup
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
    
        const subHeader = document.createElement("p");
        subHeader.textContent = "You have an incoming call. What would you like to do?";
        subHeader.classList.add("text-sm", "text-gray-600", "mb-6");
    
        const channelInfo = document.createElement("p");
        channelInfo.textContent = `Channel: ${channelName}`;
        channelInfo.classList.add("mb-4", "text-gray-700", "italic");
    
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
        acceptButton.onclick = async () => {
            try {
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
                await notifyCallRejected(channelName);
                removeUi();
                handleCallRejected();
            } catch (error) {
                console.error("Error rejecting the call:", error);
                removeUi(); // Ensure UI is cleaned up even on error
            }
        };
    
        modalContent.appendChild(closeButton);
        modalContent.appendChild(header);
        modalContent.appendChild(subHeader);
        modalContent.appendChild(channelInfo);
        modalContent.appendChild(acceptButton);
        modalContent.appendChild(declineButton);
        modal.appendChild(modalContent);
        document.body.appendChild(modal);
    
}

// Function to show call controls (Mute, End Call)
function showCallControls() {
    // Create modal overlay with blur effect
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
        clearInterval(timer);
         stopCall();
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

// Export the initiateCall function to make it available for import
async function initiateCall(userId) {
console.log("hello");
    if (!userId) {
        console.error('No userId provided to initiateCall');
        return;
    }   
    const activeUserId = window.userId; // Active user ID
    console.log("Active user ID:", activeUserId);
    const channelName = `channel-${userId}`; // Dynamic channel name based on userId
    const token = await fetchToken(channelName);
    console.log("Listening for incoming call notification on channel:", `user.${userId}`);

    // Listen on the correct channel for the specific user
    window.Echo.channel(`user.${userId}`)
    .listen('.incoming.call', (event) => {
        console.log('Call notification received:', event);
        if (activeUserId === Number(event.userId)) {
            showCallPopup(event.channel, token);
        }
    })
    .listen('.call.ended', (event) => {
        console.log('Call ended notification received:', event);
        handleCallEnded();
    })
    .listen('.call.rejected', (event) => {
        console.log('Call rejected notification received:', event);
        handleCallRejected();
    });

// Add new handler functions

}
function removeUi(){
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

// Update the ringtone path to use the correct public path
function playRingtone() {
    ringtone = new Audio('/themes/hously/audio/ringtone.mp3'); // Updated path
    ringtone.loop = true;
    ringtone.play().catch(error => {
        console.log("Audio playback failed:", error);
    });
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