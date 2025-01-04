<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class UserCalling implements ShouldBroadcastNow
{
    use InteractsWithSockets, SerializesModels;

    public $userId;
    public $channel;

    public function __construct($userId, $channel)
    {
        $this->userId = $userId;
        $this->channel = $channel;

        // Log the event data
        Log::info('AgentCalling event triggered', [
            'userId' => $this->userId,
            'channel' => $this->channel,
            'timestamp' => now()->toIso8601String(),
        ]);
    }

    public function broadcastOn()
    {
        Log::info('Broadcasting to user.' . $this->userId);
        return new Channel('author.' . $this->userId);
    }

    public function broadcastWith()
{
    Log::info('Broadcasting with data:', [
        'userId' => $this->userId,
        'channel' => $this->channel,
        'timestamp' => now()->toIso8601String(),
    ]);

    return [
        'userId' => $this->userId,
        'channel' => $this->channel,
        'timestamp' => now()->toIso8601String(),
    ];
}


    public function broadcastAs()
    {
        Log::info('Broadcasting as incoming.call');
        return 'incoming.call';
    }
}
