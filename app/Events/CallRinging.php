<?php

declare(strict_types=1);

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

final class CallRinging implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public readonly int|string $userId,
        public readonly string $channel,
        public readonly string $sessionId
    ) {}

    public function broadcastOn(): Channel
    {
        return new Channel('user.' . $this->userId);
    }

    public function broadcastAs(): string
    {
        return 'call.ringing';
    }

    public function broadcastWith(): array
    {
        return [
            'userId' => $this->userId,
            'channel' => $this->channel,
            'sessionId' => $this->sessionId,
        ];
    }
} 