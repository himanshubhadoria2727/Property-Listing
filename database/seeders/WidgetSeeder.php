<?php

namespace Database\Seeders;

use Botble\Base\Supports\BaseSeeder;
use Botble\Theme\Facades\Theme;
use Botble\Widget\Models\Widget;

class WidgetSeeder extends BaseSeeder
{
    public function run(): void
    {
        Widget::query()->truncate();

        $data = [
            [
                'widget_id' => 'NewsletterWidget',
                'sidebar_id' => 'pre_footer',
                'position' => 0,
                'data' => [
                    'name' => __('Subscribe to Newsletter.'),
                    'description' => __('Subscribe to get latest updates and information.'),
                    'title' => null,
                    'subtitle' => null,
                ],
            ],
            [
                'widget_id' => 'SiteInformationWidget',
                'sidebar_id' => 'footer_menu',
                'position' => 1,
                'data' => [
                    'name' => __('Site Information'),
                    'logo' => 'general/logo-light.png',
                    'url' => '#',
                    'description' => 'A great platform to buy, sell and rent your properties without any agent or commissions.',
                ],
            ],
            [
                'widget_id' => 'CustomMenuWidget',
                'sidebar_id' => 'footer_menu',
                'position' => 2,
                'data' => [
                    'id' => 'CustomMenuWidget',
                    'name' => 'Company',
                    'menu_id' => 'company',
                ],
            ],
            [
                'widget_id' => 'CustomMenuWidget',
                'sidebar_id' => 'footer_menu',
                'position' => 3,
                'data' => [
                    'id' => 'CustomMenuWidget',
                    'name' => 'Useful Links',
                    'menu_id' => 'useful-links',
                ],
            ],
            [
                'widget_id' => 'ContactInformationWidget',
                'sidebar_id' => 'footer_menu',
                'position' => 4,
                'data' => [
                    'name' => __('Contact Details'),
                    'address' => 'C/54 Northwest Freeway, Suite 558, Houston, USA 485',
                    'email' => 'contact@example.com',
                    'phone' => '+152 534-468-854',
                ],
            ],
            [
                'widget_id' => 'BlogSearchWidget',
                'sidebar_id' => 'blog_sidebar',
                'position' => 1,
                'data' => [
                    'name' => 'Blog Search',
                ],
            ],
            [
                'widget_id' => 'BlogPopularCategoriesWidget',
                'sidebar_id' => 'blog_sidebar',
                'position' => 2,
                'data' => [
                    'name' => 'Popular Categories',
                    'limit' => 5,
                ],
            ],
            [
                'widget_id' => 'BlogPostsWidget',
                'sidebar_id' => 'blog_sidebar',
                'position' => 3,
                'data' => [
                    'name' => 'Popular Posts',
                    'type' => 'popular',
                    'limit' => 5,
                ],
            ],
            [
                'widget_id' => 'BlogPopularTagsWidget',
                'sidebar_id' => 'blog_sidebar',
                'position' => 4,
                'data' => [
                    'name' => 'Popular Tags',
                    'limit' => 6,
                ],
            ],
        ];

        $theme = Theme::getThemeName();

        foreach ($data as $item) {
            Widget::query()->create(
                array_merge($item, [
                    'theme' => $theme,
                ])
            );
        }
    }
}
