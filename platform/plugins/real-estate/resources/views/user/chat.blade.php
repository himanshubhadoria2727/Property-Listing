<div class="chat-app-container" style="height: 100vh; display: flex; background-color: #f9fafb; overflow: hidden;">
    <div class="chat-main" style="flex: 1; display: flex; flex-direction: row; position: relative; overflow: hidden;">
        <!-- Sidebar -->
        <div id="chatListPanel" class="chat-sidebar" style="width: 350px; background-color: white; border-right: 1px solid #e5e7eb; display: none; overflow: hidden;">
            <div class="chat-sidebar-inner" style="height: 100%; display: flex; flex-direction: column; overflow: hidden;">
                <div class="chat-sidebar-header" style="padding: 1.5rem; border-bottom: 1px solid #e5e7eb;">
                    <h2 class="chat-sidebar-title" style="font-size: 1.5rem; font-weight: bold; color: #1f2937;">Messages</h2>
                    <p class="chat-sidebar-subtitle" style="font-size: 0.875rem; color: #6b7280; margin-top: 0.25rem;">Your conversations</p>
                </div>
                <div id="chatList" class="chat-list" style="flex: 1; overflow-y: auto; padding: 1rem 0.75rem;">
                    <!-- Chat list items will be dynamically loaded -->
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="chat-content" style="flex: 1; display: flex; flex-direction: column; overflow: hidden;">
            <!-- Chat Header -->
            <div id="chatHeader" class="chat-header" style="padding: 1.5rem; background-color: white; border-bottom: 1px solid #e5e7eb; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <div class="chat-avatar" style="width: 3rem; height: 3rem; background-color: #dbeafe; border-radius: 9999px; display: flex; align-items: center; justify-content: center; color: #2563eb;">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <h3 style="font-size: 1.125rem; font-weight: 600; color: #1f2937;">Select a conversation</h3>
                        <p style="font-size: 0.875rem; color: #6b7280;">Choose from the list to start chatting</p>
                    </div>
                </div>
            </div>

            <!-- Messages Container -->
            <div id="messagesContainer" class="chat-messages" style="padding:0.5rem; flex: 1; overflow-y: auto; display: flex; flex-direction: column;">
                <p id="noConversationMessage" style="text-align: center; color: #6b7280; margin-top: 2.5rem;">
                    Select an agent to start conversation
                </p>
            </div>

            <!-- Message Input -->
            <div id="messageInputContainer" class="chat-input" style="padding: 0.5rem; color: #1f2937; background-color: white; border-top: 1px solid #e5e7eb;">
                <form id="messageForm" class="chat-input-form" style="padding: 0.5em;display: flex; gap: 1rem;">
                    <input type="hidden" id="currentAgentId" value="" />
                    <input
                        id="messageInput"
                        type="text"
                        class="chat-input-field"
                        placeholder="Type your message..."
                        style="flex: 1; padding: 0.75rem 1rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background-color: #f9fafb; transition: all 0.2s;" />
                    <button
                        type="submit"
                        id="sendMessageButton"
                        class="chat-send-button"
                        disabled
                        style="padding: 0.75rem 0.7rem; background-color: #2563eb; color: white; border: none; border-radius: 0.5rem; cursor: pointer; transition: background-color 0.2s; display: flex; align-items: center; gap: 0.5rem;">
                        <span class="send-text">Send</span>
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.2/axios.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // DOM Elements
        const sidebarToggle = document.getElementById('sidebarToggle');
        const menuIcon = document.getElementById('menuIcon');
        const closeIcon = document.getElementById('closeIcon');
        const chatListPanel = document.getElementById('chatListPanel');
        const chatList = document.getElementById('chatList');
        const messagesContainer = document.getElementById('messagesContainer');
        const messageForm = document.getElementById('messageForm');
        const messageInput = document.getElementById('messageInput');
        const sendMessageButton = document.getElementById('sendMessageButton');
        const noConversationMessage = document.getElementById('noConversationMessage');
        const currentAgentId = document.getElementById('currentAgentId');
        const chatHeader = document.getElementById('chatHeader');
        const messageInputContainer = document.getElementById('messageInputContainer');

        // Toggle sidebar on mobile
        sidebarToggle?.addEventListener('click', () => {
            chatListPanel.style.display = chatListPanel.style.display === 'none' ? 'block' : 'none';
            menuIcon.classList.toggle('hidden');
            closeIcon.classList.toggle('hidden');
        });

        // Disable send button when input is empty
        messageInput?.addEventListener('input', (e) => {
            sendMessageButton.disabled = !e.target.value.trim();
        });

        // Load chat list from server
        window.loadChatList = function() {
            fetch('/chats?sender_id=' + window.userId)
                .then(response => response.json())
                .then(result => {
                    if (result.success && result.data) {
                        const chatListData = result.data;
                        chatList.innerHTML = '';

                        const authorId = localStorage.getItem('authorId');
                        if (!chatListData.hasOwnProperty(authorId)) {
                            createNewChat();
                        } else {
                            Object.keys(chatListData).forEach(receiverId => {
                                const chat = chatListData[receiverId][0];
                                const chatItem = createChatListItem(chat, receiverId);
                                chatItem.dataset.receiverId = receiverId;
                                chatList.appendChild(chatItem);
                            });
                        }

                        const activeChat = localStorage.getItem('authorId');
                        if (activeChat) {
                            const activeChatData = result.data[activeChat];
                            if (activeChatData) {
                                // Determine chat partner (the one who isn't the current user)
                                const chatData = activeChatData[0];
                                const isCurrentUserSender = chatData.sender_id == window.userId;
                                const chatPartner = isCurrentUserSender ? chatData.receiver : chatData.sender;

                                loadChat(activeChat, `${chatPartner.first_name} ${chatPartner.last_name}`);
                            }
                        }
                    }
                })
                .catch(error => console.error('Error loading chat list:', error));
        };

        function createChatListItem(chat, receiverId) {
            const chatItem = document.createElement('div');
            chatItem.className = 'p-3 mb-2 rounded-lg hover:bg-gray-50 transition-colors cursor-pointer';

            if (receiverId === localStorage.getItem('authorId')) {
                chatItem.classList.add('bg-gray-100');
            }

            // Determine which user is the chat partner (not the current user)
            const isCurrentUserSender = chat.sender_id == window.userId;
            const chatPartner = isCurrentUserSender ? chat.receiver : chat.sender;

            chatItem.innerHTML = `
        <div class="flex items-center space-x-3">
            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                <i class="fas fa-user text-blue-600"></i>
            </div>
            <div class="flex-1 min-w-0">
                <h3 class="text-sm font-semibold text-gray-900 truncate">
                    ${chatPartner.first_name} ${chatPartner.last_name}
                </h3>
                <p class="text-sm text-gray-500 truncate">${chat.message || 'No messages yet'}</p>
            </div>
        </div>
    `;

            chatItem.addEventListener('click', () => {
                // Use chatPartner for consistency
                loadChat(receiverId, `${chatPartner.first_name} ${chatPartner.last_name}`);

                // Close sidebar on mobile after selection
                if (window.innerWidth < 1024) {
                    chatListPanel.style.display = 'none';
                    menuIcon.classList.remove('hidden');
                    closeIcon.classList.add('hidden');
                }
            });

            return chatItem;
        }

        function createNewChat() {
            const csrf = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            const receiverId = localStorage.getItem('authorId');

            axios.post('/chat/create', {
                    receiver_id: receiverId,
                }, {
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrf
                    }
                })
                .then(response => {
                    console.log('Chat created:', response.data);
                    loadChatList();
                })
                .catch(error => {
                    console.error('Error creating chat:', error);
                    if (error.response) {
                        console.error('Response data:', error.response.data);
                    }
                });
        }

        function loadChat(agentId, agentName) {
            currentAgentId.value = agentId;
            localStorage.setItem('authorId', agentId);

            // Update header with active chat
            chatHeader.innerHTML = `
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

            noConversationMessage.style.display = "none";
            messageInputContainer.style.display = "block";

            // Load messages in reverse order
            fetch(`/chats/${window.userId}/messages?sender_id=${window.userId}&receiver_id=${agentId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        messagesContainer.innerHTML = '';
                        data.data.forEach(message => { // Remove the reverse()
                            const messageElement = createMessageElement(message);
                            messagesContainer.appendChild(messageElement);
                        });
                        highlightActiveChat(agentId);
                        scrollToBottom();
                    }
                })
                .catch(error => console.error('Error loading messages:', error));
        }

        function createMessageElement(message) {
            console.log('Creating message element:', message);
            const isCurrentUser = message.sender_id === window.userId;
            const messageElement = document.createElement('div');
            messageElement.className = `flex w-full ${isCurrentUser ? 'justify-end' : 'justify-start'} mb-2`;

            messageElement.style.cssText = `
                display: flex;
                justify-content: ${isCurrentUser ? 'flex-end' : 'flex-start'};
                margin-bottom: 0.5rem;
            `;
            messageElement.innerHTML = `
                <div style="background-color: ${isCurrentUser ? '#3B82F6' : '#E5E7EB'}; color: ${isCurrentUser ? 'white' : '#1A202C'}; border-radius: 0.5rem; padding: 0.5rem; max-width: 300px; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
                    <p style="font-size: 0.875rem; white-space: pre-wrap;">${message.message}</p>
                    <p style="font-size: 0.75rem; color: ${isCurrentUser ? 'rgba(255, 255, 255, 0.6)' : 'rgba(26, 32, 44, 0.6)'}; margin-top: 0.25rem; text-align: right;">
                        ${new Date(message.created_at).toLocaleTimeString()}
                    </p>
                </div>
            `;

            return messageElement;
        }

        messageForm?.addEventListener("submit", (e) => {
            e.preventDefault();
            const messageText = messageInput.value.trim();
            if (messageText === "" || !currentAgentId.value) return;

            const csrf = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

            sendMessageButton.disabled = true;

            axios.post('/chats/send', {
                    message: messageText,
                    receiver_id: currentAgentId.value,
                    sender_id: String(window.userId)
                }, {
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                .then(response => {
                    if (response.data.success) {
                        const messageElement = createMessageElement(response.data.chat[0]);
                        messagesContainer.appendChild(messageElement);
                        messageInput.value = "";
                        // loadChatList?.();
                        scrollToBottom();
                    }
                })
                .catch(error => console.error('Error sending message:', error))
                .finally(() => {
                    sendMessageButton.disabled = false;
                });
        });

        function scrollToBottom() {
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        function highlightActiveChat(activeId) {
            document.querySelectorAll("#chatList > div").forEach(chatItem => {
                chatItem.classList.toggle('bg-gray-200', chatItem.dataset.receiverId === activeId);
            });
        }

        // Real-time updates with Laravel Echo
        if (window.Echo) {
            const activeUserId = localStorage.getItem('authorId');
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
                            const messageElement = createMessageElement?.(e.message);
                            if (messageElement && messagesContainer) {
                                console.log('Appending message element to container');
                                messagesContainer.appendChild(messageElement);
                                scrollToBottom?.();
                            }
                        }
                        playRingtone();
                        console.log('Reloading chat list');
                        loadChatList?.();
                    });
            } else {
                console.error('Missing activeUserId or window.userId for Echo channel');
            }
        } else {
            console.error('Echo is not initialized properly');
        }

        // Initial load
        loadChatList();
        function playRingtone() {
            ringtone = new Audio('/media/message.wav'); // Updated path
            ringtone.play().catch(error => {
                console.log("Audio playback failed:", error);
            });
        }
        // Initial display settings
        if (window.innerWidth >= 1024) {
            chatListPanel.style.display = 'block';
        }
    });
</script>

<style>
    /* Reset styles for chat component */
    .chat-app-container * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    /* Scoped styles for chat component */
    .chat-app-container {
        height: 100vh;
        display: flex;
        background-color: #f9fafb;
        overflow: hidden;
    }

    .chat-main {
        flex: 1;
        display: flex;
        width: auto;
        flex-direction: row;
        position: relative;
        overflow: hidden;
    }

    .chat-sidebar {
        width: 320px;
        background-color: white;
        border-right: 1px solid #e5e7eb;
        overflow: hidden;
    }

    .chat-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }

    @media (max-width: 1024px) {
        .chat-sidebar {
            display: none;
        }
    }

    .chat-sidebar-inner {
        height: 100%;
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }

    .chat-sidebar-header {
        padding: 1.5rem;
        border-bottom: 1px solid #e5e7eb;
    }

    .chat-sidebar-title {
        font-size: 1.5rem;
        font-weight: bold;
        color: #1f2937;
    }

    .chat-sidebar-subtitle {
        font-size: 0.875rem;
        color: #6b7280;
        margin-top: 0.25rem;
    }

    .chat-list {
        flex: 1;
        overflow-y: auto;
        padding: 1rem 0.75rem;
        scrollbar-width: thin;
        scrollbar-color: rgba(156, 163, 175, 0.5) transparent;
    }

    .chat-list-item {
        padding: 0.75rem;
        margin-bottom: 0.5rem;
        border-radius: 0.5rem;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .chat-list-item:hover {
        background-color: #f3f4f6;
    }

    .chat-list-item.active {
        background-color: #f3f4f6;
    }

    .chat-header {
        padding: 1.5rem;
        background-color: white;
        border-bottom: 1px solid #e5e7eb;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 1.5rem;
        display: flex;
        flex-direction: column;
        scrollbar-width: thin;
        scrollbar-color: rgba(156, 163, 175, 0.5) transparent;
    }

    .message-container {
        display: flex;
        margin-bottom: 1rem;
    }

    .message-container.sent {
        justify-content: flex-end;
    }

    .message-bubble {
        max-width: 75%;
        padding: 0.75rem 1rem;
        border-radius: 0.5rem;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .message-bubble.sent {
        background-color: #2563eb;
        color: white;
        /* Ensure text is visible */
    }

    .message-bubble.received {
        background-color: #f3f4f6;
        color: #1f2937;
        /* Ensure text is visible */
    }

    .message-time {
        font-size: 0.75rem;
        margin-top: 0.25rem;
    }

    .message-time.sent {
        color: #bfdbfe;
    }

    .message-time.received {
        color: #6b7280;
    }

    .chat-input {
        padding: 1.5rem;
        color: #1f2937;
        background-color: white;
        border-top: 1px solid #e5e7eb;
    }

    .chat-input-form {
        display: flex;
        gap: 1rem;
    }

    .chat-input-field {
        flex: 1;
        padding: 0.75rem 1rem;
        border: 1px solid #e5e7eb;
        border-radius: 0.5rem;
        background-color: #f9fafb;
        transition: all 0.2s;
    }

    .chat-input-field:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
    }

    .chat-send-button {
        padding: 0.75rem 1.5rem;
        background-color: #2563eb;
        color: white;
        border: none;
        border-radius: 0.5rem;
        cursor: pointer;
        transition: background-color 0.2s;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .chat-send-button:hover {
        background-color: #1d4ed8;
    }

    .chat-send-button:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    /* Webkit scrollbar styles */
    .chat-list::-webkit-scrollbar,
    .chat-messages::-webkit-scrollbar {
        width: 6px;
    }

    .chat-list::-webkit-scrollbar-track,
    .chat-messages::-webkit-scrollbar-track {
        background: transparent;
    }

    .chat-list::-webkit-scrollbar-thumb,
    .chat-messages::-webkit-scrollbar-thumb {
        background-color: rgba(156, 163, 175, 0.5);
        border-radius: 3px;
    }

    /* Avatar */
    .chat-avatar {
        width: 3rem;
        height: 3rem;
        background-color: #dbeafe;
        border-radius: 9999px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #2563eb;
    }

    /* Small screen adjustments */
    @media (max-width: 480px) {
        .chat-input-field {
            padding: 0.5rem 0.75rem;
            font-size: 0.875rem;
        }

        .chat-send-button {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }
    }
</style>