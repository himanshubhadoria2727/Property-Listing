<?php

namespace Botble\RealEstate\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class Expo extends Model
{
    use HasFactory;

    protected $fillable = ['expo_date', 'enabled'];
}
