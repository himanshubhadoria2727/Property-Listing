@if($properties->isNotEmpty())
<div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-[30px]">
    @foreach($properties as $property)
    <div class="overflow-hidden duration-500 ease-in-out bg-white shadow property-item group rounded-xl dark:bg-slate-800 hover:shadow-lg dark:shadow-gray-700 dark:hover:shadow-gray-700">
        <div class="relative overflow-hidden">
            <a href="{{ $property->url }}">
                <img src="{{ RvMedia::getImageUrl($property->image, 'large', false, RvMedia::getDefaultImage()) }}" alt="{{ $property->name }}" class="transition-all duration-500 hover:scale-110">
            </a>
            <div class="absolute top-6 end-6">
                <button type="button" class="text-lg text-red-600 bg-white rounded-full shadow btn btn-icon dark:bg-slate-900 dark:shadow-gray-700 add-to-wishlist" aria-label="{{ __('Add to wishlist') }}" data-box-type="property" data-id="{{ $property->id }}">
                    <i class="mdi mdi-heart-outline"></i>
                </button>

                <button
                    type="button"
                    class="text-lg text-red-600 bg-white rounded-full shadow btn btn-icon dark:bg-slate-900 dark:shadow-gray-700 start-call"
                    data-property-id="{{ $property->id }}"
                    data-user-id="{{ $property->author_id }}"
                    href="javascript:void(0);" onclick="toggleModal('chatsModal', {{ $property->id }})">
                    <i class="mdi mdi-chat"></i>
                </button>
                <div id="chatsModal" class="hidden">
                    <div data-property-id="{{ $property->id }}" data-user-id="{{ $property->author_id }}" onclick="toggleModal('chatsModal', this.dataset.propertyId, this.dataset.userId)"></div>
                </div>

                <button
                    type="button"
                    class="text-lg text-red-600 bg-white rounded-full shadow btn btn-icon dark:bg-slate-900 dark:shadow-gray-700 start-call"
                    data-property-id="{{ $property->id }}"
                    data-user-id="{{ $property->author_id }}"
                    onclick="startCall({{ json_encode(DB::table('re_accounts')->where('id', $property->author_id)->value(DB::raw("CONCAT(first_name, ' ', last_name)")) ?? 'User') }}, {{ $property->author_id }}, {{ $property->id }})">
                    <i class="mdi mdi-phone"></i>
                </button>
                
            </div>
            @if($property->images && $imagesCount = count($property->images))
            <div class="absolute top-6 start-6">
                <div class="flex items-center justify-center content-center p-2 pt-2.5 bg-gray-700 rounded-md bg-opacity-60 text-white text-sm">
                    <i class="leading-none mdi mdi-camera-outline me-1"></i>
                    <span class="leading-none">{{ $imagesCount }}</span>
                </div>
            </div>
            @endif
            <div class="absolute bottom-0 flex text-sm start-0 item-info-wrap">
                <span class="flex items-center py-1 ps-6 pe-4 text-white">{{ $property->category->name }}</span>
                {!! $property->status->toHtml() !!}
            </div>
        </div>

        <div class="p-6">
            <div class="truncate">
                <a href="{{ $property->url }}" class="text-lg font-medium uppercase duration-500 ease-in-out hover:text-primary" title="{{ $property->name }}">
                    {!! BaseHelper::clean($property->name) !!}
                </a>
                @if($property->city->name || $property->state->name)
                <p class="truncate text-slate-600 dark:text-slate-300">{{ $property->city->name ? $property->city->name . ', ' : '' }}{{ $property->state->name }}</p>
                @else
                <p class="truncate text-slate-600 dark:text-slate-300">&nbsp;</p>
                @endif
            </div>

            <ul class="flex items-center justify-between py-3 ps-0 mb-0 list-none border-b dark:border-gray-800">
                @if ($numberBedrooms = $property->number_bedroom)
                <li class="flex items-center me-2">
                    <i class="text-2xl text-primary mdi mdi-bed-empty me-2"></i>
                    <span>
                        {{ $numberBedrooms == 1 ? __('1 Bed') : __(':number Beds', ['number' => $numberBedrooms]) }}
                    </span>
                </li>
                @endif

                @if ($numberBathrooms = $property->number_bathroom)
                <li class="flex items-center me-2">
                    <i class="text-2xl text-primary mdi mdi-shower me-2"></i>
                    <span>
                        {{ $numberBathrooms == 1 ? __('1 Bath') : __(':number Baths', ['number' => $numberBathrooms]) }}
                    </span>
                </li>
                @endif

                @if ($property->square)
                <li class="flex items-center me-2">
                    <i class="text-2xl text-primary mdi mdi-arrow-collapse-all me-2"></i>
                    <span>{{ $property->square_text }}</span>
                </li>
                @endif
            </ul>

            <ul class="flex flex-wrap gap-3 items-center justify-between pt-4 ps-0 mb-0 list-none">
                <li>
                    <span class="text-slate-400">{{ __('Price') }}</span>
                    <p class="text-lg font-semibold">{{ format_price($property->price, $property->currency) }}</p>
                </li>

                @if (RealEstateHelper::isEnabledReview())
                <li>
                    <span class="text-slate-400">{{ __('Rating') }}</span>
                    @include(Theme::getThemeNamespace('views.real-estate.partials.review-star'), ['avgStar' => $property->reviews_avg_star, 'count' => $property->reviews_count])
                </li>
                @endif
            </ul>
        </div>
    </div>
    @endforeach
</div>
@else
<div class="my-16 text-center">
    <svg class="mx-auto h-24 w-24 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 21v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21m0 0h4.5V3.545M12.75 21h7.5V10.75M2.25 21h1.5m18 0h-18M2.25 9l4.5-1.636M18.75 3l-1.5.545m0 6.205l3 1m1.5.5l-1.5-.5M6.75 7.364V3h-3v18m3-13.636l10.5-3.819" />
    </svg>
    <p class="mt-3 text-xl text-gray-500 dark:text-gray-300">{{ __('No properties found.') }}</p>
</div>
@endif

<!-- Add this overlay div before the modal -->
<div id="callModalOverlay" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); backdrop-filter: blur(5px); z-index: 9998;"></div>

<!-- Update the modal styling -->
<div id="callModal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #fff; padding: 32px; border-radius: 12px; box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1); width: 450px; max-width: 90%; animation: fadeIn 0.5s ease; z-index: 9999;">
    <h4 id="callUserName" style="font-size: 20px; font-weight: 600; margin-bottom: 16px; color: #1a202c; text-align: center;">User Name</h4>

    <div id="callControls" style="display: flex; justify-content: space-around; align-items: center; gap: 16px; margin-top: 20px;">
        <button
            onclick="toggleMutebtn()"
            id="mutebtn"
            style="background-color: #48bb78; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600; display: flex; align-items: center; gap: 8px; transition: background-color 0.2s, transform 0.2s">
            <i class="mdi mdi-microphone" style="font-size: 18px;"></i> Mute
        </button>

        <button
            onclick="endCallBtn()"
            style="background-color: #e53e3e; color: white; padding: 14px 28px; border-radius: 50px; border: none; font-weight: 600; display: flex; align-items: center; gap: 8px; transition: background-color 0.2s, transform 0.2s;">
            <i class="mdi mdi-phone-alt" style="font-size: 18px;"></i> End Call
        </button>
    </div>

    <!-- Call Status (Optional) -->
    <div id="callStatus" style="margin-top: 20px; text-align: center;">
        <p style="font-size: 16px; color: #4a5568;">Connecting...</p>
    </div>
</div>

<script src="https://download.agora.io/sdk/release/AgoraRTC_N-4.22.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<script>
    let client = null;
    let localTracks = {
        audioTrack: null
    };
    let remoteUsers = {};
    let isCallBusy = false;
    let isCalling = false;
    let uid = Math.floor(Math.random() * 100000);
    let currentCallChannel = null;
    let currentCallUserId = null;
    let sessionId; // Declare a global variable for sessionId
    window.addEventListener('DOMContentLoaded', () => {
        // Remove a specific item from localStorage
        
            axios.post('/account/call/end', {
                channel: channel,
                userId: currentCallUserId,
                sessionId: sessionId
            });
            localStorage.removeItem('onCall');    
    });

    async function fetchToken(channelName, userId) {
        try {
            const response = await axios.post('/account/agora/token', {
                channelName,
                uid
            });
            console.log('Token fetched successfully:', response.data);
            return response.data;
        } catch (error) {
            console.error('Error fetching token:', error);
            throw error;
        }
    }

    async function startCall(userName, userId, propertyId) {
        try {
            currentCallUserId = userId;
            currentCallChannel = `channel-${userId}`;

            showCallModal();
            document.getElementById('callUserName').innerText = `Calling ${userName}...`;
            document.getElementById('callStatus').innerHTML = '<p style="color: #4299e1;">Connecting...</p>';

            // Notify the backend about the call and get the session ID
            const response = await axios.post('/account/call/notify', {
                userId: currentCallUserId,
                channel: currentCallChannel,
            });
            
            sessionId = response.data.sessionId;  // Capture the session ID
            console.log('Session ID:', sessionId);         

            // Listen for call events
            window.Echo.channel(`user.${userId}`)
                .listen('.call.ringing', (event) => {
                    console.log('Call ringing event received:', event);
                    if (event.channel === currentCallChannel && event.sessionId === sessionId) { // Check session ID
                        document.getElementById('callStatus').innerHTML =
                            '<p style="color: #4299e1;">Ringing...</p>';
                    }
                })
                .listen('.call.ended', (event) => {
                    if (event.sessionId === sessionId) { // Check session ID
                        console.log('Call ended event received:', event);
                        document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Call Ended</p>';
                        setTimeout(() => {
                            // Clean up and hide modal
                            if (localTracks.audioTrack) {
                                localTracks.audioTrack.stop();
                                localTracks.audioTrack.close();
                            }
                            if (client) {
                                client.leave();
                            }
                            localTracks.audioTrack = null;
                            remoteUsers = {};
                            isCalling = false;
                            currentCallChannel = null;
                            currentCallUserId = null;
                            hideCallModal();
                        }, 2000);
                    }
                })
                .listen('.call.rejected', (event) => {
                    if (event.sessionId === sessionId) { // Check session ID
                        console.log('Call rejected event received:', event);
                        document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Call Rejected</p>';
                        setTimeout(() => {
                            // Clean up and hide modal
                            if (localTracks.audioTrack) {
                                localTracks.audioTrack.stop();
                                localTracks.audioTrack.close();
                            }
                            if (client) {
                                client.leave();
                            }
                            localTracks.audioTrack = null;
                            remoteUsers = {};
                            isCalling = false;
                            currentCallChannel = null;
                            currentCallUserId = null;
                            hideCallModal();
                        }, 2000);
                    }
                })
                .listen('.call.busy', (data) => {
                    if (data.callerId === window.userId && data.sessionId === sessionId) { // Check session ID
                        isCallBusy = true;
                        console.log('Call busy event received:', data);
                        document.getElementById('callStatus').innerHTML = '<p style="color: #e53e3e;">Agent is busy on another call</p>';
                        // Update the busy status text
                        setTimeout(() => {
                            // Clean up and hide modal
                            if (localTracks.audioTrack) {
                                localTracks.audioTrack.stop();
                                localTracks.audioTrack.close();
                            }
                            if (client) {
                                client.leave();
                            }
                            localTracks.audioTrack = null;
                            remoteUsers = {};
                            isCalling = false;
                            currentCallChannel = null;
                            currentCallUserId = null;
                            hideCallModal();
                        }, 2000);
                    }
                });

            await startAudioCallNow(userId, sessionId);
        } catch (error) {
            console.error('Error in startCall:', error);
        }
    }

    // Start audio call (without video)
    async function startAudioCallNow(userId,sessionId) {
        if (isCalling) {
            console.log('Already in a call');
            return;
        }

        const channel = `channel-${sessionId}`;
        const appId = '{{ env('AGORA_APP_ID') }}' || '84220a4dc86144bb9457af1cd9965016'; // Replace 'fallback_app_id' with a valid ID for testing
        if (!appId) {
            console.error('Agora App ID is not set. Please check your environment configuration.');
            return; // Prevent further execution if App ID is not valid
        }

        try {
            // Fetch token
            const token = await fetchToken(channel, userId);

            // Create client if not exists
            if (!client) {
                client = AgoraRTC.createClient({
                    mode: 'rtc',
                    codec: 'h264'
                });

                console.log('Notifying backend about the call...');

                // Set up remote user handling
                client.on('user-published', async (remoteUser, mediaType) => {
                    if (document.getElementById('callStatus').innerText.includes('busy')) {
                        return;
                    }
                    console.log('Remote user published:', remoteUser.uid, mediaType);

                    await client.subscribe(remoteUser, mediaType);
                    console.log('Subscribed to remote user:', remoteUser.uid);

                    if (mediaType === 'audio') {
                        remoteUsers[remoteUser.uid] = remoteUser;
                        remoteUser.audioTrack.play();
                        console.log('Playing remote audio');

                        // Update UI to show connected state
                        document.getElementById('callStatus').innerHTML =
                            '<p style="color: #48bb78;">Call Connected</p>';
                        localStorage.setItem('onCall', 'true');
                    }
                });

                client.on('user-unpublished', (remoteUser, mediaType) => {
                    if (mediaType === 'audio') {
                        if (remoteUsers[remoteUser.uid]) {
                            remoteUsers[remoteUser.uid].audioTrack.stop();
                            delete remoteUsers[remoteUser.uid];
                        }
                    }
                });

                client.on('user-left', (remoteUser) => {
                    console.log('Remote user left:', remoteUser.uid);
                    if (remoteUsers[remoteUser.uid]) {
                        remoteUsers[remoteUser.uid].audioTrack.stop();
                        delete remoteUsers[remoteUser.uid];
                    }
                });
            }
            if (document.getElementById('callStatus').innerText.includes('busy')) {
                throw new Error('User is busy');
            }

            // Join the channel
            await client.join(appId, channel, token, uid);
            console.log('Joined channel:', channel);

            // Create and publish local audio track
            localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack({
                encoderConfig: {
                    sampleRate: 48000,
                    stereo: true,
                    bitrate: 128
                }
            });

            await client.publish([localTracks.audioTrack]);
            console.log('Published local audio track');

            isCalling = true;

        } catch (error) {
            console.error('Error in startAudioCall:', error);
            document.getElementById('callStatus').innerHTML =
                '<p style="color: #e53e3e;">Call Failed</p>';

            document.getElementById('callModalOverlay').style.display = 'none'; // Hides the overlay
            document.getElementById('callModal').style.display = 'none';
            throw error;
        }
    }

    async function endCallBtn() {
        try {
            console.log('Ending call...', currentCallUserId);
            // Use the currentCallUserId that was set during startCallNow
            if (!currentCallUserId) {
                console.error('No current call user ID found');
                return;
            }

            const channel = `channel-${currentCallUserId}`;

            // Notify backend about call ending
            await axios.post('/account/call/end', {
                channel: channel,
                userId: currentCallUserId,
                sessionId: sessionId
            });
            localStorage.removeItem('onCall');
            // Stop and close local tracks
            if (localTracks.audioTrack) {
                localTracks.audioTrack.stop();
                localTracks.audioTrack.close();
            }

            // Leave the channel
            if (client) {
                await client.leave();
            }

            // Reset variables
            localTracks.audioTrack = null;
            remoteUsers = {};
            isCalling = false;
            currentCallChannel = null;
            currentCallUserId = null;

            hideCallModal();
        } catch (error) {
            console.error('Error ending call:', error);
        }
    }

    function toggleMutebtn() {
        if (localTracks.audioTrack) {
            const btn = document.getElementById('mutebtn');
            if (localTracks.audioTrack.enabled) {
                localTracks.audioTrack.setEnabled(false);
                btn.innerHTML = '<i class="mdi mdi-microphone-off"></i> Unmute';
            } else {
                localTracks.audioTrack.setEnabled(true);
                btn.innerHTML = '<i class="mdi mdi-microphone"></i> Mute';
            }
        }
    }

    function showCallModal() {
        document.getElementById('callModalOverlay').style.display = 'block';
        document.getElementById('callModal').style.display = 'block';
        document.body.style.overflow = 'hidden'; // Prevent scrolling when modal is open
    }

    function hideCallModal() {
        document.getElementById('callModalOverlay').style.display = 'none';
        document.getElementById('callModal').style.display = 'none';
        document.body.style.overflow = 'auto'; // Restore scrolling
    }
</script>
<script>
    function toggleModal(modalId, authorId) {
        const modal = document.getElementById(modalId);
        const isHidden = modal.classList.contains('hidden');
        console.log('authorId in items', authorId);
        // if (authorId) {
        //     localStorage.setItem('authorId', authorId);
        // }
        // Toggle visibility
        modal.classList.toggle('hidden', !isHidden);
        modal.classList.toggle('flex', isHidden);
        modal.setAttribute('aria-hidden', isHidden ? 'false' : 'true');
    }
</script>
<style>
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translate(-50%, -48%);
        }

        to {
            opacity: 1;
            transform: translate(-50%, -50%);
        }
    }

    #callModal {
        background: white;
        border: 1px solid rgba(0, 0, 0, 0.1);
    }

    /* Dark mode support */
    @media (prefers-color-scheme: dark) {
        #callModal {
            background: #1a1a1a;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
    }
</style>