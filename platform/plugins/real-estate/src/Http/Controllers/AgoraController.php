<?php

namespace Botble\RealEstate\Http\Controllers;

use Botble\RealEstate\Models\Booking;
use Botble\Base\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Botble\Base\Facades\Assets;
use App\Providers\RtcTokenBuilder;

class AgoraController extends BaseController
{
    private $appID;
    private $appCertificate;

    public function __construct()
    {
        $this->appID = env('AGORA_APP_ID');
        $this->appCertificate = env('AGORA_APP_CERTIFICATE');
    }

    protected function token(Request $request)
{
    $appId = getenv("AGORA_APP_ID");
    $appCertificate = getenv("AGORA_APP_CERTIFICATE");

    $channelName = $request->input('channelName'); // Use channel name from request
    $uid = $request->input('uid'); // Use UID from request

    $tokenExpirationInSeconds = 3600; // Set token expiration
    $privilegeExpirationInSeconds = 3600; // Set privilege expiration

    // Generate the token
    $token = RtcTokenBuilder::buildTokenWithUid(
        $appId,
        $appCertificate,
        $channelName,
        $uid,
        RtcTokenBuilder::ROLE_PUBLISHER,
        $tokenExpirationInSeconds,
        $privilegeExpirationInSeconds
    );

    return $token; // Return the token in JSON format
}


    public function joinStream($channel)
    {
        Assets::addScriptsDirectly('vendor/core/plugins/real-estate/js/join.js');

        // Render the join stream view
        return view('plugins/real-estate::broadcast.join', compact('channel'));
    }
}
