<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Illuminate\Broadcasting\Channel;

class MessageSent implements ShouldBroadcastNow
{
    use InteractsWithSockets, SerializesModels;

    public $message;
    public $sender_id;
    public $receiver_id;
    public $timestamp;

    public function __construct($message, $sender_id, $receiver_id)
    {
        Log::info('MessageSent event fired.', [
            'message' => $message,
            'sender_id' => $sender_id,
            'receiver_id' => $receiver_id,
        ]);
        $this->message = $message;
        $this->sender_id = $sender_id;
        $this->receiver_id = $receiver_id;
        $this->timestamp = now()->toDateTimeString(); // Add a timestamp for message sent time
    }

    public function broadcastOn()
    {
        Log::info('Broadcasting to channel: chat.' . $this->receiver_id . '.' . $this->sender_id);
        return new Channel('chat.' . $this->receiver_id . '.' . $this->sender_id);
    }

    public function broadcastAs()
    {
        Log::info('Broadcasting as: message.sent');
        return 'message.sent';
    }

    public function broadcastWith()
    {
        Log::info('Broadcasting with data:', [
            'message' => $this->message,
            'sender_id' => $this->sender_id,
            'receiver_id' => $this->receiver_id,
            'timestamp' => $this->timestamp,
        ]);
        return [
            'message' => $this->message,
            'sender_id' => $this->sender_id,
            'receiver_id' => $this->receiver_id,
            'timestamp' => $this->timestamp,
        ];
    }
}

