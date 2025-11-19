<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\User;
use App\Models\Food;
use App\Models\Favorite;
use Laravel\Sanctum\Sanctum;
use Illuminate\Foundation\Testing\RefreshDatabase;

class FavoriteApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_add_list_and_remove_favorite()
    {
        $user = User::factory()->create();
        $food = Food::factory()->create(['user_id' => $user->id]); 

        Sanctum::actingAs($user, ['*']);

        // Add favorite
        $response = $this->postJson('/api/favorites', [
            'food_id' => $food->id
        ]);
        $response->assertStatus(201)
                 ->assertJson([
                     'user_id' => $user->id,
                     'food_id' => $food->id,
                 ]);

        $favoriteId = $response->json('favorite_id'); // updated key

        // List favorites
        $response = $this->getJson('/api/favorites');
        $response->assertStatus(200)
                 ->assertJsonFragment(['food_id' => $food->id]);

        // Delete favorite
        $response = $this->deleteJson("/api/favorites/{$favoriteId}");
        $response->assertStatus(200)
                 ->assertJson(['message' => 'Favorite removed']);
    }

    public function test_user_cannot_delete_others_favorite()
    {
        $user1 = User::factory()->create();
        $user2 = User::factory()->create();
        $food = Food::factory()->create();
        $favorite = Favorite::factory()->create([
            'user_id' => $user1->id,
            'food_id' => $food->id
        ]);

        Sanctum::actingAs($user2, ['*']);

        $response = $this->deleteJson("/api/favorites/{$favorite->favorite_id}"); // updated key
        $response->assertStatus(403)
                 ->assertJson(['message' => 'Forbidden']);
    }
}
