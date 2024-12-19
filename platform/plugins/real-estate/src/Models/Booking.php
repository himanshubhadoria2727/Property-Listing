<?php

namespace Botble\RealEstate\Models;

use Botble\Base\Models\BaseModel;
use Botble\RealEstate\Models\Property;
use Botble\RealEstate\Models\Account;


class Booking extends BaseModel
{
    protected $table = 'bookings'; // Your table name

    protected $fillable = [
        'property_id',
        'user_id',
        'scheduled_at',
        'call',   
        'live',
    ];

    public function property()
    {
        return $this->belongsTo(Property::class, 'property_id', 'id');
    }

    public function user()
    {
        return $this->belongsTo(Account::class, 'user_id', 'id'); // Assuming 'user_id' is the foreign key in bookings table
    }
}
