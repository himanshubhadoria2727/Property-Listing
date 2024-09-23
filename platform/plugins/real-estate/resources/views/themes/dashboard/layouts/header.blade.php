{!! SeoHelper::render() !!}

@include('core/base::components.layouts.header')

<link href="{{ asset('vendor/core/plugins/real-estate/css/dashboard/style.css') }}" rel="stylesheet">

@if (BaseHelper::isRtlEnabled())
    <link href="{{ asset('vendor/core/plugins/real-estate/css/dashboard/style-rtl.css') }}" rel="stylesheet">
@endif
