<?php

namespace Botble\RealEstate\Models;

use Botble\Base\Casts\SafeContent;
use Botble\Base\Models\BaseModel;
use Botble\Media\Facades\RvMedia;
use Botble\RealEstate\Enums\ModerationStatusEnum;
use Botble\RealEstate\Enums\PropertyPeriodEnum;
use Botble\RealEstate\Enums\PropertyStatusEnum;
use Botble\RealEstate\Enums\PropertyTypeEnum;
use Botble\RealEstate\QueryBuilders\PropertyBuilder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Support\Arr;
use Illuminate\Support\Str;

/**
 * @method static \Botble\RealEstate\QueryBuilders\PropertyBuilder<static> query()
 */
class Property extends BaseModel
{
    protected $table = 're_properties';

    protected $fillable = [
        'name',
        'type',
        'description',
        'content',
        'location',
        'images',
        'project_id',
        'number_bedroom',
        'number_bathroom',
        'number_floor',
        'square',
        'price',
        'status',
        'is_featured',
        'currency_id',
        'city_id',
        'state_id',
        'country_id',
        'period',
        'author_id',
        'author_type',
        'expire_date',
        'auto_renew',
        'latitude',
        'longitude',
        'unique_id',
        'region',
        'has_1_bhk',
        'has_2_bhk',
        'has_2_5_bhk',
        'has_3_bhk',
        'has_3_5_bhk',
        'has_4_bhk',
        'has_4_5_bhk',
        'has_5_bhk',
        'max_square',
        'max_price',
    ];

    protected $casts = [
        'status' => PropertyStatusEnum::class,
        'moderation_status' => ModerationStatusEnum::class,
        'type' => PropertyTypeEnum::class,
        'period' => PropertyPeriodEnum::class,
        'name' => SafeContent::class,
        'description' => SafeContent::class,
        'content' => SafeContent::class,
        'location' => SafeContent::class,
        'expire_date' => 'datetime',
        'images' => 'json',
        'price' => 'float',
        'max_price' => 'float',
        'square' => 'float',
        'max_square' => 'float',
        'number_bedroom' => 'int',
        'number_bathroom' => 'int',
        'number_floor' => 'int',
        'has_1_bhk' => 'boolean',
        'has_2_bhk' => 'boolean',
        'has_2_5_bhk' => 'boolean',
        'has_3_bhk' => 'boolean',
        'has_3_5_bhk' => 'boolean',
        'has_4_bhk' => 'boolean',
        'has_4_5_bhk' => 'boolean',
        'has_5_bhk' => 'boolean',
    ];

    protected static function booted(): void
    {
        static::deleting(function (Property $property) {
            $property->categories()->detach();
            $property->customFields()->delete();
            $property->reviews()->delete();
            $property->features()->detach();
            $property->facilities()->detach();
            $property->metadata()->delete();
        });
    }

    // Botble\RealEstate\Models\Property.php
    public function bookings()
    {
        return $this->hasMany(Booking::class, 'property_id');
    }



    public function project(): BelongsTo
    {
        return $this->belongsTo(Project::class, 'project_id')->withDefault();
    }

    public function features(): BelongsToMany
    {
        return $this->belongsToMany(Feature::class, 're_property_features', 'property_id', 'feature_id');
    }

    public function facilities(): BelongsToMany
    {
        return $this->morphToMany(Facility::class, 'reference', 're_facilities_distances')->withPivot('distance');
    }

    protected function image(): Attribute
    {
        return Attribute::make(
            get: function () {
                return Arr::first($this->images) ?? null;
            },
        );
    }

    protected function squareText(): Attribute
    {
        return Attribute::make(
            get: function () {
                $square = $this->square;

                $unit = setting('real_estate_square_unit', 'm²');

                return apply_filters('real_estate_property_square_text', sprintf('%s %s', number_format($square), __($unit)), $square);
            },
        );
    }

    protected function address(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->location;
            },
        );
    }

    protected function category(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->categories->first() ?: new Category();
            },
        );
    }

    public function currency(): BelongsTo
    {
        return $this->belongsTo(Currency::class);
    }

    public function author(): MorphTo
    {
        return $this->morphTo()->withDefault();
    }

    public function categories(): BelongsToMany
    {
        return $this->belongsToMany(Category::class, 're_property_categories');
    }

    protected function cityName(): Attribute
    {
        return Attribute::make(
            get: function () {
                return ($this->city->name ? $this->city->name . ', ' : null) . $this->state->name;
            },
        );
    }

    protected function typeHtml(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->type->label();
            },
        );
    }

    protected function statusHtml(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->status->toHtml();
            },
        );
    }

    protected function categoryName(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->category->name;
            },
        );
    }

    protected function imageThumb(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->image ? RvMedia::getImageUrl($this->image, 'thumb', false, RvMedia::getDefaultImage()) : null;
            },
        );
    }

    protected function imageSmall(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->image ? RvMedia::getImageUrl($this->image, 'small', false, RvMedia::getDefaultImage()) : null;
            },
        );
    }

    protected function priceHtml(): Attribute
    {
        return Attribute::make(
            get: function () {
                if (! $this->price) {
                    return __('Contact');
                }

                $price = $this->price_format;

                if ($this->type == PropertyTypeEnum::RENT) {
                    $price .= ' / ' . Str::lower($this->period->label());
                }

                return $price;
            },
        );
    }

    protected function priceFormat(): Attribute
    {
        return Attribute::make(
            get: function () {
                if (! $this->price) {
                    return __('Contact');
                }

                if ($this->price_formatted) {
                    return $this->price_formatted;
                }

                $currency = $this->currency;

                if (! $currency || ! $currency->getKey()) {
                    $currency = get_application_currency();
                }

                return $this->price_formatted = format_price($this->price, $currency);
            },
        );
    }

    protected function mapIcon(): Attribute
    {
        return Attribute::make(
            get: function () {
                return $this->type_html . ': ' . $this->price_format;
            },
        );
    }

    public function customFields(): MorphMany
    {
        return $this->morphMany(CustomFieldValue::class, 'reference', 'reference_type', 'reference_id')->with('customField.options');
    }

    protected function customFieldsArray(): Attribute
    {
        return Attribute::make(
            get: function () {
                return CustomFieldValue::getCustomFieldValuesArray($this);
            },
        );
    }

    public function reviews(): MorphMany
    {
        return $this->morphMany(Review::class, 'reviewable');
    }

    public function newEloquentBuilder($query): PropertyBuilder
    {
        return new PropertyBuilder($query);
    }
}
