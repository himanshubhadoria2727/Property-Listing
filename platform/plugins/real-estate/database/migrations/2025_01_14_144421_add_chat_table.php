<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddChatTable extends Migration
{
    public function up()
    {
        Schema::create('chats', function (Blueprint $table) {
            $table->id(); // Automatically creates an auto-incrementing ID as primary key
            $table->unsignedBigInteger('sender_id'); // Sender's ID
            $table->unsignedBigInteger('receiver_id'); // Receiver's ID
            $table->text('message'); // The chat message
            $table->timestamps(0); // Creates `created_at` and `updated_at` columns, if needed
        });
    }

    public function down()
    {
        Schema::dropIfExists('chats');
    }
}
