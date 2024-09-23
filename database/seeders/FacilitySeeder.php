<?php

namespace Database\Seeders;

use Botble\Base\Supports\BaseSeeder;
use Botble\RealEstate\Models\Facility;
use Botble\RealEstate\Models\Property;

class FacilitySeeder extends BaseSeeder
{
    public function run(): void
    {
        Facility::query()->truncate();

        $facilities = [
            [
                'name' => 'Hospital',
                'icon' => 'mdi mdi-hospital',
            ],
            [
                'name' => 'Super Market',
                'icon' => 'mdi mdi-cart-plus',
            ],
            [
                'name' => 'School',
                'icon' => 'mdi mdi-school',
            ],
            [
                'name' => 'Entertainment',
                'icon' => 'mdi mdi-bed-outline',
            ],
            [
                'name' => 'Pharmacy',
                'icon' => 'mdi mdi-mortar-pestle-plus',
            ],
            [
                'name' => 'Airport',
                'icon' => 'mdi mdi-airplane-takeoff',
            ],
            [
                'name' => 'Railways',
                'icon' => 'mdi mdi-subway',
            ],
            [
                'name' => 'Bus Stop',
                'icon' => 'mdi mdi-bus',
            ],
            [
                'name' => 'Beach',
                'icon' => 'mdi mdi-beach',
            ],
            [
                'name' => 'Mall',
                'icon' => 'mdi mdi-shopping',
            ],
            [
                'name' => 'Bank',
                'icon' => 'mdi mdi-bank-check',
            ],
            [
                'name' => 'Fitness',
                'icon' => 'mdi mdi-weight-lifter',
            ],
        ];

        foreach ($facilities as $facility) {
            Facility::query()->create($facility);
        }

        foreach (Property::query()->get() as $property) {
            $property->facilities()->detach();
            for ($i = 1; $i <= 12; $i++) {
                $property->facilities()->attach($i, ['distance' => rand(1, 20) . 'km']);
            }
        }
    }
}
