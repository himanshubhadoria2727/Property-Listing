<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCallLogsTable extends Migration
{
    public function up()
    {
        Schema::create('call_logs', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id'); // ID of the user involved in the call
            $table->string('call_type'); // 'missed', 'connected', 'rejected'
            $table->string('channel'); // Channel name
            $table->timestamp('created_at')->useCurrent(); // Timestamp of the log
        });
    }

    public function down()
    {
        Schema::dropIfExists('call_logs');
    }
}