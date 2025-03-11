<div class="chat-app-container" style="height: 100%; display: flex; background-color: #f9fafb; overflow: hidden;">
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
        <div class="chat-content" style="flex: 1; display: flex; flex-direction: column; overflow: hidden; height: 100%;">
            <!-- Chat Header -->
            <div id="chatHeader" class="chat-header" style="padding: 0.75rem 1.5rem; background-color: white; border-bottom: 1px solid #e5e7eb; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <div class="chat-avatar" style="width: 2.5rem; height: 2.5rem; background-color: #dbeafe; border-radius: 9999px; display: flex; align-items: center; justify-content: center; color: #2563eb;">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <h3 style="font-size: 1.125rem; font-weight: 600; color: #1f2937;">Select a conversation</h3>
                        <p style="font-size: 0.875rem; color: #6b7280;">Choose from the list to start chatting</p>
                    </div>
                </div>
            </div>

            <!-- Messages Container -->
            <div id="messagesContainer" class="chat-messages" style="padding:1rem; flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 0.75rem; min-height: 0;">
                <p id="noConversationMessage" style="text-align: center; color: #6b7280; margin-top: 2.5rem;">
                    Select an agent to start conversation
                </p>
            </div>

            <!-- Message Input -->
            <div id="messageInputContainer" class="chat-input" style="padding: 1rem; color: #1f2937; background-color: white; border-top: 1px solid #e5e7eb;">
                <form id="messageForm" class="chat-input-form" style="padding: 0.25rem; display: flex; gap: 0.75rem;">
                    <input type="hidden" id="currentAgentId" value="" />
                    <div class="w-full flex-1 flex items-center gap-2">
                        <input
                            id="messageInput"
                            type="text"
                            class="chat-input-field flex-1"
                            placeholder="Type your message..."
                            style="padding: 0.5rem 0.75rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background-color: #f9fafb; transition: all 0.2s;" />
                        
                        <label for="attachment" class="cursor-pointer text-gray-500 hover:text-gray-700">
                            <i class="fas fa-paperclip text-xl"></i>
                            <input type="file" id="attachment" name="attachment" class="hidden" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.gif" />
                        </label>
                    </div>
                    <button
                        type="submit"
                        id="sendMessageButton"
                        class="chat-send-button"
                        disabled
                        style="padding: 0.5rem 1rem; background-color: #2563eb; color: white; border: none; border-radius: 0.5rem; cursor: pointer; transition: background-color 0.2s; display: flex; align-items: center; gap: 0.5rem;">
                        <span class="send-text">Send</span>
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </form>
                <div id="attachmentPreview" class="hidden mt-2 p-2 bg-gray-50 rounded-lg"></div>
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
                                console.log('Chat:', chat);
                                const chatItem = createChatListItem(chat, receiverId);
                                if (chatItem) {
                                    chatItem.dataset.receiverId = receiverId;
                                    chatList.appendChild(chatItem);
                                }
                            });
                        }

                        const activeChat = localStorage.getItem('authorId');
                        if (activeChat) {
                            const activeChatData = result.data[activeChat];
                            if (activeChatData && activeChatData[0]) {
                                // Determine chat partner (the one who isn't the current user)
                                const chatData = activeChatData[0];
                                const isCurrentUserSender = chatData.sender_id == window.userId;
                                const chatPartner = isCurrentUserSender ? chatData.receiver : chatData.sender;
                                
                                if (chatPartner) {
                                    const partnerName = `${chatPartner.first_name || ''} ${chatPartner.last_name || ''}`.trim() || 'Unknown User';
                                    loadChat(activeChat, partnerName);
                                } else {
                                    loadChat(activeChat, 'Unknown User');
                                }
                            }
                        }
                    }
                })
                .catch(error => console.error('Error loading chat list:', error));
        };

        function createChatListItem(chat, receiverId) {
            if (!chat) return null;

            const chatItem = document.createElement('div');
            chatItem.className = 'p-4 mb-2 rounded-lg hover:bg-gray-50 transition-colors cursor-pointer';

            if (receiverId === localStorage.getItem('authorId')) {
                chatItem.classList.add('bg-gray-300');
            }

            // Determine which user is the chat partner (not the current user)
            const isCurrentUserSender = chat.sender_id == window.userId;
            const chatPartner = isCurrentUserSender ? chat.receiver : chat.sender;

            // Handle case where chat partner data might be missing
            const partnerName = chatPartner ? `${chatPartner.first_name || ''} ${chatPartner.last_name || ''}`.trim() : 'Unknown User';

            chatItem.innerHTML = `
                <div class="flex items-center space-x-4">
                    <div class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center flex-shrink-0 border-2 border-gray-200">
                        <i class="fas fa-user text-gray-600"></i>
                    </div>
                    <div class="flex-1 min-w-0">
                        <h3 class="text-sm font-semibold text-gray-900 truncate">
                            ${partnerName}
                        </h3>
                        <p class="text-sm text-gray-500 truncate mt-1">${chat.message || 'No messages yet'}</p>
                    </div>
                </div>
            `;

            chatItem.addEventListener('click', () => {
                loadChat(receiverId, partnerName);

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
                    <div class="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center border-2 border-gray-200 shadow-sm">
                        <i class="fas fa-user text-gray-600 text-xl"></i>
                    </div>
                    <div class="flex flex-col gap-0.5">
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
                <div style="background-color: ${isCurrentUser ? '#3B82F6' : '#E5E7EB'}; color: ${isCurrentUser ? 'white' : '#1A202C'}; border-radius: 0.5rem; padding: 0.5rem; max-width: 300px; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
                    <p style="font-size: 0.875rem; white-space: pre-wrap;">${message.message}</p>
                    ${attachmentHtml}
                    <p style="font-size: 0.75rem; color: ${isCurrentUser ? 'rgba(255, 255, 255, 0.6)' : 'rgba(26, 32, 44, 0.6)'}; margin-top: 0.25rem; text-align: right;">
                        ${new Date(message.created_at).toLocaleTimeString()}
                    </p>
                </div>
            `;

            return messageElement;
        }

        // File upload preview
        const attachmentInput = document.getElementById('attachment');
        const attachmentPreview = document.getElementById('attachmentPreview');
        
        attachmentInput?.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (!file) {
                attachmentPreview.classList.add('hidden');
                return;
            }

            const fileName = file.name;
            const fileSize = (file.size / 1024 / 1024).toFixed(2); // Convert to MB

            attachmentPreview.innerHTML = `
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <i class="fas ${file.type.includes('image') ? 'fa-image' : 'fa-file'} text-gray-500"></i>
                        <span class="text-sm text-gray-700">${fileName} (${fileSize} MB)</span>
                    </div>
                    <button type="button" class="text-red-500 hover:text-red-700" onclick="removeAttachment()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            `;
            attachmentPreview.classList.remove('hidden');
        });

        // Remove attachment
        window.removeAttachment = function() {
            attachmentInput.value = '';
            attachmentPreview.classList.add('hidden');
        };

        messageForm?.addEventListener("submit", async (e) => {
            e.preventDefault();
            const messageText = messageInput.value.trim();
            const attachment = attachmentInput.files[0];
            
            if ((!messageText && !attachment) || !currentAgentId.value) return;

            sendMessageButton.disabled = true;

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
                    const messageElement = createMessageElement(response.data.chat[0]);
                    messagesContainer.appendChild(messageElement);
                    messageInput.value = "";
                    attachmentInput.value = "";
                    attachmentPreview.classList.add('hidden');
                    scrollToBottom();
                }
            } catch (error) {
                console.error('Error sending message:', error);
            } finally {
                sendMessageButton.disabled = false;
            }
        });

        function scrollToBottom() {
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        function highlightActiveChat(activeId) {
            document.querySelectorAll("#chatList > div").forEach(chatItem => {
                chatItem.classList.toggle('bg-gray-300', chatItem.dataset.receiverId === activeId);
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
        height: 100%;
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
        height: 100%;
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
        padding: 0.75rem 1.5rem;
        background-color: white;
        border-bottom: 1px solid #e5e7eb;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 1rem;
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
        min-height: 0;
    }

    .message-container {
        display: flex;
        margin-bottom: 0.75rem;
        max-width: 80%;
    }

    .message-container.sent {
        justify-content: flex-end;
    }

    .message-bubble {
        max-width: 100%;
        padding: 0.75rem 1rem;
        border-radius: 0.75rem;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        word-wrap: break-word;
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
        padding: 1rem;
        background-color: white;
        border-top: 1px solid #e5e7eb;
    }

    .chat-input-form {
        display: flex;
        gap: 1rem;
        align-items: flex-start;
    }

    .chat-input-field {
        flex: 1;
        padding: 0.75rem 1rem;
        border: 1px solid #e5e7eb;
        border-radius: 0.5rem;
        background-color: #f9fafb;
        min-height: 45px;
        max-height: 120px;
        resize: vertical;
    }

    .chat-input-field:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
    }

    .chat-send-button {
        padding: 0.5rem 1rem;
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
        width: 2.5rem;
        height: 2.5rem;
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

    /* Fix for PDF attachment name overflow */
    .chat-messages a {
        word-break: break-word;
        max-width: 100%;
        display: inline-block;
    }

    /* Ensure message bubbles handle long content properly */
    .chat-messages p {
        word-wrap: break-word;
        overflow-wrap: break-word;
        max-width: 100%;
    }

    #attachmentPreview {
        padding: 0.5rem;
        margin-top: 0.5rem;
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .chat-sidebar {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            z-index: 10;
            width: 280px;
        }

        .message-container {
            max-width: 90%;
        }
    }
</style>