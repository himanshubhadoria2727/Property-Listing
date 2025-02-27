<?php

namespace Botble\RealEstate\Http\Controllers\Fronts;

use App\Events\AgentCalling;
use App\Events\CallBusy;
use App\Events\UserCalling;
use Botble\RealEstate\Models\Booking;
use Botble\RealEstate\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Botble\Base\Http\Controllers\BaseController;
use Botble\RealEstate\Models\Account;
use App\Events\CallEnded;
use App\Events\CallRejected;
use App\Events\CallRinging;
use Illuminate\Support\Facades\DB;
use Botble\RealEstate\Models\CallLog;
use App\Models\User;
use Carbon\Carbon;

class CallController extends BaseController
{
    public function bookCall(Request $request)
    {
        $request->validate([
            'property_id' => 'required|exists:re_properties,id',
            'scheduled_at' => 'required|date|after:now',
            'call' => 'boolean', // Validate the 'call' field as boolean
            'live' => 'boolean', // Validate the 'live' field as boolean
        ]);

        $account = Account::query()->findOrFail(auth('account')->id());
        Log::info('account info: ' . $account);

        // Check if the account exists
        if (!$account) {
            return redirect()->back()->withErrors(['error' => 'Account not found.']);
        }

        // Create the booking with 'call' and 'live' fields
        Booking::create([
            'property_id' => $request->property_id,
            'user_id' => $account->id, // Use the account ID instead of auth()->id()
            'scheduled_at' => $request->scheduled_at,
            'call' => true,
            'live' => false,
        ]);

        return redirect()->back()->with('message', 'Call scheduled successfully!');
    }
    public function startCall(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::calls.show', compact('property', 'bookings'));
    }
    public function viewCallBookings(Property $property)
    {
        // Retrieve bookings with their related user information
        $bookings = $property->bookings()->with('user')->get();

        // Return the view with the property and bookings data
        return view('plugins/real-estate::calls.show', compact('property', 'bookings'));
    }

    public function notifyCall(Request $request)
    {
        $validated = $request->validate([
            'userId' => 'required|integer',
            'channel' => 'required|string|max:255',
        ]);

        try {
            $caller = Account::select('first_name', 'last_name', 'id')->findOrFail(auth('account')->id());
            $callerName = trim($caller->first_name . ' ' . $caller->last_name);
            $callerId = $caller->id;

            // Check if sessionId is provided in the request
            $sessionId = $request->sessionId ?? null;

            // If sessionId is not present, get the latest session
            if (!$sessionId) {
                $session = DB::table('agent_sessions')
                    ->where('agent_id', $validated['userId'])
                    ->where('is_available', 1)
                    ->orderBy('created_at', 'desc')
                    ->first();

                $sessionId = $session?->session_id;
            }

            // Add timestamp to the event data
            $eventData = [
                'userId' => $validated['userId'],
                'channel' => $validated['channel'],
                'callerName' => $callerName,
                'callerId' => $callerId,
                'timestamp' => now()->toIso8601String(),
                'sessionId' => $sessionId,
                'sessionData' => $session ?? null
            ];

            Log::info('Broadcasting call notification with data:', $eventData);

            // Modify the event to include sessionId
            broadcast(new AgentCalling(
                $validated['userId'],
                $validated['channel'],
                $callerName,
                $callerId,
                $sessionId  // Add sessionId as a new parameter
            ))->toOthers();

            return response()->json([
                'success' => true,
                'message' => 'Call notification sent successfully',
                'callerId' => $callerId,
                'eventData' => $eventData,
                'sessionId' => $sessionId,
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to send call notification', [
                'error' => $e->getMessage(),
                'stack' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to send call notification'
            ], 500);
        }
    }
    public function notifyAuthor(Request $request)
    {
        // Validate the input parameters
        $validated = $request->validate([
            'userId' => 'required|integer', // Adjust validation as needed
            'channel' => 'required|string|max:255',
        ]);

        Log::info('notifyCall function started', ['userId' => $request->input('userId'), 'channel' => $request->input('channel')]);

        try {
            // Broadcast the event
            broadcast(new UserCalling(
                $request->input('userId'),
                $request->input('channel')
            ))->toOthers();

            Log::info('Call notification sent successfully', ['userId' => $request->input('userId'), 'channel' => $request->input('channel')]);

            return response()->json([
                'success' => true,
                'message' => 'Call notification sent successfully'
            ]);
        } catch (\Exception $e) {
            // Log the full exception for better debugging
            Log::error('Failed to send call notification', [
                'error' => $e->getMessage(),
                'stack' => $e->getTraceAsString(),
                'userId' => $request->input('userId'),
                'channel' => $request->input('channel')
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to send call notification'
            ], 500);
        }
    }

    public function endCall(Request $request)
    {
        $validated = $request->validate([
            'userId' => 'required',
            'channel' => 'required|string',
            'sessionId' => 'required|string'
        ]);

        $sessionId = $request->sessionId ?? null;

        Log::info('Call end triggered', [
            'userId' => $request->userId,
            'channel' => $request->channel
        ]);
        
        event(new CallEnded($request->userId, $request->channel, $sessionId));

        return response()->json([
            'message' => 'Call ended successfully',
            'channel' => $request->channel
        ]);
    }

    public function rejectCall(Request $request)
    {
        $sessionId = $request->sessionId ?? null;

        event(new CallRejected($request->userId, $request->channelName, $sessionId));
        return response()->json(['message' => 'Call rejected successfully']);
    }

    public function ringing(Request $request)
    {
        $sessionId = $request->sessionId ?? null;
        event(new CallRinging($request->userId, $request->channelName, $sessionId));
        return response()->json(['message' => 'Call ringing status set successfully']);
    }

    public function busy(Request $request)
    {
        $validated = $request->validate([
            'userId' => 'required|integer',
            'channelName' => 'required|string',
            'callerId' => 'required|integer',
            'sessionId' => 'required|string'
        ]);

        Log::info('Call busy status triggered', [
            'userId' => $request->userId,
            'channelName' => $request->channelName,
            'callerId' => $request->callerId
        ]);
        $sessionId = $request->sessionId ?? null;

        event(new CallBusy(
            $request->userId,
            $request->channelName,
            $request->callerId,
            $sessionId
        ));

        return response()->json([
            'message' => 'Call busy status set successfully',
            'callerId' => $request->callerId
        ]);
    }

    public function createSession(Request $request)
    {
        $validated = $request->validate([
            'agentId' => 'required|integer',
        ]);

        Log::info('Creating session for agent ID:', ['agentId' => $validated['agentId']]);

        // Check if the agent exists
        $agent = Account::find($validated['agentId']);
        if (!$agent) {
            Log::error('Agent not found for ID:', ['agentId' => $validated['agentId']]);
            return response()->json(['message' => 'Agent not found.'], 404);
        }

        // Check if a session already exists for the agent
        $existingSession = DB::table('agent_sessions')
            ->where('agent_id', $validated['agentId'])
            ->where('session_id', session()->getId())
            ->first();

        if ($existingSession) {
            // If the session exists, update it instead of creating a new one
            return $this->updateSession($request);
        }

        // Insert a new agent session
        DB::table('agent_sessions')->insert([
            'agent_id' => $validated['agentId'],
            'session_id' => session()->getId(),
            'is_available' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        Log::info('Session created successfully for agent ID:', ['agentId' => $validated['agentId']]);

        return response()->json(['message' => 'Session created successfully.']);
    }

    public function updateSession(Request $request)
    {
        $validated = $request->validate([
            'agentId' => 'required|integer',
            'is_available' => 'required|boolean',
            'session_id' => 'required|string'
        ]);

        Log::info('Updating session for agent ID:', ['agentId' => $validated['agentId']]);
        // Update the is_available status
        DB::table('agent_sessions')
            ->where('session_id', $validated['session_id'])
            ->update(['is_available' => $validated['is_available'], 'updated_at' => now()]);

        Log::info('Session updated successfully for agent ID:', ['agentId' => $validated['agentId']]);

        return response()->json(['message' => 'Session updated successfully.']);
    }

    public function callLogs(Request $request)
{
    try {
        // Extract the numeric agent ID from the string
        $agentId = intval(explode('-', $request->agent_id)[0]);

        CallLog::create([
            'user_id' => $request->user_id,
            'call_type' => $request->call_type,
            'channel' => $request->channel,
            'agent_id' => $agentId, // Use the extracted numeric ID
        ]);

        return response()->json(['success' => true, 'message' => 'Call log created successfully.']);
    } catch (\Exception $e) {
        Log::error('Failed to create call log', [
            'error' => $e->getMessage(),
            'userId' => $request->user_id,
            'callType' => $request->call_type,
            'agentId' => $request->agent_id,
            'channel' => $request->channel,
        ]);

        return response()->json(['success' => false, 'message' => 'Failed to create call log.'], 500);
    }
}

    public function getCallLogs(Request $request)
    {
        // Retrieve call logs based on agent_id
        $callLogs = CallLog::where('agent_id', $request->agent_id)->get();

        // Map through each call log to include the username from the Accounts table
        $callLogsWithUsernames = $callLogs->map(function ($callLog) {
            $user = Account::find($callLog->user_id);
            $callLog->username = $user ? $user->firstname . ' ' . $user->lastname : null;
            return $callLog;
        });

        return response()->json(['success' => true, 'data' => $callLogsWithUsernames]);
    }

    public function deleteCallLog($id)
    {
        $callLog = CallLog::find($id);

        if (!$callLog) {
            return response()->json(['success' => false, 'message' => 'Call log not found.'], 404);
        }

        $callLog->delete();

        return response()->json(['success' => true, 'message' => 'Call log deleted successfully.']);
    }
}
