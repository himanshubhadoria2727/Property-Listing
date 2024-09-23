<?php

namespace Database\Seeders;

use Botble\Base\Models\BaseModel;
use Botble\Base\Supports\BaseSeeder;
use Botble\Page\Models\Page;
use Botble\Setting\Models\Setting;
use Botble\Theme\Facades\Theme;
use Carbon\Carbon;

class ThemeOptionSeeder extends BaseSeeder
{
    public function run(): void
    {
        $theme = Theme::getThemeName();

        Setting::query()->where('key', 'LIKE', 'theme-' . $theme . '-%')->delete();
        Setting::query()->whereIn('key', ['admin_logo', 'admin_favicon'])->delete();

        $settings = [
            'admin_logo' => 'general/logo-light.png',
            'admin_favicon' => 'general/favicon.png',
            'theme' => $theme,
            'cookie_consent_message' => 'Your experience on this site will be improved by allowing cookies',
            'cookie_consent_learn_more_url' => url('cookie-policy'),
            'cookie_consent_learn_more_text' => 'Cookie Policy',
            'real_estate_enable_review_feature' => true,
            'real_estate_reviews_per_page' => 10,
        ];

        foreach ($settings as $key => $value) {
            $data = [
                'key' => $key,
                'value' => $value,
            ];

            if (BaseModel::determineIfUsingUuidsForId()) {
                $data['id'] = BaseModel::newUniqueId();
            }

            Setting::query()->insertOrIgnore($data);
        }

        $data = [
            'site_title' => 'Hously',
            'seo_title' => 'Find your favorite homes at Hously',
            'site_description' => 'A great platform to buy, sell and rent your properties without any agent or commissions.',
            'seo_description' => 'A great platform to buy, sell and rent your properties without any agent or commissions.',
            'copyright' => sprintf('© %s Archi Elite JSC. All right reserved.', Carbon::now()->format('Y')),
            'favicon' => 'general/favicon.png',
            'logo' => 'general/logo-light.png',
            'logo_dark' => 'general/logo-dark.png',
            '404_page_image' => 'general/error.png',
            'primary_font' => 'League Spartan',
            'primary_color' => '#16a34a',
            'secondary_color' => '#15803D',
            'homepage_id' => Page::query()->value('id'),
            'authentication_enable_snowfall_effect' => true,
            'authentication_background_image' => 'backgrounds/01.jpg',
            'categories_background_image' => 'backgrounds/01.jpg',
            'logo_authentication_page' => 'general/logo-authentication-page.png',
            'default_page_cover_image' => 'backgrounds/01.jpg',
            'projects_list_page_id' => 5,
            'properties_list_page_id' => 6,
            'blog_page_id' => 14,
            'projects_list_layout' => 'grid',
            'properties_list_layout' => 'grid',
            'number_of_related_properties' => 6,
            'social_links' => json_encode([
                [
                    [
                        'key' => 'social-name',
                        'value' => 'Facebook',
                    ],
                    [
                        'key' => 'social-icon',
                        'value' => 'mdi mdi-facebook',
                    ],
                    [
                        'key' => 'social-url',
                        'value' => '#',
                    ],
                ],
                [
                    [
                        'key' => 'social-name',
                        'value' => 'Instagram',
                    ],
                    [
                        'key' => 'social-icon',
                        'value' => 'mdi mdi-instagram',
                    ],
                    [
                        'key' => 'social-url',
                        'value' => '#',
                    ],
                ],
                [
                    [
                        'key' => 'social-name',
                        'value' => 'Twitter',
                    ],
                    [
                        'key' => 'social-icon',
                        'value' => 'mdi mdi-twitter',
                    ],
                    [
                        'key' => 'social-url',
                        'value' => '#',
                    ],
                ],
                [
                    [
                        'key' => 'social-name',
                        'value' => 'LinkedIn',
                    ],
                    [
                        'key' => 'social-icon',
                        'value' => 'mdi mdi-linkedin',
                    ],
                    [
                        'key' => 'social-url',
                        'value' => '#',
                    ],
                ],
            ]),
            'enabled_toggle_theme_mode' => true,
            'default_theme_mode' => 'system',
            'show_whatsapp_button_on_consult_form' => '1',
        ];

        foreach ($data as $key => $value) {
            $settingItem = [
                'key' => 'theme-' . $theme . '-' . $key,
                'value' => $value,
            ];

            if (BaseModel::determineIfUsingUuidsForId()) {
                $settingItem['id'] = BaseModel::newUniqueId();
            }

            Setting::query()->insertOrIgnore($settingItem);
        }
    }
}
