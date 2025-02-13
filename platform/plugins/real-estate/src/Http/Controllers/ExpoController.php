<?php
// app/Http/Controllers/ExpoController.php
namespace Botble\RealEstate\Http\Controllers;

use Botble\RealEstate\Models\Expo;
use Illuminate\Http\Request;
use Botble\Base\Http\Controllers\BaseController;
use Illuminate\Http\JsonResponse;

final class ExpoController extends BaseController
{
    public function index(): JsonResponse
    {
        return response()->json(Expo::all());
    }

    public function store(Request $request): JsonResponse
{
    $request->validate([
        'enabled' => 'boolean',
    ]);

    // First try to find an existing expo for today
    $existingExpo = Expo::where('expo_date', now()->toDateString())->first();

    if ($existingExpo) {
        // Update the existing expo instead of creating a new one
        $existingExpo->update([
            'enabled' => $request->input('enabled', false),
        ]);
        
        return response()->json($existingExpo, 200);
    }

    // Create new expo if none exists for today
    $data = [
        'enabled' => $request->input('enabled', false),
        'expo_date' => now(),
    ];

    $expo = Expo::create($data);

    return response()->json($expo, 201);
}
}