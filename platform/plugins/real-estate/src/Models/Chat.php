<?php

namespace Botble\RealEstate\Models;

use Botble\Base\Models\BaseModel;
use Eloquent;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Storage;

/**
 * @property int $id
 * @property int $user_id
 * @property int $agent_id
 * @property string $message
 * @property string|null $attachment
 * @property string|null $attachment_type
 * @property Eloquent|User $user
 * @property Eloquent|User $agent
 * @method static Builder|Chat newModelQuery()
 * @method static Builder|Chat newQuery()
 * @method static Builder|Chat query()
 * @method static Collection|static[] all($columns = ['*'])
 * @method static Builder|Chat whereAgentId($value)
 * @method static Builder|Chat whereId($value)
 * @method static Builder|Chat whereMessage($value)
 * @method static Builder|Chat whereUserId($value)
 */
class Chat extends BaseModel
{
    /**
     * @var string
     */
    protected $table = 'chats';

    /**
     * @var array
     */
    protected $fillable = [
        'sender_id', 
        'receiver_id', 
        'message',
        'attachment',
        'attachment_type'
    ];

    /**
     * @var array
     */
    protected $appends = ['attachment_url'];

    /**
     * @return BelongsTo
     */
    public function sender(): BelongsTo
    {
        return $this->belongsTo(Account::class, 'sender_id');
    }

    /**
     * @return BelongsTo
     */
    public function receiver(): BelongsTo
    {
        return $this->belongsTo(Account::class, 'receiver_id');
    }

    /**
     * Get the attachment URL
     */
    public function getAttachmentUrlAttribute(): ?string
    {
        if (!$this->attachment) {
            return null;
        }

        return Storage::url($this->attachment);
    }
}
