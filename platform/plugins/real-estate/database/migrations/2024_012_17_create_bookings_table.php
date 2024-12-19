<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class BookingsTable extends Migration
{
    public function up()
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->boolean('call')->default(false)->after('user_id'); // Add 'call' field
            $table->boolean('live')->default(false)->after('call');    // Add 'live' field
        });
    }

    public function down()
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->dropColumn(['call', 'live']);
        });
    }
}
