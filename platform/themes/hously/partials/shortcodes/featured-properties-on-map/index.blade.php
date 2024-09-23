@php($style = 1)

<section class="mt-20">
    <div class="relative mt-20 container-fluid">
        <div id="map"
             data-url="{{ route('public.ajax.featured-properties-for-map') }}"
             data-center="{{ json_encode(RealEstateHelper::getMapCenterLatLng()) }}">
        </div>
    </div>
    @if($shortcode->search_tabs)
        <div class="container">
            {!! Theme::partial('search-box', compact('categories', 'style', 'shortcode', 'searchTabs')) !!}
        </div>
    @endif
</section>

<script id="traffic-popup-map-template" type="text/x-custom-template">
    {!! Theme::partial('real-estate.properties.map') !!}
</script>
