<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class AgentCalling implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $userId;
    public $channel;

    public function __construct($userId, $channel)
    {
        $this->userId = $userId;
        $this->channel = $channel;
    }

    public function broadcastOn()
    {
        return new PrivateChannel('user.' . $this->userId);
    }

    public function broadcastWith()
    {
        return [
            'userId' => $this->userId,
            'channel' => $this->channel,
            'timestamp' => now()->toIso8601String(),
        ];
    }

    public function broadcastAs()
    {
        return 'incoming.call';
    }
}
