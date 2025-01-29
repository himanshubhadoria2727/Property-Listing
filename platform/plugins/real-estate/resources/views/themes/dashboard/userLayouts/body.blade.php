<header class="w-full" style="display: flex; justify-content: space-between; align-items: center; padding: 10px; border-bottom: 1px solid #ddd; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
    
    <div class="header__center" style="flex: 1; display: flex; align-items: center; justify-content: center;">
        <a class="ps-logo" href="/">
            @if ($logo = theme_option('logo', theme_option('logo')))
            <img
                width="100"
                height="100"
                src="{{ RvMedia::getImageUrl($logo) }}"
                alt="{{ theme_option('site_title') }}">
            @endif
        </a>
    </div>
    
    <div class="header__right">
        <a
            href="{{ route('public.account.logout') }}"
            title="{{ trans('plugins/real-estate::dashboard.header_logout_link') }}"
            onclick="handleLogout(event)">
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

<main style="padding-top: 20px; background-color: #C8C8C8;" class="ps-main w-full">
    <div class="w-full" id="vendor-dashboard">
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

<script>
    function handleLogout(event) {
        event.preventDefault();
        alert("LOGGIN OUTT....")

        const sessionId = localStorage.getItem('sessionId');
        
        if (sessionId) {
            fetch('{{ route('public.account.logout') }}', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                },
                body: JSON.stringify({ session_id: sessionId })
            })
            .then(response => {
                if (response.ok) {
                    // Remove session_id from localStorage
                    localStorage.removeItem('sessionId');
                    document.getElementById('logout-form').submit();
                } else {
                    console.error('Logout request failed.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        } else {
            document.getElementById('logout-form').submit();
        }
    }
</script>