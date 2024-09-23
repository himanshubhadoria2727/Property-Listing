<?php

namespace Database\Seeders;

use Botble\Base\Supports\BaseSeeder;
use Botble\Testimonial\Models\Testimonial;

class TestimonialSeeder extends BaseSeeder
{
    public function run(): void
    {
        $testimonials = [
            [
                'name' => 'Christa Smith',
                'company' => 'Manager',
            ],
            [
                'name' => 'John Smith',
                'company' => 'Product designer',
            ],
            [
                'name' => 'Sayen Ahmod',
                'company' => 'Developer',
            ],
            [
                'name' => 'Tayla Swef',
                'company' => 'Graphic designer',
            ],
            [
                'name' => 'Christa Smith',
                'company' => 'Graphic designer',
            ],
            [
                'name' => 'James Garden',
                'company' => 'Web Developer',
            ],
        ];

        Testimonial::query()->truncate();

        foreach ($testimonials as $key => $item) {
            Testimonial::query()->create(
                array_merge($item, [
                    'image' => 'clients/0' . ($key + 1) . '.jpg',
                    'content' => $this->fake()->realText(),
                ])
            );
        }
    }
}
