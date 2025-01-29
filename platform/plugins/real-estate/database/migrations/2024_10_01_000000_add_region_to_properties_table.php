<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddRegionToPropertiesTable extends Migration
{
    public function up(): void
    {
        Schema::table('re_properties', function (Blueprint $table) {
            $table->string('region')->nullable(); // Add the region column
        });
    }

    public function down(): void
    {
        Schema::table('re_properties', function (Blueprint $table) {
            $table->dropColumn('region'); // Remove the region column if rolled back
        });
    }
} 