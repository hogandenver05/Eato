<?php

namespace App\Http\Controllers;

use App\Models\Food;
use Illuminate\Http\Request;

class FoodController extends Controller
{
    // List foods for the authenticated user
    public function index(Request $request)
    {
        $foods = Food::where('user_id', $request->user()->id)->get();

        return response()->json($foods);
    }

    // Create a new food entry
    public function store(Request $request)
    {
        $validated = $request->validate([
            'food_name' => 'required|string|max:100',
            'calories' => 'required|integer',
        ]);

        $food = Food::create([
            'user_id' => $request->user()->id,
            'food_name' => $validated['food_name'],
            'calories' => $validated['calories'],
        ]);

        return response()->json($food, 201);
    }

    // Fetch a single food entry
    public function show(Request $request, Food $food)
    {
        if ((int) $food->getAttribute('user_id') !== (int) $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($food);
    }

    // Update a food entry
    public function update(Request $request, Food $food)
    {
        if ($food->getAttribute('user_id') !== (int) $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'food_name' => 'required|string|max:100',
            'calories' => 'required|integer',
        ]);

        $food->update($validated);

        return response()->json($food);
    }

    // Delete a food entry
    public function destroy(Request $request, Food $food)
    {
        if ($food->getAttribute('user_id') !== (int) $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $food->delete();

        return response()->json(['message' => 'Food deleted']);
    }
}
