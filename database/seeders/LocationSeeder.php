<?php

namespace Database\Seeders;

use Botble\Base\Supports\BaseSeeder;
use Botble\Location\Models\City;
use Botble\Location\Models\Country;
use Botble\Location\Models\State;
use Illuminate\Support\Str;

class LocationSeeder extends BaseSeeder
{
    public function run(): void
    {
        Country::query()->truncate();
        State::query()->truncate();
        City::query()->truncate();

        $this->uploadFiles('cities');

        $countries = [
            [
                'name' => 'France',
                'nationality' => 'French',
                'code' => 'FRA',
            ],
            [
                'name' => 'England',
                'nationality' => 'English',
                'code' => 'UK',
            ],
            [
                'name' => 'USA',
                'nationality' => 'Americans',
                'code' => 'US',
            ],
            [
                'name' => 'Holland',
                'nationality' => 'Dutch',
                'code' => 'HL',
            ],
            [
                'name' => 'Denmark',
                'nationality' => 'Danish',
                'code' => 'DN',
            ],
            [
                'name' => 'Germany',
                'nationality' => 'Danish',
                'code' => 'DN',
            ],
        ];

        $states = [
            [
                'name' => 'France',
                'abbreviation' => 'FR',
                'country_id' => 1,
            ],
            [
                'name' => 'England',
                'abbreviation' => 'EN',
                'country_id' => 2,
            ],
            [
                'name' => 'New York',
                'abbreviation' => 'NY',
                'country_id' => 1,
            ],
            [
                'name' => 'Holland',
                'abbreviation' => 'HL',
                'country_id' => 4,
            ],
            [
                'name' => 'Denmark',
                'abbreviation' => 'DN',
                'country_id' => 5,
            ],
            [
                'name' => 'Germany',
                'abbreviation' => 'GER',
                'country_id' => 1,
            ],
        ];

        $cities = [
            [
                'name' => 'Paris',
                'state_id' => 1,
                'country_id' => 1,
                'image' => 'cities/location-1.jpg',
            ],
            [
                'name' => 'London',
                'state_id' => 2,
                'country_id' => 2,
                'image' => 'cities/location-2.jpg',
            ],
            [
                'name' => 'New York',
                'state_id' => 3,
                'country_id' => 3,
                'image' => 'cities/location-3.jpg',
            ],
            [
                'name' => 'Copenhagen',
                'state_id' => 4,
                'country_id' => 4,
                'image' => 'cities/location-4.jpg',
            ],
            [
                'name' => 'Berlin',
                'state_id' => 5,
                'country_id' => 5,
                'image' => 'cities/location-5.jpg',
            ],
        ];

        foreach ($countries as $country) {
            Country::query()->create($country);
        }

        foreach ($states as $state) {
            State::query()->create($state);
        }

        foreach ($cities as $city) {
            $city['slug'] = Str::slug($city['name']);

            City::query()->forceCreate($city);
        }
    }
}
