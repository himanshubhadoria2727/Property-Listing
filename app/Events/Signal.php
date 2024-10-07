<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class Signal implements ShouldBroadcast
{
    public $type;
    public $data;
    public $sender;
    public $receiver;

    public function __construct($type, $data, $sender, $receiver)
    {
        $this->type = $type;
        $this->data = $data;
        $this->sender = $sender;
        $this->receiver = $receiver;
    }

    public function broadcastOn()
    {
        return new Channel('property-channel');
    }
}
