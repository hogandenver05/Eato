<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Food;
use Laravel\Sanctum\Sanctum;
use Illuminate\Foundation\Testing\RefreshDatabase;

class FoodApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_crud_foods()
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user, ['*']);

        // Create food
        $response = $this->postJson('/api/foods', [
            'food_name' => 'Banana',
            'calories' => 105,
        ]);
        $response->assertStatus(201)
                 ->assertJson([
                     'food_name' => 'Banana',
                     'calories' => 105,
                     'user_id' => $user->id,
                 ]);

        $foodId = $response->json('id');

        // List foods
        $response = $this->getJson('/api/foods');
        $response->assertStatus(200)
                 ->assertJsonFragment(['food_name' => 'Banana']);

        // Fetch single food
        $response = $this->getJson("/api/foods/{$foodId}");
        $response->assertStatus(200)
                 ->assertJson(['food_name' => 'Banana']);

        // Update food
        $response = $this->putJson("/api/foods/{$foodId}", [
            'food_name' => 'Apple',
            'calories' => 95,
        ]);
        $response->assertStatus(200)
                 ->assertJson([
                     'food_name' => 'Apple',
                     'calories' => 95,
                 ]);

        // Delete food
        $response = $this->deleteJson("/api/foods/{$foodId}");
        $response->assertStatus(200)
                 ->assertJson(['message' => 'Food deleted']);

        // Confirm deletion returns 404
        $response = $this->getJson("/api/foods/{$foodId}");
        $response->assertStatus(404);
    }

    public function test_user_cannot_access_others_food()
    {
        $user1 = User::factory()->create();
        $user2 = User::factory()->create();

        $food = Food::factory()->create(['user_id' => $user1->id]);
        Sanctum::actingAs($user2, ['*']);

        // Fetch another user's food
        $response = $this->getJson("/api/foods/{$food->id}");
        $response->assertStatus(403)
                 ->assertJson(['message' => 'Forbidden']);

        // Update another user's food
        $response = $this->putJson("/api/foods/{$food->id}", [
            'food_name' => 'Hacked',
            'calories' => 999,
        ]);
        $response->assertStatus(403);

        // Delete another user's food
        $response = $this->deleteJson("/api/foods/{$food->id}");
        $response->assertStatus(403);
    }
}
