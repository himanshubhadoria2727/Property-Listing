<?php

namespace Botble\RealEstate\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CallLog extends Model
{
    use HasFactory;

    // Disable automatic timestamps
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'call_type',
        'agent_id',
        'channel'
    ];
} 