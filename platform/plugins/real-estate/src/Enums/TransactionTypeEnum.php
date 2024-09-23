<?php

namespace Botble\RealEstate\Enums;

use Botble\Base\Supports\Enum;
use Illuminate\Support\Facades\Blade;
use Illuminate\Support\HtmlString;

/**
 * @method static TransactionTypeEnum REMOVE()
 * @method static TransactionTypeEnum ADD()
 */
class TransactionTypeEnum extends Enum
{
    public const ADD = 'add';

    public const REMOVE = 'remove';

    public static $langPath = 'plugins/real-estate::transaction.types';

    public function toHtml(): HtmlString|string|null
    {
        $color = match ($this->value) {
            self::REMOVE => 'warning',
            self::ADD => 'success',
            default => null,
        };

        return Blade::render(sprintf('<x-core::badge color="%s" label="%s" />', $color, $this->label()));
    }
}
