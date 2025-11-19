<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\FoodController;
use App\Http\Controllers\FavoriteController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::prefix('foods')->group(function () {
        Route::get('/', [FoodController::class, 'index']);
        Route::post('/', [FoodController::class, 'store']);
        Route::get('{food}', [FoodController::class, 'show']);
        Route::put('{food}', [FoodController::class, 'update']);
        Route::delete('{food}', [FoodController::class, 'destroy']);
    });

    Route::prefix('favorites')->group(function () {
        Route::get('/', [FavoriteController::class, 'index']);
        Route::post('/', [FavoriteController::class, 'store']);
        Route::delete('{favorite}', [FavoriteController::class, 'destroy']);
    });
});
