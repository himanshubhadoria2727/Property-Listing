<?php

namespace Database\Seeders;

use Botble\Base\Facades\MetaBox;
use Botble\Base\Supports\BaseSeeder;
use Botble\RealEstate\Models\Account;
use Carbon\Carbon;
use Illuminate\Support\Str;

class AccountSeeder extends BaseSeeder
{
    public function run(): void
    {
        Account::query()->truncate();

        $files = $this->uploadFiles('accounts');

        $companies = ['Google', 'Facebook', 'Twitter', 'Amazon', 'Microsoft', 'Accenture', 'Cognizant'];

        $faker = $this->fake();

        Account::query()->create([
            'first_name' => $faker->firstName(),
            'last_name' => $faker->lastName(),
            'email' => 'agent@archielite.com',
            'username' => Str::slug($faker->unique()->userName()),
            'password' => bcrypt('12345678'),
            'dob' => $faker->dateTime(),
            'phone' => $faker->e164PhoneNumber(),
            'description' => $faker->realText(),
            'credits' => 10,
            'confirmed_at' => Carbon::now(),
            'avatar_id' => $files[$faker->numberBetween(0, 9)]['data']->id,
            'company' => $faker->randomElement($companies),
        ]);

        foreach (range(1, 20) as $ignored) {
            $account = Account::query()->create([
                'first_name' => $faker->firstName(),
                'last_name' => $faker->lastName(),
                'email' => $faker->email(),
                'username' => Str::slug($faker->unique()->userName()),
                'password' => bcrypt($faker->password()),
                'dob' => $faker->dateTime(),
                'phone' => $faker->e164PhoneNumber(),
                'description' => $faker->realText(),
                'credits' => $faker->numberBetween(1, 10),
                'confirmed_at' => Carbon::now(),
                'avatar_id' => $files[$faker->numberBetween(0, 9)]['data']->id,
                'company' => $faker->randomElement($companies),
                'is_featured' => rand(0, 1),
            ]);

            MetaBox::saveMetaBoxData($account, 'social_facebook', 'facebook.com');
            MetaBox::saveMetaBoxData($account, 'social_instagram', 'instagram.com');
            MetaBox::saveMetaBoxData($account, 'social_linkedin', 'linkedin.com');
        }
    }
}
