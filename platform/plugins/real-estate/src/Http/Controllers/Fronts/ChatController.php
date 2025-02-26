<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use App\Events\MessageSent;
use Illuminate\Support\Facades\Log;
use Botble\Base\Http\Controllers\BaseController;
use Botble\RealEstate\Models\Account;
use Botble\RealEstate\Models\Chat;
use Illuminate\Http\Request;
use Illuminate\Contracts\View\View;
use App\Models\ChatMessage;
use Illuminate\Support\Facades\Auth;

class ChatController extends BaseController
{
    /**
     * Display the chat view.
     *
     * @return View
     */
    public function showChatModal(?int $author_id = null): View
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

        broadcast(new MessageSent($message->message, auth('account')->id(), $message->receiver_id))->toOthers();

        $chatData = Chat::with(['sender', 'receiver'])
            ->where('id', $message->id)
            ->orderBy('created_at', 'asc')
            ->get();
        return response()->json(['success' => true, 'chat' => $chatData]);
    }
    public function getChatWithAgent(Request $request)
    {
        $senderId = $request->query('sender_id');
        $receiverId = $request->query('receiver_id');

        $chats = Chat::with(['sender', 'receiver'])
            ->where(function ($query) use ($senderId, $receiverId) {
                $query->where('sender_id', $senderId)
                    ->where('receiver_id', $receiverId);
            })
            ->orWhere(function ($query) use ($senderId, $receiverId) {
                $query->where('sender_id', $receiverId)
                    ->where('receiver_id', $senderId);
            })
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json(['success' => true, 'data' => $chats]);
    }
    public function getChats(Request $request)
    {
        try {
            $senderId = $request->query('sender_id');
            $chats = Chat::with(['sender', 'receiver'])
                ->select('id', 'sender_id', 'receiver_id', 'message', 'created_at')
                ->where(function ($query) use ($senderId) {
                    $query->where('sender_id', $senderId)
                        ->orWhere('receiver_id', $senderId);
                })
                ->orderBy('created_at', 'desc')
                ->get()
                ->groupBy(function ($chat) use ($senderId) {
                    return $chat->sender_id == $senderId ? $chat->receiver_id : $chat->sender_id;
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
    
    public function showChatAgent()
    {
        return view('plugins/real-estate::chats.index');
    }
}
