<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CallEnded implements ShouldBroadcastNow
{
    use InteractsWithSockets, SerializesModels;

    public $userId;
    public $channel;
    public $sessionId;

    public function __construct($userId, $channel, $sessionId)
    {
        $this->userId = $userId;
        $this->channel = $channel;
        $this->sessionId = $sessionId;
    }

    public function broadcastOn()
    {
        return new Channel('user.' . $this->userId);
    }

    public function broadcastAs()
    {
        return 'call.ended';
    }

    public function broadcastWith()
    {
        return [
            'userId' => $this->userId,
            'channel' => $this->channel,
            'sessionId' => $this->sessionId,
        ];
    }
} 