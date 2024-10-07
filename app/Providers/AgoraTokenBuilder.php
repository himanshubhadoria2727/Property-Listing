<?php

namespace App\Providers;

use Illuminate\Broadcasting\Channel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
class AgoraTokenBuilder
{
    private $appId;
    private $channelName;

    private $appCertificate;
    
    public function __construct($appId, $appCertificate)
    {
        $this->appId = $appId;
        $this->appCertificate = $appCertificate;
    }

    protected function token(Request $request)
    {
        $appID = env('AGORA_APP_ID');
        $appCertificate = env('AGORA_APP_CERTIFICATE');
        $channelName = $request->channelName;
        $user = Auth::user()->name;
        $role = RtcTokenBuilder::RoleAttendee;
        $expireTimeInSeconds = 3600;
        $currentTimestamp = now()->getTimestamp();
        $privilegeExpiredTs = $currentTimestamp + $expireTimeInSeconds;

        // Log the token generation parameters
        Log::info('Generating Agora token', [
            'appID' => $appID,
            'channelName' => $channelName,
            'user' => $user,
            'role' => $role,
            'expireTimeInSeconds' => $expireTimeInSeconds,
            'currentTimestamp' => $currentTimestamp,
            'privilegeExpiredTs' => $privilegeExpiredTs,
        ]);

        $token = RtcTokenBuilder::buildTokenWithUserAccount($appID, $appCertificate, $channelName, $user, $role, $privilegeExpiredTs);

        // Log the generated token (avoid logging sensitive information in production)
        Log::info('Generated Agora token', [
            'token' => $token, // Consider removing or obfuscating the token in production
        ]);

        return $token;
    }
}
