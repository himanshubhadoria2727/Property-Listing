namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AgentSessionController extends Controller
{
    public function createSession($agentId)
    {
        // Insert a new agent session
        DB::table('agent_sessions')->insert([
            'agent_id' => $agentId,
            'session_id' => session()->getId(),
            'is_available' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'Session created successfully.']);
    }
} 