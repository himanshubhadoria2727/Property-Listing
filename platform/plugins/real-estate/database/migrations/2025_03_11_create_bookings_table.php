<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('re_properties', function (Blueprint $table) {
            $table->boolean('has_1_bhk')->default(false);
            $table->boolean('has_2_bhk')->default(false);
            $table->boolean('has_2_5_bhk')->default(false);
            $table->boolean('has_3_bhk')->default(false);
            $table->boolean('has_3_5_bhk')->default(false);
            $table->boolean('has_4_bhk')->default(false);
            $table->boolean('has_4_5_bhk')->default(false);
            $table->boolean('has_5_bhk')->default(false);
            $table->decimal('max_square', 15, 2)->nullable();
            $table->decimal('max_price', 15, 2)->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('re_properties', function (Blueprint $table) {
            $table->dropColumn([
                'has_1_bhk', 'has_2_bhk', 'has_2_5_bhk', 'has_3_bhk', 
                'has_3_5_bhk', 'has_4_bhk', 'has_4_5_bhk', 'has_5_bhk',
                'bhk_1_price', 'bhk_2_price', 'bhk_2_5_price', 'bhk_3_price',
                'bhk_3_5_price', 'bhk_4_price', 'bhk_4_5_price', 'bhk_5_price',
                'bhk_1_square', 'bhk_2_square', 'bhk_2_5_square', 'bhk_3_square',
                'bhk_3_5_square', 'bhk_4_square', 'bhk_4_5_square', 'bhk_5_square',
                'max_square', 'max_price'
            ]);
        });
    }
}; 