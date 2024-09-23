<?php

namespace Botble\RealEstate\Enums;

use Botble\Base\Supports\Enum;
use Illuminate\Support\Facades\Blade;
use Illuminate\Support\HtmlString;

/**
 * @method static \Botble\RealEstate\Enums\CouponTypeEnum PERCENTAGE()
 * @method static \Botble\RealEstate\Enums\CouponTypeEnum FIXED()
 */
class CouponTypeEnum extends Enum
{
    public const PERCENTAGE = 'percentage';

    public const FIXED = 'fixed';

    public static $langPath = 'plugins/real-estate::coupon.types';

    public function toHtml(): HtmlString|string
    {
        $color = match ($this->value) {
            self::PERCENTAGE => 'info',
            self::FIXED => 'success',
            default => null,
        };

        return Blade::render(sprintf('<x-core::badge color="%s" label="%s" />', $color, $this->label()));
    }
}
