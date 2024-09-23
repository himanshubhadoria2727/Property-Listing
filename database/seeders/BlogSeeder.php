<?php

namespace Database\Seeders;

use Botble\ACL\Models\User;
use Botble\Base\Facades\Html;
use Botble\Base\Supports\BaseSeeder;
use Botble\Blog\Models\Category;
use Botble\Blog\Models\Post;
use Botble\Blog\Models\Tag;
use Botble\Media\Facades\RvMedia;
use Botble\Slug\Facades\SlugHelper;
use Illuminate\Support\Facades\DB;

class BlogSeeder extends BaseSeeder
{
    public function run(): void
    {
        Post::query()->truncate();
        Category::query()->truncate();
        Tag::query()->truncate();
        DB::table('post_categories')->truncate();
        DB::table('post_tags')->truncate();

        $usersCount = User::query()->count();

        $categories = [
            'Design',
            'Lifestyle',
            'Travel Tips',
            'Healthy',
            'Travel Tips',
            'Hotel',
            'Nature',
        ];

        foreach ($categories as $item) {
            $category = Category::query()->create([
                'name' => $item,
                'description' => $this->fake()->realText(),
                'author_type' => User::class,
                'author_id' => rand(1, $usersCount),
                'is_featured' => rand(0, 1),
            ]);

            SlugHelper::createSlug($category);
        }

        $tags = [
            'New',
            'Event',
            'Villa',
            'Apartment',
            'Condo',
            'Luxury villa',
            'Family home',
        ];

        foreach ($tags as $item) {
            $tag = Tag::query()->create([
                'name' => $item,
                'author_type' => User::class,
                'author_id' => rand(1, $usersCount),
            ]);

            SlugHelper::createSlug($tag);
        }

        $posts = [
            'The Top 2020 Handbag Trends to Know',
            'Top Search Engine Optimization Strategies!',
            'Which Company Would You Choose?',
            'Used Car Dealer Sales Tricks Exposed',
            '20 Ways To Sell Your Product Faster',
            'The Secrets Of Rich And Famous Writers',
            'Imagine Losing 20 Pounds In 14 Days!',
            'Are You Still Using That Slow, Old Typewriter?',
            'A Skin Cream That’s Proven To Work',
            '10 Reasons To Start Your Own, Profitable Website!',
            'Simple Ways To Reduce Your Unwanted Wrinkles!',
            'Apple iMac with Retina 5K display review',
            '10,000 Web Site Visitors In One Month:Guaranteed',
            'Unlock The Secrets Of Selling High Ticket Items',
            '4 Expert Tips On How To Choose The Right Men’s Wallet',
            'Sexy Clutches: How to Buy & Wear a Designer Clutch Bag',
        ];

        $categoriesCount = Category::query()->count();
        $tagsCount = Tag::query()->count();

        foreach ($posts as $index => $item) {
            $content =
                ($index % 3 == 0 ? Html::tag(
                    'p',
                    '[youtube-video]https://www.youtube.com/watch?v=SlPhMPnQ58k[/youtube-video]'
                ) : '') .
                Html::tag('p', $this->fake()->realText(1000)) .
                Html::tag(
                    'p',
                    Html::image(RvMedia::getImageUrl('news/' . $this->fake()->numberBetween(1, 5) . '.jpg'))
                        ->toHtml(),
                    ['class' => 'text-center']
                ) .
                Html::tag('p', $this->fake()->realText(500)) .
                Html::tag(
                    'p',
                    Html::image(RvMedia::getImageUrl('news/' . $this->fake()->numberBetween(6, 10) . '.jpg'))
                        ->toHtml(),
                    ['class' => 'text-center']
                ) .
                Html::tag('p', $this->fake()->realText(1000)) .
                Html::tag(
                    'p',
                    Html::image(RvMedia::getImageUrl('news/' . $this->fake()->numberBetween(11, 14) . '.jpg'))
                        ->toHtml(),
                    ['class' => 'text-center']
                ) .
                Html::tag('p', $this->fake()->realText(1000));

            $post = Post::query()->create([
                'author_type' => User::class,
                'author_id' => rand(1, $usersCount),
                'name' => $item,
                'views' => rand(100, 10000),
                'is_featured' => rand(0, 1),
                'image' => 'news/' . ($index + 1) . '.jpg',
                'description' => $this->fake()->realText(),
                'content' => str_replace(url(''), '', $content),
            ]);

            $post->categories()->sync(fake()->randomElements(range(1, $categoriesCount), rand(1, 3)));

            $post->tags()->sync(fake()->randomElements(range(1, $tagsCount), rand(1, 3)));

            SlugHelper::createSlug($post);
        }
    }
}
