<div
    id="chatsModal"
    class="dark:bg-gray-100"
    style="position: fixed; inset: 0; z-index: 2000; display: none; display: flex; align-items: center; justify-content: center; background: rgba(0, 0, 0, 0.5);">
    <div class="dark:bg-gray-800 chat-modal"
        style="background: white; color: #333; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); width: 90%; max-width: 95%; padding: 16px; max-height: 80vh; overflow: hidden;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
        <button
            id="sidebarToggle"
            class=" relative top-4 left-4 z-50 p-2 bg-white rounded-lg shadow-lg hover:bg-gray-50 transition-colors">
            <i class="fas fa-bars" id="menuIcon"></i>
            <i class="fas fa-times hidden" id="closeIcon"></i>
        </button>
            <h2 class="dark:text-white" style="font-size: 1.25rem; font-weight: bold; color: #333; margin: 16px auto; text-align: center;">Chats</h2>
            <!-- Mobile Sidebar Toggle -->
        
            <button
                id="closeChatsModal"
                style="background: #e0e0e0; color: #555; padding: 8px 16px; border-radius: 4px; border: none; cursor: pointer; margin-left: auto;"
                onmouseover="this.style.background='#d6d6d6'"
                onmouseout="this.style.background='#e0e0e0'"
                onclick="toggleModal('chatsModal');">
                Close
            </button>
        </div>
        <div style="display: flex; flex-direction: column; gap: 16px; overflow-y: auto; max-height: calc(80vh - 100px);">
            @if(isset($author_id))
            @include('plugins/real-estate::user.chat', ['author_id' => $author_id])
            @else
            @include('plugins/real-estate::user.chat')
            @endif
        </div>
    </div>
</div>


<!-- Responsive Styling -->
<style>
    @media (min-width: 480px) {
        /* Small screens (mobile) */
        .chat-modal {
            max-width: 100%; /* Ensure it fits within the screen */
            padding: 16px; /* Adjust padding for smaller screens */
        }
    }

    @media (min-width: 768px) {

        /* Tablets */
        .chat-modal {
            max-width: 80%;
        }
    }

    @media (min-width: 1024px) {

        /* Laptops */
        .chat-modal {
            max-width: 70%;
        }
    }

    @media (min-width: 1280px) {

        /* Desktops */
        .chat-modal {
            max-width: 50%;
        }
    }
</style>