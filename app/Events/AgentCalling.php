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

class AgentCalling implements ShouldBroadcastNow
{
    use InteractsWithSockets, SerializesModels;

    public $userId;
    public $channel;
    public $callerName;
    public $callerId;

    public $sessionId;

    public function __construct($userId, $channel, $callerName, $callerId, $sessionId)
    {
        $this->userId = $userId;
        $this->channel = $channel;
        $this->callerName = $callerName;
        $this->callerId = $callerId;
        $this->sessionId = $sessionId;

        Log::info('AgentCalling event triggered', [
            'userId' => $this->userId,
            'channel' => $this->channel,
            'callerName' => $this->callerName,
            'callerId' => $this->callerId,
            'sessionId' => $this->sessionId,
            'timestamp' => now()->toIso8601String(),
        ]);
    }

    public function broadcastOn()
    {
        Log::info('Broadcasting to user.' . $this->userId);
        return new Channel('user.' . $this->userId);
    }

    public function broadcastWith()
    {
        Log::info('Broadcasting with data:', [
            'userId' => $this->userId,
            'channel' => $this->channel,
            'callerName' => $this->callerName,
            'callerId' => $this->callerId,
            'sessionId' => $this->sessionId,
            'timestamp' => now()->toIso8601String(),
        ]);

        return [
            'userId' => $this->userId,
            'channel' => $this->channel,
            'callerName' => $this->callerName,
            'callerId' => $this->callerId,
            'sessionId' => $this->sessionId,
            'timestamp' => now()->toIso8601String(),
        ];
    }

    public function broadcastAs()
    {
        Log::info('Broadcasting as incoming.call');
        return 'incoming.call';
    }
}
