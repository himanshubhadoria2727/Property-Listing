<?php

namespace App\Listeners;

use App\Events\AgentCalling;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Log;

class AgentCallingListener
{
    /**
     * Handle the event.
     *
     * @param  \App\Events\AgentCalling  $event
     * @return void
     */
    public function handle(AgentCalling $event)
    {
        Log::info('Agent calling event triggered', [
            'userId' => $event->userId,
            'channel' => $event->channel
        ]);
    }
}
