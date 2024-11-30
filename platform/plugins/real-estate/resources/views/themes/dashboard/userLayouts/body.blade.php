<header class="header--mobile w-full">
    <div class="header__left">
        <button class="navbar-toggler">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>
    <div class="header__center">
        <a class="ps-logo" href="{{ route('public.account.dashboard') }}">
            @if ($logo = theme_option('logo', theme_option('logo')))
            <img
                src="{{ RvMedia::getImageUrl($logo) }}"
                alt="{{ theme_option('site_title') }}">
            @endif
        </a>
    </div>
    <div class="header__right">
        <a
            href="{{ route('public.account.logout') }}"
            title="{{ trans('plugins/real-estate::dashboard.header_logout_link') }}"
            onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
            <x-core::icon name="ti ti-logout" />
        </a>

        <form id="logout-form" style="display: none;" action="{{ route('public.account.logout') }}" method="POST">
            @csrf
        </form>
    </div>
</header>

<aside class="ps-drawer--mobile w-full">
    <div class="ps-drawer__header py-3">
        <h4 class="fs-3 mb-0">Menu</h4>
        <button class="ps-drawer__close">
            <x-core::icon name="ti ti-x" />
        </button>
    </div>
    <div class="ps-drawer__content">
        @include('plugins/real-estate::themes.dashboard.layouts.menu')
    </div>
</aside>

<div class="ps-site-overlay w-full"></div>

<main class="ps-main w-full">
    <div class=" w-full" id="vendor-dashboard">
        <!-- <header class="d-flex justify-content-center align-items-center content-center mb-3 w-full">
        <h3 class="fs-1">{{ PageTitle::getTitle(false) }}</h3>

            @if (auth('account')->user()->store && auth('account')->user()->id)
            <div class="d-flex align-items-center gap-4">
                @if (is_plugin_active('language'))
                @include(MarketplaceHelper::viewPath('vendor-dashboard.partials.language-switcher'))
                @endif
                <a href="{{ auth('account')->user()->url }}" target="_blank" class="d-flex align-items-center gap-2 text-uppercase">
                    {{ __('View your store') }}
                    <i class="icon-exit-right"></i>
                </a>
            </div>
            @endif
        </header> -->


        <!-- <div id="app">
            @if (auth('account')->check() && !auth('account')->user()->canPost())
                <x-core::alert :title="trans('plugins/real-estate::package.add_credit_warning')">
                    <a href="{{ route('public.account.packages') }}">
                        {{ trans('plugins/real-estate::package.add_credit') }}
                    </a>
                </x-core::alert>
            @endif

            @yield('content')
        </div> -->
    </div>
</main>