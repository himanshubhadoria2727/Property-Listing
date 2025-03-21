@extends('plugins/real-estate::themes.dashboard.layouts.master')

@section('content')

<div class="h-screen flex bg-gray-100 relative overflow-hidden">
    <!-- Sidebar - Note the added mobile classes -->
    <div id="agentChatListPanel" class="w-80 bg-white shadow-md flex-shrink-0 flex flex-col h-full border-r absolute md:relative left-0 z-10 transform transition-transform duration-300 -translate-x-full md:translate-x-0 overflow-hidden">
        <div class="p-5 border-b flex justify-between items-center">
            <div>
                <h2 class="text-lg font-semibold">Your Messages</h2>
                <p class="text-sm text-gray-500">Your conversations</p>
            </div>
            <!-- Close button for mobile -->
            <button id="closeSidebarBtn" class="md:hidden text-gray-500 hover:text-gray-700">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>
        <div id="agentChatList" class="flex-1 overflow-y-auto p-4 space-y-4 custom-scrollbar">
            <!-- Agent chat list items dynamically loaded here -->
        </div>
    </div>

    <!-- Main Agent Chat Area -->
    <div class="flex-1 flex flex-col h-full overflow-hidden">
        <!-- Agent Chat Header with mobile toggle -->
        <div id="agentChatHeader" class="p-5 bg-white shadow-md flex items-center gap-4 border-b">
            <!-- Mobile sidebar toggle button -->
            <button id="openSidebarBtn" class="md:hidden text-gray-500 hover:text-gray-700 mr-2">
                <i class="fas fa-bars text-xl"></i>
            </button>

            <div class="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center">
                <i class="fas fa-user text-gray-500"></i>
            </div>
            <div>
                <h3 class="text-lg font-semibold text-gray-900">Select a user conversation</h3>
                <p class="text-sm text-gray-500">Choose an user from the list to start chatting</p>
            </div>
        </div>

        <!-- Agent Messages Container -->
        <div id="agentMessagesContainer" class="flex-1 bg-white overflow-y-auto p-3 flex flex-col space-y-4 custom-scrollbar">
            <p id="noAgentConversationMessage" class="text-center text-gray-500 text-lg">
                Select a user to start conversation
            </p>
        </div>

        <!-- Agent Message Input -->
        <div id="agentMessageInputContainer" class="p-4 bg-white border-t">
            <form id="agentMessageForm" class="flex flex-col gap-2">
                <input type="hidden" id="currentAgentId" value="" />
                <div class="flex items-center gap-3">
                    <div class="flex-1 relative">
                        <input 
                            id="agentMessageInput" 
                            type="text" 
                            class="w-full px-4 py-3 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500" 
                            placeholder="Type your message..." 
                        />
                        <label for="agentAttachment" class="absolute right-3 top-1/2 -translate-y-1/2 cursor-pointer text-gray-500 hover:text-gray-700">
                            <i class="fas fa-paperclip text-xl"></i>
                            <input 
                                type="file" 
                                id="agentAttachment" 
                                name="attachment" 
                                class="hidden" 
                                accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.gif" 
                            />
                        </label>
                    </div>
                    <button 
                        type="submit" 
                        id="sendAgentMessageButton" 
                        class="px-6 py-3 bg-blue-600 text-white rounded-lg shadow-md flex items-center gap-2 disabled:opacity-50 hover:bg-blue-700 transition-colors" 
                        disabled
                    >
                        <span>Send</span>
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
                <div id="agentAttachmentPreview" class="hidden p-2 bg-gray-50 rounded-lg"></div>
            </form>
        </div>
    </div>

    <!-- Overlay for mobile when sidebar is open -->
    <div id="sidebarOverlay" class="fixed inset-0 bg-black bg-opacity-50 z-0 hidden md:hidden"></div>
</div>

<style>
    /* Add these new styles for custom scrollbars */
    .custom-scrollbar {
        scrollbar-width: thin;
        scrollbar-color: rgba(156, 163, 175, 0.5) transparent;
    }

    .custom-scrollbar::-webkit-scrollbar {
        width: 6px;
    }

    .custom-scrollbar::-webkit-scrollbar-track {
        background: transparent;
    }

    .custom-scrollbar::-webkit-scrollbar-thumb {
        background-color: rgba(156, 163, 175, 0.5);
        border-radius: 3px;
    }

    /* Sidebar styles */
    #agentChatListPanel {
        width: 80%;
        /* Adjust width for mobile */
        max-width: 320px;
        /* Maximum width for larger screens */
        background-color: white;
        border-right: 1px solid #e5e7eb;
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        z-index: 10;
        transform: translateX(-100%);
        /* Start off-screen */
        transition: transform 0.3s ease-in-out;
        /* Smooth transition */
        overflow: hidden;
    }

    /* Show sidebar when active */
    #agentChatListPanel.active {
        transform: translateX(0);
        /* Slide into view */
    }

    /* Overlay styles */
    #sidebarOverlay {
        display: none;
        /* Hide by default */
    }

    /* Show overlay when sidebar is active */
    #agentChatListPanel.active+#sidebarOverlay {
        display: block;
    }

    /* Adjustments for larger screens */
    @media (min-width: 768px) {
        #agentChatListPanel {
            position: relative;
            transform: translateX(0);
            /* Always visible on larger screens */
        }

        #sidebarOverlay {
            display: none;
            /* No overlay needed on larger screens */
        }
    }
</style>

<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.2/axios.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // DOM Elements
        const agentChatListPanel = document.getElementById('agentChatListPanel');
        const agentChatList = document.getElementById('agentChatList');
        const agentMessagesContainer = document.getElementById('agentMessagesContainer');
        const agentMessageForm = document.getElementById('agentMessageForm');
        const agentMessageInput = document.getElementById('agentMessageInput');
        const sendAgentMessageButton = document.getElementById('sendAgentMessageButton');
        const noAgentConversationMessage = document.getElementById('noAgentConversationMessage');
        const currentAgentId = document.getElementById('currentAgentId');
        const agentChatHeader = document.getElementById('agentChatHeader');
        const agentMessageInputContainer = document.getElementById('agentMessageInputContainer');
        const agentAttachmentInput = document.getElementById('agentAttachment');
        const agentAttachmentPreview = document.getElementById('agentAttachmentPreview');

        // Mobile sidebar elements
        const openSidebarBtn = document.getElementById('openSidebarBtn');
        const closeSidebarBtn = document.getElementById('closeSidebarBtn');
        const sidebarOverlay = document.getElementById('sidebarOverlay');

        // Mobile sidebar toggle functions
        function openSidebar() {
            agentChatListPanel.classList.add('active');
            sidebarOverlay.classList.remove('hidden');
        }

        function closeSidebar() {
            agentChatListPanel.classList.remove('active');
            sidebarOverlay.classList.add('hidden');
        }

        // Add event listeners for mobile sidebar
        openSidebarBtn?.addEventListener('click', openSidebar);
        closeSidebarBtn?.addEventListener('click', closeSidebar);
        sidebarOverlay?.addEventListener('click', closeSidebar);

        // Disable send button when input is empty
        agentMessageInput?.addEventListener('input', (e) => {
            sendAgentMessageButton.disabled = !e.target.value.trim();
        });

        // Load agent chat list from server
        window.loadAgentChatList = function() {
            fetch('/chats?sender_id=' + window.userId)
                .then(response => response.json())
                .then(result => {
                    if (result.success && result.data) {
                        const agentChatListData = result.data;
                        agentChatList.innerHTML = '';

                        // Get stored active agent chat ID from localStorage
                        const activeUserId = localStorage.getItem('activeUserId');

                        Object.keys(agentChatListData).forEach(agentId => {
                            const agentChat = agentChatListData[agentId][0];
                            const agentChatItem = createAgentChatListItem(agentChat, agentId);
                            if (agentChatItem) { // Only append if chat item is created successfully
                                agentChatItem.dataset.agentId = agentId;

                                if (agentId === activeUserId) {
                                    agentChatItem.classList.add('bg-gray-500');
                                }

                                agentChatList.appendChild(agentChatItem);
                            }
                        });

                        if (activeUserId && agentChatListData[activeUserId]) {
                            const activeAgentChatData = agentChatListData[activeUserId][0];
                            if (activeAgentChatData) {
                                // Determine which user is the chat partner (not the current user)
                                const isCurrentUserSender = activeAgentChatData.sender_id == window.userId;
                                const chatPartner = isCurrentUserSender ? activeAgentChatData.receiver : activeAgentChatData.sender;

                                // Create a safe partner name
                                const partnerName = chatPartner ? 
                                    `${chatPartner.first_name || ''} ${chatPartner.last_name || ''}`.trim() || 'Unknown User' 
                                    : 'Unknown User';

                                loadAgentChat(activeUserId, partnerName);
                            }
                        }
                    }
                })
                .catch(error => console.error('Error loading agent chat list:', error));
        };

        function createAgentChatListItem(agentChat, agentId) {
            if (!agentChat) return null;

            const agentChatItem = document.createElement('div');
            agentChatItem.className = 'p-3 mb-2 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer';

            if (agentId === localStorage.getItem('activeUserId')) {
                agentChatItem.classList.add('bg-gray-500');
            }

            // Determine which user is the chat partner (not the current user)
            const isCurrentUserSender = agentChat.sender_id == window.userId;
            const chatPartner = isCurrentUserSender ? agentChat.receiver : agentChat.sender;

            // Create a safe partner name
            const partnerName = chatPartner ? 
                `${chatPartner.first_name || ''} ${chatPartner.last_name || ''}`.trim() || 'Unknown User' 
                : 'Unknown User';

            agentChatItem.innerHTML = `
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-user text-blue-600"></i>
                    </div>
                    <div class="flex-1 min-w-0">
                        <h3 class="text-sm font-semibold text-gray-900 truncate">
                            ${partnerName}
                        </h3>
                        <p class="text-sm text-gray-500 truncate">${agentChat.message || 'No messages yet'}</p>
                    </div>
                </div>
            `;

            agentChatItem.addEventListener('click', () => {
                localStorage.setItem('activeUserId', agentId);

                document.querySelectorAll('#agentChatList > div').forEach(item => {
                    item.classList.remove('bg-gray-500');
                });
                agentChatItem.classList.add('bg-gray-500');

                loadAgentChat(agentId, partnerName);

                // Close sidebar on mobile after selecting a chat
                if (window.innerWidth < 768) {
                    closeSidebar();
                }
            });

            return agentChatItem;
        }

        function loadAgentChat(agentId, agentName) {
            currentAgentId.value = agentId;
            localStorage.setItem('activeUserId', agentId);

            agentChatHeader.innerHTML = `
                <!-- Mobile sidebar toggle button -->
                <button id="openSidebarBtn" class="md:hidden text-gray-500 hover:text-gray-700 mr-2">
                    <i class="fas fa-bars text-xl"></i>
                </button>
                
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                        <i class="fas fa-user text-blue-600 text-xl"></i>
                    </div>
                    <div>
                        <h3 class="text-lg font-semibold text-gray-800">${agentName}</h3>
                        <p class="text-sm text-gray-500">Online</p>
                    </div>
                </div>
            `;

            // Reattach event listener to the new button
            document.getElementById('openSidebarBtn')?.addEventListener('click', openSidebar);

            noAgentConversationMessage.style.display = "none";
            agentMessageInputContainer.style.display = "block";

            fetch(`/chats/${window.userId}/messages?sender_id=${window.userId}&receiver_id=${agentId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        agentMessagesContainer.innerHTML = '';
                        data.data.forEach(message => {
                            const messageElement = createAgentMessageElement(message);
                            agentMessagesContainer.appendChild(messageElement);
                        });
                        highlightActiveAgentChat(agentId);
                        scrollToBottom();
                    }
                })
                .catch(error => console.error('Error loading agent messages:', error));
        }

        function createAgentMessageElement(message) {
            const isCurrentUser = message.sender_id === window.userId;
            const messageElement = document.createElement('div');
            messageElement.className = `flex w-full ${isCurrentUser ? 'justify-end' : 'justify-start'} mb-2`;

            let attachmentHtml = '';
            if (message.attachment) {
                if (message.attachment_type === 'image') {
                    attachmentHtml = `
                        <div class="mt-2">
                            <img src="${message.attachment_url}" alt="Attached image" class="max-w-xs rounded-lg shadow-sm" />
                        </div>`;
                } else {
                    const fileName = message.attachment.split('/').pop();
                    const icon = message.attachment_type === 'pdf' ? 'fa-file-pdf' : 'fa-file-alt';
                    attachmentHtml = `
                        <div class="mt-2">
                            <a href="${message.attachment_url}" target="_blank" class="flex items-center gap-2 text-sm ${isCurrentUser ? 'text-blue-100' : 'text-blue-600'} hover:underline">
                                <i class="fas ${icon}"></i>
                                ${fileName}
                            </a>
                        </div>`;
                }
            }

            messageElement.innerHTML = `
                <div class="${isCurrentUser ? 'bg-blue-600 text-white' : 'bg-gray-400 text-gray-800'} 
                            rounded-lg px-4 py-2 max-w-xs md:max-w-md lg:max-w-lg shadow-sm">
                    <p class="text-sm" style="white-space: pre-wrap;">${message.message}</p>
                    ${attachmentHtml}
                    <p class="text-xs ${isCurrentUser ? 'text-blue-200' : 'text-gray-500'} mt-1 text-right">
                        ${new Date(message.created_at).toLocaleTimeString()}
                    </p>
                </div>
            `;

            return messageElement;
        }

        // File upload preview
        agentAttachmentInput?.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (!file) {
                agentAttachmentPreview.classList.add('hidden');
                return;
            }

            const fileName = file.name;
            const fileSize = (file.size / 1024 / 1024).toFixed(2); // Convert to MB

            agentAttachmentPreview.innerHTML = `
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <i class="fas ${file.type.includes('image') ? 'fa-image' : 'fa-file'} text-gray-500"></i>
                        <span class="text-sm text-gray-700">${fileName} (${fileSize} MB)</span>
                    </div>
                    <button type="button" class="text-red-500 hover:text-red-700" onclick="removeAgentAttachment()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            `;
            agentAttachmentPreview.classList.remove('hidden');
        });

        // Remove attachment
        window.removeAgentAttachment = function() {
            agentAttachmentInput.value = '';
            agentAttachmentPreview.classList.add('hidden');
        };

        agentMessageForm?.addEventListener("submit", async (e) => {
            e.preventDefault();
            const messageText = agentMessageInput.value.trim();
            const attachment = agentAttachmentInput.files[0];
            
            if ((!messageText && !attachment) || !currentAgentId.value) return;

            sendAgentMessageButton.disabled = true;

            const formData = new FormData();
            formData.append('message', messageText);
            formData.append('receiver_id', currentAgentId.value);
            formData.append('sender_id', String(window.userId));
            
            if (attachment) {
                formData.append('attachment', attachment);
            }

            try {
                const response = await axios.post('/chats/send', formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                    }
                });

                if (response.data.success) {
                    const messageElement = createAgentMessageElement(response.data.chat[0]);
                    agentMessagesContainer.appendChild(messageElement);
                    agentMessageInput.value = "";
                    agentAttachmentInput.value = "";
                    agentAttachmentPreview.classList.add('hidden');
                    scrollToBottom();
                }
            } catch (error) {
                console.error('Error sending message:', error);
            } finally {
                sendAgentMessageButton.disabled = false;
            }
        });

        function scrollToBottom() {
            agentMessagesContainer.scrollTop = agentMessagesContainer.scrollHeight;
        }

        function highlightActiveAgentChat(activeUserId) {
            document.querySelectorAll("#agentChatList > div").forEach(chatItem => {
                chatItem.classList.toggle('bg-gray-500', chatItem.dataset.agentId === activeUserId);
            });
        }

        // Real-time updates with Laravel Echo
        if (window.Echo) {
            const activeUserId = localStorage.getItem('activeUserId');
            const agentId = window.userId?.toString();

            console.log('Echo initialized:', window.Echo);
            console.log('Active UserId:', activeUserId);
            console.log('AgentId:', agentId);

            if (activeUserId && agentId) {
                console.log('Echo channel:', `chat.${agentId}.${activeUserId}`);
                window.Echo.channel(`chat.${agentId}.${activeUserId}`)
                    .listen('.message.sent', (e) => {
                        console.log('Message event received:', e);
                        console.log('Full message object from agent:', JSON.stringify(e, null, 2));

                        if (e.sender_id === activeUserId) {
                            console.log('Message is from active user');
                            const messageElement = createAgentMessageElement?.(e.message);
                            if (messageElement && agentMessagesContainer) {
                                console.log('Appending message element to container');
                                agentMessagesContainer.appendChild(messageElement);
                                scrollToBottom?.();
                            }
                        }
                        console.log('Reloading agent chat list');
                        loadAgentChatList?.();
                        playRingtone();
                    });
            } else {
                console.error('Missing activeUserId or window.userId for Echo channel');
            }
        } else {
            console.error('Echo is not initialized properly');
        }

        function playRingtone() {
            ringtone = new Audio('/media/message.wav'); // Updated path
            ringtone.play().catch(error => {
                console.log("Audio playback failed:", error);
            });
        }

        // Handle window resize
        window.addEventListener('resize', function() {
            if (window.innerWidth >= 768) {
                // Ensure sidebar is visible on larger screens
                agentChatListPanel.classList.add('active');
                // Hide overlay on larger screens
                sidebarOverlay.classList.add('hidden');
            } else {
                // Hide sidebar by default on small screens
                agentChatListPanel.classList.remove('active');
            }
        });

        // Initial load
        loadAgentChatList();
    });
</script>

@endsection