<?php

use Botble\Page\Models\Page;
use Illuminate\Database\Migrations\Migration;

return new class () extends Migration {
    public function up(): void
    {
        if (! is_plugin_active('real-estate')) {
            return;
        }

        $pages = Page::query()
            ->where('content', 'like', '%hero-banner%')
            ->orWhere('content', 'like', '%featured-properties-on-map%')
            ->get();

        if ($pages->isEmpty()) {
            return;
        }

        foreach ($pages as $page) {
            $content = $page->content;

            $content = str_replace(
                ['][/hero-banner]', '][featured-properties-on-map]'],
                [' search_tabs="projects,sale,rent"][/hero-banner]', '][featured-properties-on-map search_tabs="projects,sale,rent"]'],
                $content
            );

            $page->update([
                'content' => $content,
            ]);
        }

        if (! is_plugin_active('language') || ! is_plugin_active('language-advanced')) {
            return;
        }

        $translations = DB::table('pages_translations')
            ->where('content', 'like', '%hero-banner%')
            ->orWhere('content', 'like', '%featured-properties-on-map%')
            ->get();

        foreach ($translations as $translation) {
            $content = $translation->content;

            $content = str_replace(
                ['][/hero-banner]', '][featured-properties-on-map]'],
                [' search_tabs="projects,sale,rent"][/hero-banner]', '][featured-properties-on-map search_tabs="projects,sale,rent"]'],
                $content
            );

            DB::table('pages_translations')
                ->where('pages_id', $translation->pages_id)
                ->update([
                    'content' => $content,
                ]);
        }
    }
};
