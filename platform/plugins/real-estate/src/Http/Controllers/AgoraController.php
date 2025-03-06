<?php

namespace Botble\RealEstate\Http\Controllers;

use Botble\RealEstate\Models\Booking;
use Botble\Base\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Botble\Base\Facades\Assets;
use App\Providers\RtcTokenBuilder;
use Illuminate\Support\Facades\Http;
use Botble\RealEstate\Models\Property;

class AgoraController extends BaseController
{
    private $appID;
    private $appCertificate;
    private $restAPIBaseUrl;


    public function __construct()
    {
        $this->appID = env('AGORA_APP_ID');
        $this->appCertificate = env('AGORA_APP_CERTIFICATE');
        $this->restAPIBaseUrl = 'https://api.agora.io/v1/apps/' . $this->appID . '/channels/';
    }

    /**
     * Check the stream status for a given channel.
     *
     * @param  string  $channelName
     * @return \Illuminate\Http\JsonResponse
     */
    public function checkStreamStatus(Request $request)
    {
        $channelName = $request->input('channelName'); // Channel name from the request

        // Construct the URL for Agora's channel status API
        $url = $this->restAPIBaseUrl . $channelName . '/status';

        try {
            // Send GET request to Agora's API to get channel status
            $response = Http::withHeaders([
                'Authorization' => 'Basic ' . base64_encode($this->appID . ':' . $this->appCertificate)
            ])->get($url);

            // Check the response status
            if ($response->successful()) {
                $data = $response->json();
                return response()->json([
                    'status' => 'success',
                    'data' => $data
                ]);
            } else {
                // Handle error if API call fails
                return response()->json([
                    'status' => 'error',
                    'message' => 'Failed to retrieve channel status',
                    'error' => $response->body()
                ], 400);
            }
        } catch (\Exception $e) {
            // Handle any exceptions
            return response()->json([
                'status' => 'error',
                'message' => 'Error while checking stream status',
                'error' => $e->getMessage()
            ], 500);
        }
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


    public function joinStream($propertyId)
    {
        $property = Property::findOrFail($propertyId);
        Assets::addScriptsDirectly('vendor/core/plugins/real-estate/js/join.js');

        return view('plugins/real-estate::broadcast.join', compact('property'));
    }

    public function joinLive(string|int $propertyId)
    {
        try {
            $property = Property::query()->findOrFail($propertyId);

            if (!$property instanceof Property) {
                return redirect()->back()
                    ->with('error', 'Invalid property data.');
            }

            Assets::addScriptsDirectly('vendor/core/plugins/real-estate/js/join.js');

            return view('plugins/real-estate::user.join', compact('property'));
        } catch (\Exception $e) {
            Log::error('Error in joinLive: ' . $e->getMessage());
            return redirect()->back()
                ->with('error', 'Unable to join the live stream. Please try again later.');
        }
    }
}
