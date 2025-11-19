<?php

namespace App\Http\Controllers;

use App\Models\Favorite;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{   
    // List favorites for authenticated user
    public function index(Request $request)
    {
        $favorites = Favorite::with('food')
            ->where('user_id', $request->user()->id)
            ->get();

        return response()->json($favorites);
    }

    // Add a food to favorites
    public function store(Request $request)
    {
        $validated = $request->validate([
            'food_id' => 'required|exists:foods,id'
        ]);

        // Prevent duplicate favorite
        $favorite = Favorite::firstOrCreate([
            'user_id' => $request->user()->id,
            'food_id' => $validated['food_id'],
        ]);

        return response()->json($favorite, 201);
    }

    // Remove a favorite
    public function destroy(Request $request, $favoriteId)
    {
        $favorite = Favorite::find($favoriteId);

        if (!$favorite) {
            return response()->json(['message' => 'Favorite not found'], 404);
        }

        if ($favorite->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $favorite->delete();

        return response()->json(['message' => 'Favorite removed']);
    }
}
