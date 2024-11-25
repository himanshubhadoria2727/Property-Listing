<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class () extends Migration
{
    public function up(): void
    {
        Schema::table('re_accounts', function (Blueprint $table) {
            $table->enum('role', [1, 2])->default(1);
        });
    }
};