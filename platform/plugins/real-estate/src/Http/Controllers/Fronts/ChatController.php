<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use App\Events\MessageSent;
use Illuminate\Support\Facades\Log;
use Botble\Base\Http\Controllers\BaseController;
use Botble\RealEstate\Models\Account;
use Botble\RealEstate\Models\Chat;
use Illuminate\Http\Request;
use Illuminate\Contracts\View\View;

class ChatController extends BaseController
{
    /**
     * Display the chat view.
     *
     * @return View
     */
    public function showChatModal($author_id): View
    {
        return view('plugins/real-estate::user.chat', compact('author_id'));
    }

    public function sendMessage(Request $request)
    {
        $message = Chat::create([
            'sender_id' => $request->sender_id,
            'receiver_id' => $request->receiver_id,
            'message' => $request->message,
        ]);

        broadcast(new MessageSent($message->message, auth('account')->id()))->toOthers();

        return response()->json(['success' => true]);
    }

    public function getChats()
    {
        try {
            // Log::info('Fetching chats for user: ' . Account::find(auth()->id())->name);
            // Fetch chats where the user is either the sender or the receiver
            $chats = Chat::with(['sender', 'receiver'])
                ->select('id', 'sender_id', 'receiver_id', 'message', 'created_at')
                ->where(function ($query) {
                    $query->where('receiver_id', auth('account')->id())
                        ->orWhere('sender_id', auth('account')->id());
                })
                ->orderBy('created_at', 'desc')
                ->get();

            // Add a direction field to indicate incoming or outgoing messages
            $chats = $chats->map(function ($chat) {
                $chat->direction = $chat->sender_id === auth('account')->id() ? 'outgoing' : 'incoming';
                return $chat;
            });

            return response()->json([
                'success' => true,
                'data' => $chats
            ]);
        } catch (\Exception $exception) {
            return response()->json([
                'success' => false,
                'error' => $exception->getMessage()
            ], 500);
        }
    }

    public function createChat(Request $request)
    {
        // $request->validate([
        //     'receiver_id' => 'required|exists:accounts,id', // Ensure the receiver exists
        // ]);

        $senderId = auth('account')->id(); // Get the authenticated user's ID
        $receiverId = $request->input('receiver_id');

        // Prevent creating a chat with oneself
        if ($senderId === $receiverId) {
            return response()->json([
                'success' => false,
                'message' => 'You cannot create a chat with yourself.',
            ], 400);
        }

        // Check if a chat already exists between the sender and receiver
        $existingChat = Chat::where(function ($query) use ($senderId, $receiverId) {
            $query->where('sender_id', $senderId)
                ->where('receiver_id', $receiverId);
        })->orWhere(function ($query) use ($senderId, $receiverId) {
            $query->where('sender_id', $receiverId)
                ->where('receiver_id', $senderId);
        })->first();

        if ($existingChat) {
            return response()->json([
                'success' => true,
                'message' => 'Chat already exists.',
                'chat' => $existingChat,
            ], 200);
        }

        // Create a new chat
        $newChat = Chat::create([
            'sender_id' => $senderId,
            'receiver_id' => $receiverId,
            'message' => 'Start a new conversation!',
            'timestamp' => now(), // Ensure timestamp is set
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Chat created successfully.',
            'chat' => $newChat,
        ], 201);
    }
}
