@php
    Theme::set('pageCoverImage', $page->getMetaData('cover_image', true));
    Theme::set('pageDescription', $page->description);
    Theme::set('navStyle', $page->getMetaData('navbar_style', true));
    // Simplified expo check
    $isExpoEnabled = Botble\RealEstate\Models\Expo::where('enabled', true)->exists();
@endphp

{!! apply_filters(PAGE_FILTER_FRONT_PAGE_CONTENT, Html::tag('div', BaseHelper::clean($page->content), ['class' => 'ck-content'])->toHtml(), 
$page) !!}

@if ($isExpoEnabled)
<!-- Expo Alert Bar -->
<div id="expoAlertBar" class="fixed bottom-0 right-0 left-0 bg-primary  text-[15px] text-white p-2 z-50 overflow-hidden">
    <div class="container mx-auto">
        <div class="marquee whitespace-nowrap">
            🎉 Live Tour Expo has started! Visit properties and watch live streams | 🏡 Explore the latest listings in your city | 📢 Don't miss out on exclusive real estate deals | 🚀 Join live sessions with top realtors!
        </div>
    </div>
</div>

<style>
    .marquee {
        display: inline-block;
        white-space: nowrap;
        animation: marquee-scroll 15s linear infinite;
    }

    @keyframes marquee-scroll {
        from {
            transform: translateX(100%);
        }
        to {
            transform: translateX(-100%);
        }
    }
</style>
@endif

<script type="module">
    let user = @json(auth('account')->user());
    let userId = user ? user.id : null;
    window.userId = userId || 'defaultUserId';
</script>

{{-- Load the external JS file --}}
<script type="module" src="{{ asset('themes/hously/js/calls.js') }}"></script>
