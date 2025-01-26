<div style="display: flex; height: 100vh;">
    <!-- Left Panel - Chat List -->
    <div style="width: 25%; background-color: #f7fafc; border-right: 1px solid #e2e8f0; display: flex; flex-direction: column;">
        <div style="padding: 16px; border-bottom: 1px solid #e2e8f0;">
            <h2 style="font-size: 1.25rem; font-weight: 600;">Chats</h2>
        </div>
        <div style="flex: 1; overflow-y: auto;" id="chatList">
            <!-- Chat list items will be dynamically loaded from the server -->
        </div>
    </div>

    <!-- Right Panel - Chat Messages -->
    <div style="flex: 1; display: flex; flex-direction: column;">
        <!-- Chat Header -->
        <div style="padding: 16px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center;" id="chatHeader">
            <h3 style="font-size: 1.125rem; font-weight: 600;">Conversation</h3>
        </div>

        <!-- Messages Container -->
        <div style="flex: 1; overflow-y: auto; padding: 16px; display: flex; flex-direction: column; gap: 16px;" id="messagesContainer">
            <p id="noConversationMessage" style="color: #718096;">Select an agent to start conversation.</p>
        </div>

        <!-- Message Input -->
        <div style="padding: 16px; border-top: 1px solid #e2e8f0;" id="messageInputContainer">
            <form id="messageForm" style="display: flex; gap: 8px;">
                <input type="hidden" id="currentAgentId" value="" />
                <input
                    id="messageInput"
                    type="text"
                    style="flex: 1; border-radius: 0.5rem; border: 1px solid #e2e8f0; padding: 8px 16px; outline: none; border-color: #4299e1;"
                    placeholder="Type your message..." />
                <button
                    type="submit"
                    id="sendMessageButton"
                    style="background-color: #4299e1; color: white; padding: 8px 16px; border-radius: 0.5rem; cursor: pointer;">
                    Send
                </button>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const chatList = document.getElementById("chatList");
        const messagesContainer = document.getElementById("messagesContainer");
        const messageForm = document.getElementById("messageForm");
        const messageInput = document.getElementById("messageInput");
        const noConversationMessage = document.getElementById("noConversationMessage");
        const currentAgentId = document.getElementById("currentAgentId");
        const chatHeader = document.getElementById("chatHeader");
        const messageInputContainer = document.getElementById("messageInputContainer");
        // Hide message input initially
        messageInputContainer.style.display = "none";

        // Load chat list from server
        function loadChatList() {
            fetch('/chats')
                .then(response => response.json())
                .then(result => {
                    // Access the 'data' property of the response
                    if (result.success && Array.isArray(result.data)) {
                        const chatListData = result.data; // This is the array of chats
                        chatList.innerHTML = ''; // Clear the chat list container

                        if (chatListData.length === 0) {
                            // No chats found, create a new one using author_id from localStorage
                            createNewChat();
                        } else {
                            // Loop through the chat list and render items
                            chatListData.forEach(chat => {
                                const chatItem = createChatListItem(chat);
                                chatList.appendChild(chatItem);
                            });
                        }
                    } else {
                        console.error('Invalid response format or no chats found.');
                    }
                })
                .catch(error => console.error('Error loading chat list:', error));
        }

        function createNewChat() {
            const csrf = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

            axios.post('/chat/create', {
                    receiver_id: localStorage.getItem('authorId')
                }, {
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrf
                    }
                })
                .then(response => {
                    console.log('Chat created:', response.data);
                    loadChatList(); // Reload the chat list to include the new chat
                })
                .catch(error => {
                    console.error('Error creating chat:', error);
                    if (error.response) {
                        console.error('Response data:', error.response.data);
                    }
                });
        }
        // Create chat list item
        function createChatListItem(chat) {
            console.log(chat);
            const name= chat.receiver.first_name + ' ' + chat.receiver.last_name;
            const chatItem = document.createElement("div");
            chatItem.style = "padding: 16px; cursor: pointer; border-bottom: 1px solid #e2e8f0;";
            chatItem.innerHTML = `
                <div style="font-weight: 500;">${name}</div>
                <div style="font-size: 0.875rem; color: #718096; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                    ${chat.last_message || 'No messages yet'}
                </div>
            `;

            chatItem.addEventListener("click", () => loadChat(chat.agent_id, name));
            return chatItem;
        }

        // Load chat messages
        function loadChat(agentId, agentName) {
            currentAgentId.value = agentId;
            chatHeader.innerHTML = `<h3 style="font-size: 1.125rem; font-weight: 600;">${agentName}</h3>`;
            noConversationMessage.style.display = "none";
            messageInputContainer.style.display = "flex";

            fetch(`/chats/${agentId}/messages`)
                .then(response => response.json())
                .then(messages => {
                    messagesContainer.innerHTML = '';
                    messages.forEach(message => {
                        const messageElement = createMessageElement(message);
                        messagesContainer.appendChild(messageElement);
                    });
                    scrollToBottom();
                })
                .catch(error => console.error('Error loading messages:', error));
        }

        // Create message element
        function createMessageElement(message) {
            const messageElement = document.createElement("div");
            const isCurrentUser = message.user_id === window.Laravel.userId;

            messageElement.style = `display: flex; justify-content: ${isCurrentUser ? 'flex-end' : 'flex-start'};`;
            messageElement.innerHTML = `
                <div style="background-color: ${isCurrentUser ? '#4299e1' : '#e2e8f0'}; 
                           color: ${isCurrentUser ? 'white' : 'black'}; 
                           border-radius: 0.5rem; 
                           padding: 8px 16px; 
                           max-width: 75%;">
                    <div style="font-size: 0.875rem;">${message.message}</div>
                    <div style="font-size: 0.75rem; color: ${isCurrentUser ? '#bee3f8' : '#718096'}; margin-top: 4px;">
                        ${new Date(message.created_at).toLocaleTimeString()}
                    </div>
                </div>
            `;
            return messageElement;
        }

        // Handle message submission
        messageForm.addEventListener("submit", (e) => {
            e.preventDefault();
            const messageText = messageInput.value.trim();
            if (messageText === "" || !currentAgentId.value) return;

            const formData = new FormData();
            formData.append('message', messageText);
            formData.append('agent_id', currentAgentId.value);

            fetch('/api/chats/send', {
                    method: 'POST',
                    headers: {
                        'X-CSRF-TOKEN': window.Laravel.csrfToken
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(message => {
                    const messageElement = createMessageElement(message);
                    messagesContainer.appendChild(messageElement);
                    messageInput.value = "";
                    scrollToBottom();
                })
                .catch(error => console.error('Error sending message:', error));
        });

        // Scroll to bottom of messages
        function scrollToBottom() {
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        // Initial load of chat list
        loadChatList();

        // Optional: Implement real-time updates with Laravel Echo
        if (window.Echo) {
            const author_id = localStorage.getItem('authorId');
            window.Echo.private(`chat.${author_id}.${window.userId}`)
                .listen('message.sent', (e) => {
                    if (e.chat.agent_id === currentAgentId.value) {
                        const messageElement = createMessageElement(e.chat);
                        messagesContainer.appendChild(messageElement);
                        scrollToBottom();
                    }
                    loadChatList(); // Refresh chat list to update last messages
                });
        }
    });
</script>