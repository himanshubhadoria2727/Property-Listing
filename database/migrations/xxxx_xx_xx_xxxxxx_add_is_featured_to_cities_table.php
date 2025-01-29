<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddIsFeaturedToCitiesTable extends Migration
{
    public function up()
    {
        Schema::table('cities', function (Blueprint $table) {
            $table->boolean('is_featured')->default(false);
        });
    }

    public function down()
    {
        Schema::table('cities', function (Blueprint $table) {
            $table->dropColumn('is_featured');
        });
    }
} 