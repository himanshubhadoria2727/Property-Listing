<?php

use Botble\Base\Enums\BaseStatusEnum;
use Botble\Base\Facades\Html;
use Botble\Base\Supports\RepositoryHelper;
use Botble\Faq\Contracts\Faq as FaqContract;
use Botble\Faq\FaqCollection;
use Botble\Faq\FaqItem;
use Botble\Faq\Repositories\Interfaces\FaqCategoryInterface;
use Botble\Faq\Repositories\Interfaces\FaqInterface;
use Botble\Location\Models\City;
use Botble\Location\Models\State;
use Botble\Media\Facades\RvMedia;
use Botble\RealEstate\Enums\PropertyTypeEnum;
use Botble\RealEstate\Facades\RealEstateHelper;
use Botble\RealEstate\Repositories\Interfaces\AccountInterface;
use Botble\RealEstate\Repositories\Interfaces\PackageInterface;
use Botble\RealEstate\Repositories\Interfaces\ProjectInterface;
use Botble\RealEstate\Repositories\Interfaces\PropertyInterface;
use Botble\SeoHelper\Facades\SeoHelper;
use Botble\Shortcode\Compilers\Shortcode;
use Botble\Testimonial\Repositories\Interfaces\TestimonialInterface;
use Botble\Theme\Facades\Theme;
use Botble\Theme\Supports\ThemeSupport;
use Botble\Theme\Supports\Youtube;

app()->booted(function () {
    ThemeSupport::registerGoogleMapsShortcode();
    ThemeSupport::registerYoutubeShortcode();

    if (is_plugin_active('real-estate')) {
        add_shortcode('hero-banner', __('Hero Banner'), __('Hero Banner'), function (Shortcode $shortcode) {
            Theme::asset()->container('footer')->usePath()->add('easy_background', 'plugins/easy_background.js');

            if ($shortcode->style === '4') {
                $shortcode->youtube_video_id = $shortcode->youtube_video_url ? Youtube::getYoutubeVideoID($shortcode->youtube_video_url) : null;
            }

            $categories = get_property_categories([
                'indent' => '↳',
                'conditions' => ['status' => BaseStatusEnum::PUBLISHED],
            ]);

            $images = [];
            $styles = ['default' => __('Default')];

            foreach (array_filter(explode(',', $shortcode->background_images)) as $image) {
                $images[] = RvMedia::getImageUrl($image);
            }
            foreach (range(1, 4) as $i) {
                $styles[$i] = __('Style :number', ['number' => $i]);
            }

            $searchTabs = [
                'projects' => __('Projects'),
                'sale' => __('Sale'),
                'rent' => __('Rent'),
            ];

            $shortcode->style = (int)$shortcode->style;
            $shortcode->search_tabs = array_filter(explode(',', $shortcode->search_tabs), function ($tab) use ($searchTabs) {
                return in_array($tab, array_keys($searchTabs));
            });
            $shortcode->enabled_search_box = (bool)($shortcode->enabled_search_box ?? true);

            return Theme::partial(
                'shortcodes.hero-banner.index',
                compact('shortcode', 'images', 'styles', 'categories', 'searchTabs')
            );
        });

        shortcode()->setAdminConfig('hero-banner', function (array $attributes) {
            $styles = [];

            foreach (range(1, 4) as $i) {
                $styles[$i] = __('Style :number', ['number' => $i]);
            }

            $searchTabs = [
                'projects' => __('Projects'),
                'sale' => __('Sale'),
                'rent' => __('Rent'),
            ];

            return Html::style('vendor/core/core/base/libraries/tagify/tagify.css') .
                Html::script('vendor/core/core/base/libraries/tagify/tagify.js') .
                Html::script('vendor/core/core/base/js/tags.js') .
                Theme::partial('shortcodes.hero-banner.admin', compact('attributes', 'styles', 'searchTabs'));
        });

        add_shortcode('featured-properties', __('Featured Properties'), __('Featured Properties'), function (Shortcode $shortcode) {
            Theme::asset()->container('footer')->usePath()->add('wishlist', 'js/wishlist.js');

            $conditions = [
                're_properties.is_featured' => true,
            ];

            if ($shortcode->type) {
                $conditions['re_properties.type'] = $shortcode->type;
            }

            $properties = app(PropertyInterface::class)->advancedGet([
                'condition' => $conditions + RealEstateHelper::getPropertyDisplayQueryConditions(),
                'take' => (int)$shortcode->limit ?: 6,
                'order_by' => ['created_at' => 'DESC'],
                'with' => RealEstateHelper::getPropertyRelationsQuery(),
                'withCount' => 'reviews',
                'withAvg' => ['reviews', 'star'],
            ]);

            return Theme::partial('shortcodes.featured-properties.index', compact('shortcode', 'properties'));
        });

        shortcode()->setAdminConfig('featured-properties', function (array $attributes) {
            $types = PropertyTypeEnum::labels() + ['' => __('All')];

            return Theme::partial('shortcodes.featured-properties.admin', compact('attributes', 'types'));
        });

        add_shortcode('featured-projects', __('Featured Projects'), __('Featured Projects'), function (Shortcode $shortcode) {
            Theme::asset()->container('footer')->usePath()->add('wishlist', 'js/wishlist.js');

            $projects = app(ProjectInterface::class)->advancedGet([
                'condition' => array_merge(['re_projects.is_featured' => true], RealEstateHelper::getProjectDisplayQueryConditions()),
                'take' => (int)$shortcode->limit ?: 6,
                'order_by' => ['created_at' => 'DESC'],
                'with' => RealEstateHelper::getProjectRelationsQuery(),
                'withCount' => 'reviews',
                'withAvg' => ['reviews', 'star'],
            ]);

            return Theme::partial('shortcodes.featured-projects.index', compact('shortcode', 'projects'));
        });

        shortcode()->setAdminConfig('featured-projects', function (array $attributes) {
            return Theme::partial('shortcodes.featured-projects.admin', compact('attributes'));
        });

        add_shortcode('properties-list', __('Properties List'), __('Properties List'), function (Shortcode $shortcode) {
            Theme::asset()->container('footer')->usePath()->add('filter', 'js/filter.js');
            Theme::asset()->container('footer')->usePath()->add('wishlist', 'js/wishlist.js');

            $properties = RealEstateHelper::getPropertiesFilter((int)$shortcode->per_page ?: 12, RealEstateHelper::getReviewExtraData());

            $showMap = false;

            if (request()->input('layout') == 'map') {
                $showMap = true;
            }

            $keyword = request()->input('k');

            if (! empty($keyword)) {
                SeoHelper::setTitle(__('Search results for ":keyword"', ['keyword' => $keyword]));
            }

            return Theme::partial('shortcodes.properties-list.index', compact('shortcode', 'properties', 'showMap'));
        });

        shortcode()->setAdminConfig('properties-list', function (array $attributes) {
            return Theme::partial('shortcodes.properties-list.admin', compact('attributes'));
        });

        add_shortcode('projects-list', __('Projects List'), __('Projects List'), function (Shortcode $shortcode) {
            Theme::asset()->container('footer')->usePath()->add('filter', 'js/filter.js');
            Theme::asset()->container('footer')->usePath()->add('wishlist', 'js/wishlist.js');

            $projects = RealEstateHelper::getProjectsFilter((int)$shortcode->per_page ?: 12, RealEstateHelper::getReviewExtraData());

            $showMap = false;

            if (request()->input('layout') == 'map') {
                $showMap = true;
            }

            $keyword = request()->input('k');

            if (! empty($keyword)) {
                SeoHelper::setTitle(__('Search results for ":keyword"', ['keyword' => $keyword]));
            }

            return Theme::partial('shortcodes.projects-list.index', compact('shortcode', 'projects', 'showMap'));
        });

        shortcode()->setAdminConfig('projects-list', function (array $attributes) {
            return Theme::partial('shortcodes.properties-list.admin', compact('attributes'));
        });

        add_shortcode('recently-viewed-properties', __('Recent Viewed Properties'), __('Recently Viewed Properties'), function (Shortcode $shortcode) {
            $cookieName = 'recently_viewed_properties';

            $jsonRecentlyViewedProperties = $_COOKIE[$cookieName] ?? null;

            if (! $jsonRecentlyViewedProperties) {
                return null;
            }

            $propertyIds = collect(json_decode($jsonRecentlyViewedProperties))->pluck('id');

            if (! $propertyIds) {
                return null;
            }

            $properties = app(PropertyInterface::class)->advancedGet(array_merge([
                'condition' => [
                    ['id', 'IN', $propertyIds],
                ],
            ], RealEstateHelper::getReviewExtraData()));

            if ($properties->isEmpty()) {
                return null;
            }

            $shortcode->layout = $shortcode->layout ?: 'grid';

            return Theme::partial('shortcodes.recently-viewed-properties.index', compact('shortcode', 'properties'));
        });

        shortcode()->setAdminConfig('recently-viewed-properties', function ($attributes, $content) {
            return Theme::partial('shortcodes.recently-viewed-properties.admin', compact('attributes', 'content'));
        });

        add_shortcode('featured-agents', __('Featured Agents'), __('Featured Agents'), function (Shortcode $shortcode) {
            if (RealEstateHelper::isDisabledPublicProfile()) {
                return null;
            }

            $accounts = app(AccountInterface::class)->advancedGet([
                'condition' => [
                    're_accounts.is_featured' => true,
                    're_accounts.is_public_profile' => true,
                ],
                'order_by' => ['re_accounts.id' => 'DESC'],
                'take' => (int)$shortcode->limit ?: 6,
                'with' => ['avatar'],
                'withCount' => [
                    'properties' => function ($query) {
                        RepositoryHelper::applyBeforeExecuteQuery($query, $query->getModel());
                    },
                ],
            ]);

            return Theme::partial('shortcodes.featured-agents.index', compact('shortcode', 'accounts'));
        });

        shortcode()->setAdminConfig('featured-agents', function (array $attributes) {
            return Theme::partial('shortcodes.featured-agents.admin', compact('attributes'));
        });

        add_shortcode('favorite-projects', __('Favorite Projects'), __('Favorite Projects'), function (Shortcode $shortcode) {
            if (! RealEstateHelper::isEnabledWishlist()) {
                return null;
            }

            $cookieName = 'real_estate_wishlist';
            $wishlist = json_decode($_COOKIE[$cookieName] ?? null);

            if (! $wishlist || count($wishlist->projects) < 1) {
                return null;
            }

            $projectIds = $wishlist->projects;

            $params = array_merge(RealEstateHelper::getReviewExtraData(), [
                'condition' => [
                    ['re_projects.id', 'IN', $projectIds],
                ],
                'order_by' => [
                    're_projects.id' => 'DESC',
                ],
                'with' => RealEstateHelper::getProjectRelationsQuery(),
            ]);

            if ((int)$shortcode->limit) {
                $params['limit'] = (int)$shortcode->limit;
            }

            Theme::asset()->container('footer')->usePath()->add('wishlist', 'js/wishlist.js');

            $projects = app(ProjectInterface::class)->advancedGet($params);

            return Theme::partial('shortcodes.favorite-projects.index', compact('shortcode', 'projects'));
        });

        shortcode()->setAdminConfig('favorite-projects', function (array $attributes) {
            return Theme::partial('shortcodes.favorite-projects.admin', compact('attributes'));
        });

        add_shortcode('favorite-properties', __('Favorite Properties'), __('Favorite Properties'), function (Shortcode $shortcode) {
            if (! RealEstateHelper::isEnabledWishlist()) {
                return null;
            }

            $cookieName = 'real_estate_wishlist';
            $wishlist = json_decode($_COOKIE[$cookieName] ?? null);

            if (! $wishlist || count($wishlist->properties) < 1) {
                return null;
            }

            $propertiesIds = $wishlist->properties;

            $params = array_merge(RealEstateHelper::getReviewExtraData(), [
                'condition' => [
                    ['re_properties.id', 'IN', $propertiesIds],
                ],
                'order_by' => [
                    're_properties.id' => 'DESC',
                ],
                'with' => RealEstateHelper::getPropertyRelationsQuery(),
            ]);

            if ((int)$shortcode->limit) {
                $params['limit'] = (int)$shortcode->limit;
            }

            Theme::asset()->container('footer')->usePath()->add('wishlist', 'js/wishlist.js');

            $properties = app(PropertyInterface::class)->advancedGet($params);

            return Theme::partial('shortcodes.favorite-properties.index', compact('shortcode', 'properties'));
        });

        shortcode()->setAdminConfig('favorite-properties', function (array $attributes) {
            return Theme::partial('shortcodes.favorite-properties.admin', compact('attributes'));
        });

        if (is_plugin_active('location')) {
            add_shortcode('properties-by-locations', __('Properties by locations'), __('Properties by locations'), function ($shortcode) {
                $cityIds = array_filter(explode(',', $shortcode->city));
                $stateIds = array_filter(explode(',', $shortcode->state));

                if (empty($cityIds) && empty($stateIds)) {
                    return null;
                }

                $cities = collect();
                $states = collect();

                if (! empty($cityIds)) {
                    $cities = City::query()
                        ->whereIn('id', $cityIds)
                        ->where('status', BaseStatusEnum::PUBLISHED)
                        ->select(['id', 'name', 'image', 'slug'])
                        ->orderBy('order')
                        ->orderBy('name')
                        ->get();

                    $cities->transform(function (City $city) {
                        $city->setAttribute('url', route('public.properties-by-city', $city->slug));

                        return $city;
                    });
                }

                if (! empty($stateIds)) {
                    $states = State::query()
                        ->whereIn('id', $stateIds)
                        ->where('status', BaseStatusEnum::PUBLISHED)
                        ->select(['id', 'name', 'image', 'slug'])
                        ->orderBy('order')
                        ->orderBy('name')
                        ->get();

                    $states->transform(function (State $state) {
                        $state->setAttribute('url', route('public.properties-by-state', $state->slug));

                        return $state;
                    });
                }

                $locations = $cities->merge($states);

                if ($locations->isEmpty()) {
                    return null;
                }

                Theme::asset()->usePath()->add('tiny-slider-css', 'plugins/tiny-slider/tiny-slider.css');
                Theme::asset()->container('footer')->usePath()->add(
                    'tiny-slider-js',
                    'plugins/tiny-slider/tiny-slider.js'
                );

                return Theme::partial('shortcodes.properties-by-locations.index', compact('shortcode', 'locations'));
            });

            shortcode()->setAdminConfig('properties-by-locations', function ($attributes) {
                $cities = City::query()
                    ->where('status', BaseStatusEnum::PUBLISHED)
                    ->pluck('name', 'id');

                $states = State::query()
                    ->where('status', BaseStatusEnum::PUBLISHED)
                    ->pluck('name', 'id');

                return Html::style('vendor/core/core/base/libraries/tagify/tagify.css') .
                    Html::script('vendor/core/core/base/libraries/tagify/tagify.js') .
                    Html::script('vendor/core/core/base/js/tags.js') .
                    Theme::partial('shortcodes.properties-by-locations.admin', compact('attributes', 'states', 'cities'));
            });

            add_shortcode('projects-by-locations', __('Projects by locations'), __('Projects by locations'), function ($shortcode) {
                $cityIds = array_filter(explode(',', $shortcode->city));
                $stateIds = array_filter(explode(',', $shortcode->state));

                if (empty($cityIds) && empty($stateIds)) {
                    return null;
                }

                $cities = collect();
                $states = collect();

                if (! empty($cityIds)) {
                    $cities = City::query()
                        ->whereIn('id', $cityIds)
                        ->where('status', BaseStatusEnum::PUBLISHED)
                        ->select(['id', 'name', 'image', 'slug'])
                        ->orderBy('order')
                        ->orderBy('name')
                        ->get();

                    $cities->transform(function (City $city) {
                        $city->setAttribute('url', route('public.projects-by-city', $city->slug));

                        return $city;
                    });
                }

                if (! empty($stateIds)) {
                    $states = State::query()
                        ->whereIn('id', $stateIds)
                        ->where('status', BaseStatusEnum::PUBLISHED)
                        ->select(['id', 'name', 'image', 'slug'])
                        ->orderBy('order')
                        ->orderBy('name')
                        ->get();

                    $states->transform(function (State $state) {
                        $state->setAttribute('url', route('public.projects-by-state', $state->slug));

                        return $state;
                    });
                }

                $locations = $cities->merge($states);

                if ($locations->isEmpty()) {
                    return null;
                }

                Theme::asset()->usePath()->add('tiny-slider-css', 'plugins/tiny-slider/tiny-slider.css');
                Theme::asset()->container('footer')->usePath()->add(
                    'tiny-slider-js',
                    'plugins/tiny-slider/tiny-slider.js'
                );

                return Theme::partial('shortcodes.projects-by-locations.index', compact('shortcode', 'locations'));
            });

            shortcode()->setAdminConfig('projects-by-locations', function ($attributes) {
                $cities = City::query()
                    ->where('status', BaseStatusEnum::PUBLISHED)
                    ->pluck('name', 'id');

                $states = State::query()
                    ->where('status', BaseStatusEnum::PUBLISHED)
                    ->pluck('name', 'id');

                return Html::style('vendor/core/core/base/libraries/tagify/tagify.css') .
                    Html::script('vendor/core/core/base/libraries/tagify/tagify.js') .
                    Html::script('vendor/core/core/base/js/tags.js') .
                    Theme::partial('shortcodes.projects-by-locations.admin', compact('attributes', 'cities', 'states'));
            });

            add_shortcode('featured-properties-on-map', __('Featured properties on map'), __('Featured properties on map'), function ($shortcode) {
                Theme::asset()->usePath()->add('leaflet-css', 'plugins/leaflet/leaflet.css');
                Theme::asset()->container('footer')->usePath()->add('leaflet-js', 'plugins/leaflet/leaflet.js');
                Theme::asset()->container('footer')->usePath()->add('leaflet-markercluster', 'plugins/leaflet/leaflet.markercluster-src.js');
                $categories = get_property_categories([
                    'indent' => '↳',
                    'conditions' => ['status' => BaseStatusEnum::PUBLISHED],
                ]);

                $searchTabs = [
                    'projects' => __('Projects'),
                    'sale' => __('Sale'),
                    'rent' => __('Rent'),
                ];

                $shortcode->search_tabs = array_filter(explode(',', $shortcode->search_tabs), function ($tab) use ($searchTabs) {
                    return in_array($tab, array_keys($searchTabs));
                });

                return Theme::partial('shortcodes.featured-properties-on-map.index', compact('shortcode', 'categories', 'searchTabs'));
            });

            shortcode()->setAdminConfig('featured-properties-on-map', function ($attributes) {
                $searchTabs = [
                    'projects' => __('Projects'),
                    'sale' => __('Sale'),
                    'rent' => __('Rent'),
                ];

                return Html::style('vendor/core/core/base/libraries/tagify/tagify.css') .
                    Html::script('vendor/core/core/base/libraries/tagify/tagify.js') .
                    Html::script('vendor/core/core/base/js/tags.js') .
                    Theme::partial('shortcodes.featured-properties-on-map.admin', compact('attributes', 'searchTabs'));
            });
        }
    }

    add_shortcode('how-it-works', __('How It Works'), __('How It Works'), function (Shortcode $shortcode) {
        return Theme::partial('shortcodes.how-it-works.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('how-it-works', function (array $attributes) {
        return Theme::partial('shortcodes.how-it-works.admin', compact('attributes'));
    });

    add_shortcode('get-in-touch', __('Get In Touch'), __('Get In Touch'), function (Shortcode $shortcode) {
        return Theme::partial('shortcodes.get-in-touch.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('get-in-touch', function (array $attributes) {
        return Theme::partial('shortcodes.get-in-touch.admin', compact('attributes'));
    });

    add_shortcode('business-partners', __('Business Partners'), __('Business Partners'), function (Shortcode $shortcode) {
        return Theme::partial('shortcodes.business-partners.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('business-partners', function (array $attributes) {
        return Theme::partial('shortcodes.business-partners.admin', compact('attributes'));
    });

    add_shortcode('team', __('Team'), __('Team'), function (Shortcode $shortcode) {
        if (($shortcode->account_ids)) {
            $teams = app(AccountInterface::class)->advancedGet([
                'condition' => [
                    'IN' => ['id', 'IN', explode(',', $shortcode->account_ids)],
                ],
            ]);
        } else {
            $teams = collect();
        }

        return Theme::partial('shortcodes.team.index', compact('shortcode', 'teams'));
    });

    shortcode()->setAdminConfig('team', function (array $attributes) {
        $accounts = app(AccountInterface::class)->all();

        return Theme::partial('shortcodes.team.admin', compact('attributes', 'accounts'));
    });

    add_shortcode('pricing', __('Pricing'), __('Pricing'), function (Shortcode $shortcode) {
        $packages = app(PackageInterface::class)->advancedGet([
            'condition' => ['status' => BaseStatusEnum::PUBLISHED],
            'order_by' => ['created_at' => 'DESC'],
        ]);

        return Theme::partial('shortcodes.pricing.index', compact('shortcode', 'packages'));
    });

    add_shortcode('intro-about-us', __('Intro About Us'), __('Intro About Us'), function (Shortcode $shortcode) {
        $shortcode->youtube_video_id = $shortcode->youtube_video_url ? Youtube::getYoutubeVideoID($shortcode->youtube_video_url) : null;

        return Theme::partial('shortcodes.intro-about-us.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('intro-about-us', function (array $attributes) {
        return Theme::partial('shortcodes.intro-about-us.admin', compact('attributes'));
    });

    add_shortcode('site-statistics', __('Site statistics'), __('Site statistics'), function (Shortcode $shortcode) {
        Theme::asset()->container('footer')->usePath()->add('tobii', 'plugins/tobii/js/tobii.min.js');

        return Theme::partial('shortcodes.site-statistics.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('site-statistics', function (array $attributes) {
        return Theme::partial('shortcodes.site-statistics.admin', compact('attributes'));
    });

    add_shortcode('contact-info', __('Contact info'), __('Contact info'), function (Shortcode $shortcode) {
        return Theme::partial('shortcodes.contact-info.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('contact-info', function (array $attributes) {
        return Theme::partial('shortcodes.contact-info.admin', compact('attributes'));
    });

    add_shortcode('feature-block', __('Feature Block'), __('Feature Block'), function (Shortcode $shortcode) {
        return Theme::partial('shortcodes.feature-block.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('feature-block', function (array $attributes) {
        return Theme::partial('shortcodes.feature-block.admin', compact('attributes'));
    });

    add_shortcode('coming-soon', __('Coming soon'), __('Coming soon'), function (Shortcode $shortcode) {
        Theme::asset()->container('footer')->usePath()->add('feather-icons', 'plugins/feather-icons/feather.min.js');
        Theme::asset()->container('footer')->usePath()->add('particles', 'plugins/particles.js/particles.js');

        return Theme::partial('shortcodes.coming-soon.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('coming-soon', function (array $attributes) {
        return Theme::partial('shortcodes.coming-soon.admin', compact('attributes'));
    });

    add_shortcode('google-map', __('Google Map'), __('Google Map'), function (Shortcode $shortcode) {
        return Theme::partial('shortcodes.google-map.index', compact('shortcode'));
    });

    shortcode()->setAdminConfig('google-map', function (array $attributes) {
        return Theme::partial('shortcodes.google-map.admin', compact('attributes'));
    });

    if (is_plugin_active('testimonial')) {
        add_shortcode('testimonials', __('Testimonials'), __('Testimonials'), function (Shortcode $shortcode) {
            Theme::asset()->usePath()->add('tiny-slider-css', 'plugins/tiny-slider/tiny-slider.css');
            Theme::asset()->container('footer')->usePath()->add(
                'tiny-slider-js',
                'plugins/tiny-slider/tiny-slider.js'
            );

            $testimonials = app(TestimonialInterface::class)->advancedGet([
                'condition' => ['status' => BaseStatusEnum::PUBLISHED],
            ]);

            return Theme::partial('shortcodes.testimonials.index', compact('shortcode', 'testimonials'));
        });

        shortcode()->setAdminConfig('testimonials', function (array $attributes) {
            return Theme::partial('shortcodes.testimonials.admin', compact('attributes'));
        });
    }

    if (is_plugin_active('contact')) {
        add_filter(CONTACT_FORM_TEMPLATE_VIEW, function () {
            return Theme::getThemeNamespace() . '::partials.shortcodes.contact-form.index';
        }, 120);

        shortcode()->setAdminConfig('contact-form', function (array $attributes) {
            return Theme::partial('shortcodes.contact-form.admin', compact('attributes'));
        });
    }

    if (is_plugin_active('faq')) {
        add_shortcode('faq', __('FAQ'), __('FAQ'), function (Shortcode $shortcode) {
            Theme::asset()->container('footer')->usePath()->add('gumshoejs', 'plugins/gumshoejs/gumshoe.polyfills.min.js');

            $condition = ['status' => BaseStatusEnum::PUBLISHED];

            if ($shortcode->categories) {
                $categoryIds = explode(',', $shortcode->categories);

                if ($categoryIds) {
                    $condition[] = ['id', 'IN', $categoryIds];
                }
            }

            $categories = app(FaqCategoryInterface::class)->advancedGet([
                'with' => ['faqs'],
                'condition' => $condition,
            ]);

            $faqs = app(FaqInterface::class)->advancedGet([
                'condition' => ['status' => BaseStatusEnum::PUBLISHED],
            ]);

            $schemaItems = new FaqCollection();

            foreach ($faqs as $faq) {
                $schemaItems->push(new FaqItem($faq->question, $faq->answer));
            }

            app(FaqContract::class)->registerSchema($schemaItems);

            return Theme::partial('shortcodes.faq.index', compact('shortcode', 'categories'));
        });

        shortcode()->setAdminConfig('faq', function (array $attributes) {
            $categories = app(FaqCategoryInterface::class)->advancedGet([
                'with' => ['faqs'],
                'condition' => ['status' => BaseStatusEnum::PUBLISHED],
            ]);

            return Theme::partial('shortcodes.faq.admin', compact('attributes', 'categories'));
        });
    }

    if (is_plugin_active('blog')) {
        add_shortcode('featured-posts', __('Featured Posts'), __('Featured Posts'), function (Shortcode $shortcode) {
            $posts = get_featured_posts((int)$shortcode->limit ?: 3);

            return Theme::partial('shortcodes.featured-posts.index', compact('shortcode', 'posts'));
        });

        shortcode()->setAdminConfig('featured-posts', function (array $attributes) {
            return Theme::partial('shortcodes.featured-posts.admin', compact('attributes'));
        });
    }
});
