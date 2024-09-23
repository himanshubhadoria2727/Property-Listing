<?php

namespace Database\Seeders;

use Botble\ACL\Database\Seeders\UserSeeder;
use Botble\Base\Supports\BaseSeeder;
use Botble\Language\Database\Seeders\LanguageSeeder;

class DatabaseSeeder extends BaseSeeder
{
    public function run(): void
    {
        $this->prepareRun();

        $this->call([
            LanguageSeeder::class,
            CurrencySeeder::class,
            CategorySeeder::class,
            UserSeeder::class,
            SettingSeeder::class,
            PageSeeder::class,
            LocationSeeder::class,
            BlogSeeder::class,
            TestimonialSeeder::class,
            WidgetSeeder::class,
            FaqSeeder::class,
            AccountSeeder::class,
            PackageSeeder::class,
            FacilitySeeder::class,
            InvestorSeeder::class,
            FeatureSeeder::class,
            ProjectSeeder::class,
            PropertySeeder::class,
            ReviewSeeder::class,
            ThemeOptionSeeder::class,
            MenuSeeder::class,
        ]);

        $this->uploadFiles('backgrounds');
        $this->uploadFiles('clients');
        $this->uploadFiles('general');
        $this->uploadFiles('properties');
        $this->uploadFiles('news');

        $this->finished();
    }
}
