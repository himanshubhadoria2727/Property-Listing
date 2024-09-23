<?php

namespace Database\Seeders;

use Botble\Base\Supports\BaseSeeder;
use Botble\Language\Models\LanguageMeta;
use Botble\Menu\Facades\Menu;
use Botble\Menu\Models\Menu as MenuModel;
use Botble\Menu\Models\MenuLocation;
use Botble\Menu\Models\MenuNode;
use Botble\Page\Models\Page;
use Botble\RealEstate\Models\Project;
use Botble\RealEstate\Models\Property;
use Illuminate\Support\Arr;
use Illuminate\Support\Str;

class MenuSeeder extends BaseSeeder
{
    public function run(): void
    {
        MenuModel::query()->truncate();
        MenuLocation::query()->truncate();
        MenuNode::query()->truncate();

        $data = [
            [
                'name' => 'Main menu',
                'location' => 'main-menu',
                'items' => [
                    [
                        'title' => 'Home',
                        'children' => [
                            [
                                'title' => 'Home One',
                                'reference_type' => Page::class,
                                'reference_id' => 1,
                            ],
                            [
                                'title' => 'Home Two',
                                'reference_type' => Page::class,
                                'reference_id' => 2,
                            ],
                            [
                                'title' => 'Home Three',
                                'reference_type' => Page::class,
                                'reference_id' => 3,
                            ],
                            [
                                'title' => 'Home Four',
                                'reference_type' => Page::class,
                                'reference_id' => 4,
                            ],
                        ],
                    ],
                    [
                        'title' => 'Projects',
                        'url' => '/projects',
                        'children' => [
                            [
                                'title' => 'Projects List',
                                'reference_type' => Page::class,
                                'reference_id' => 5,
                            ],
                            [
                                'title' => 'Project Detail',
                                'url' => str_replace(url(''), '', Project::query()->first()->url),
                            ],
                        ],
                    ],
                    [
                        'title' => 'Properties',
                        'reference_type' => Page::class,
                        'reference_id' => 6,
                        'children' => [
                            [
                                'title' => 'Properties List',
                                'reference_type' => Page::class,
                                'reference_id' => 6,
                            ],
                            [
                                'title' => 'Property Detail',
                                'url' => str_replace(url(''), '', Property::query()->first()->url),
                            ],
                        ],
                    ],
                    [
                        'title' => 'Page',
                        'url' => '/page',
                        'children' => [
                            [
                                'title' => 'Agents',
                                'url' => '/agents',
                            ],
                            [
                                'title' => 'Wishlist',
                                'reference_type' => Page::class,
                                'reference_id' => 16,
                            ],
                            [
                                'title' => 'About Us',
                                'reference_type' => Page::class,
                                'reference_id' => 7,
                            ],
                            [
                                'title' => 'Features',
                                'reference_type' => Page::class,
                                'reference_id' => 8,
                            ],
                            [
                                'title' => 'Pricing',
                                'reference_type' => Page::class,
                                'reference_id' => 9,
                            ],
                            [
                                'title' => 'FAQs',
                                'reference_type' => Page::class,
                                'reference_id' => 10,
                            ],
                            [
                                'title' => 'Contact',
                                'reference_type' => Page::class,
                                'reference_id' => 15,
                            ],
                            [
                                'title' => 'Auth Pages',
                                'url' => '/auth-pages',
                                'children' => [
                                    [
                                        'title' => 'Login',
                                        'url' => '/login',
                                    ],
                                    [
                                        'title' => 'Signup',
                                        'url' => '/register',
                                    ],
                                    [
                                        'title' => 'Reset Password',
                                        'url' => '/password/request',
                                    ],
                                ],
                            ],
                            [
                                'title' => 'Utility',
                                'url' => '/utility',
                                'children' => [
                                    [
                                        'title' => 'Terms of Services',
                                        'reference_type' => Page::class,
                                        'reference_id' => 11,
                                    ],
                                    [
                                        'title' => 'Privacy Policy',
                                        'url' => '/privacy-policy',
                                        'reference_type' => Page::class,
                                        'reference_id' => 12,
                                    ],
                                ],
                            ],
                            [
                                'title' => 'Special',
                                'url' => '/special',
                                'children' => [
                                    [
                                        'title' => 'Coming soon',
                                        'reference_type' => Page::class,
                                        'reference_id' => 13,
                                    ],
                                    [
                                        'title' => '404 Error',
                                        'url' => '/404',
                                    ],
                                ],
                            ],
                        ],
                    ],
                ],
            ],
            [
                'name' => 'Company',
                'items' => [
                    [
                        'title' => 'About Us',
                        'reference_type' => Page::class,
                        'reference_id' => 7,
                    ],
                    [
                        'title' => 'Services',
                        'url' => '#',
                    ],
                    [
                        'title' => 'Pricing',
                        'reference_type' => Page::class,
                        'reference_id' => 9,
                    ],
                    [
                        'title' => 'News',
                        'reference_type' => Page::class,
                        'reference_id' => 14,
                    ],
                    [
                        'title' => 'Login',
                        'url' => url('login'),
                    ],
                ],
            ],
            [
                'name' => 'Useful Links',
                'items' => [
                    [
                        'title' => 'Terms of Services',
                        'reference_type' => Page::class,
                        'reference_id' => 11,
                    ],
                    [
                        'title' => 'Privacy Policy',
                        'reference_type' => Page::class,
                        'reference_id' => 12,
                    ],
                    [
                        'title' => 'Listing',
                        'reference_type' => Page::class,
                        'reference_id' => 6,
                    ],
                    [
                        'title' => 'Contact',
                        'reference_type' => Page::class,
                        'reference_id' => 14,
                    ],
                ],
            ],
        ];

        foreach ($data as $index => $item) {
            $menu = MenuModel::query()->create(
                array_merge(Arr::except($item, ['items', 'location']), [
                    'slug' => $item['slug'] ?? Str::slug($item['name']),
                ])
            );

            if (isset($item['location'])) {
                $menuLocation = MenuLocation::query()->create([
                    'menu_id' => $menu->id,
                    'location' => $item['location'],
                ]);

                LanguageMeta::saveMetaData($menuLocation);
            }

            foreach ($item['items'] as $menuNode) {
                $this->createMenuNode($index, $menuNode, $menu->id);
            }

            LanguageMeta::saveMetaData($menu);
        }

        Menu::clearCacheMenuItems();
    }

    protected function createMenuNode(int $index, array $menuNode, int|string $menuId, int|string $parentId = 0): void
    {
        $menuNode['menu_id'] = $menuId;
        $menuNode['parent_id'] = $parentId;

        if (isset($menuNode['url'])) {
            $menuNode['url'] = str_replace(url(''), '', $menuNode['url']);
        }

        if (Arr::has($menuNode, 'children')) {
            $children = $menuNode['children'];
            $menuNode['has_child'] = true;

            unset($menuNode['children']);
        } else {
            $children = [];
            $menuNode['has_child'] = false;
        }

        $createdNode = MenuNode::query()->create($menuNode);

        if ($children) {
            foreach ($children as $child) {
                $this->createMenuNode($index, $child, $menuId, $createdNode->id);
            }
        }
    }
}
