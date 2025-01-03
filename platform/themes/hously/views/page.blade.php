@php
    Theme::set('pageCoverImage', $page->getMetaData('cover_image', true));
    Theme::set('pageDescription', $page->description);
    Theme::set('navStyle', $page->getMetaData('navbar_style', true));
@endphp

{!! apply_filters(PAGE_FILTER_FRONT_PAGE_CONTENT, Html::tag('div', BaseHelper::clean($page->content), ['class' => 'ck-content'])->toHtml(), 
$page) !!}

<script type="module">
    let user = @json(auth('account')->user());
    let userId = user ? user.id : null;
    window.userId = userId !== null ? userId : 'defaultUserId'; // Replace 'defaultUserId' with a suitable default value
</script>


{{-- Load the external JS file --}}
<script type="module" src="{{ asset('themes/hously/js/calls.js') }}"></script>






