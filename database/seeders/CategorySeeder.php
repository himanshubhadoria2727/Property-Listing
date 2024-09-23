<?php

namespace Database\Seeders;

use Botble\Base\Supports\BaseSeeder;
use Botble\RealEstate\Models\Category;
use Botble\Slug\Facades\SlugHelper;

class CategorySeeder extends BaseSeeder
{
    public function run(): void
    {
        Category::query()->truncate();

        $categories = [
            'Apartment',
            'Villa',
            'Condo',
            'House',
            'Land',
            'Commercial property',
        ];

        foreach ($categories as $index => $item) {
            $category = Category::query()->create([
                'name' => $item,
                'description' => $this->fake()->realText(),
                'is_default' => $index === 0,
            ]);

            SlugHelper::createSlug($category);
        }
    }
}
