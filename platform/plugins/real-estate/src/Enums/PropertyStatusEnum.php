<?php

namespace Botble\RealEstate\Enums;

use Botble\Base\Facades\Html;
use Botble\Base\Supports\Enum;
use Illuminate\Support\Facades\Blade;
use Illuminate\Support\HtmlString;

/**
 * @method static PropertyStatusEnum NOT_AVAILABLE()
 * @method static PropertyStatusEnum PRE_SALE()
 * @method static PropertyStatusEnum SELLING()
 * @method static PropertyStatusEnum SOLD()
 * @method static PropertyStatusEnum RENTING()
 * @method static PropertyStatusEnum RENTED()
 * @method static PropertyStatusEnum BUILDING()
 * @method static PropertyStatusEnum READY_POSSESSION()
 * @method static PropertyStatusEnum UNDER_CONSTRUCTION()
 * @method static PropertyStatusEnum READY_TO_MOVE()
 */
class PropertyStatusEnum extends Enum
{
    public const NOT_AVAILABLE = 'not_available';

    public const PRE_SALE = 'pre_sale';

    public const SELLING = 'selling';

    public const SOLD = 'sold';

    public const RENTING = 'renting';

    public const RENTED = 'rented';

    public const BUILDING = 'building';

    public const READY_POSSESSION = 'ready_possession';

    public const UNDER_CONSTRUCTION = 'under_construction';

    public const READY_TO_MOVE = 'ready_to_move';

    public static $langPath = 'plugins/real-estate::property.statuses';

    public function toHtml(): HtmlString|string|null
    {
        if (! is_in_admin()) {
            return match ($this->value) {
                self::NOT_AVAILABLE => Html::tag(
                    'span',
                    self::NOT_AVAILABLE()->label(),
                    ['class' => 'label-default status-label']
                )
                    ->toHtml(),
                self::PRE_SALE => Html::tag('span', self::PRE_SALE()->label(), ['class' => 'label-success status-label'])
                    ->toHtml(),
                self::SELLING => Html::tag('span', self::SELLING()->label(), ['class' => 'label-success status-label'])
                    ->toHtml(),
                self::SOLD => Html::tag('span', self::SOLD()->label(), ['class' => 'label-danger status-label'])
                    ->toHtml(),
                self::RENTING => Html::tag('span', self::RENTING()->label(), ['class' => 'label-success status-label'])
                    ->toHtml(),
                self::RENTED => Html::tag('span', self::RENTED()->label(), ['class' => 'label-danger status-label'])
                    ->toHtml(),
                self::BUILDING => Html::tag('span', self::BUILDING()->label(), ['class' => 'label-info status-label'])
                    ->toHtml(),
                self::READY_POSSESSION => Html::tag(
                    'span',
                    self::READY_POSSESSION()->label(),
                    ['class' => 'label-success status-label']
                )->toHtml(),
                self::UNDER_CONSTRUCTION => Html::tag(
                    'span',
                    self::UNDER_CONSTRUCTION()->label(),
                    ['class' => 'label-warning status-label']
                )->toHtml(),
                self::READY_TO_MOVE => Html::tag(
                    'span',
                    self::READY_TO_MOVE()->label(),
                    ['class' => 'label-info status-label']
                )->toHtml(),
                default => null,
            };
        }

        $color = match ($this->value) {
            self::NOT_AVAILABLE => 'secondary',
            self::PRE_SALE, self::SELLING, self::RENTING => 'success',
            self::SOLD, self::RENTED => 'danger',
            self::BUILDING => 'info',
            self::READY_POSSESSION => 'success',
            self::UNDER_CONSTRUCTION => 'warning',
            self::READY_TO_MOVE => 'info',
            default => null,
        };

        return Blade::render(sprintf('<x-core::badge color="%s" label="%s" />', $color, $this->label()));
    }
}
