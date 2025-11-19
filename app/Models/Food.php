<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Food extends Model
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory;

    protected $table = 'foods';
    protected $fillable = ['user_id', 'food_name', 'calories'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }
}
