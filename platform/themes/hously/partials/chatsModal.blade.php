@php
    $author_id = $author_id ?? "null";
@endphp

<div
    id="chatsModal"
    class="dark:bg-gray-100"
    style="position: fixed; inset: 0; z-index: 2000; display: none; display: flex; align-items: center; justify-content: center; background: rgba(0, 0, 0, 0.5);">
    <div class="dark:bg-gray-800"
        style="background: white; color: #333; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); width: 90%; max-width: 600px; padding: 24px; max-height: 80vh; overflow: hidden;">
        <h2 class="dark:text-white" style="font-size: 1.25rem; font-weight: bold; color: #333; margin-bottom: 16px; text-align: center;">Chats</h2>
        <!-- Modal content in vertical order -->
        <div style="display: flex; flex-direction: column; gap: 16px; overflow-y: auto; max-height: calc(80vh - 100px);">
            @if(isset($author_id))
            @include('plugins/real-estate::user.chat', ['author_id' => $author_id])
            @else
            @include('plugins/real-estate::user.chat')
            @endif
            <!-- Close Button -->
            <button
                style="background: #e0e0e0; color: #555; padding: 8px 16px; border-radius: 4px; border: none; cursor: pointer; align-self: flex-end;"
                onmouseover="this.style.background='#d6d6d6'"
                onmouseout="this.style.background='#e0e0e0'"
                onclick="toggleModal('chatsModal')">
                Close
            </button>
            <!-- Debugging statement -->
        </div>
    </div>
</div>