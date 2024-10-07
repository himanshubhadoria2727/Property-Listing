<header class="header--mobile">
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
                    alt="{{ theme_option('site_title') }}"
                >
            @endif
        </a>
    </div>
    <div class="header__right">
        <a
            href="{{ route('public.account.logout') }}"
            title="{{ trans('plugins/real-estate::dashboard.header_logout_link') }}"
            onclick="event.preventDefault(); document.getElementById('logout-form').submit();"
        >
            <x-core::icon name="ti ti-logout" />
        </a>

        <form id="logout-form" style="display: none;" action="{{ route('public.account.logout') }}" method="POST">
            @csrf
        </form>
    </div>
</header>
<aside class="ps-drawer--mobile">
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

<div class="ps-site-overlay"></div>

<main class="ps-main">
    <div class="ps-main__sidebar">
        <div class="ps-sidebar">
            <div class="ps-sidebar__top">
                <div class="ps-block--user-wellcome">
                    <div class="ps-block__left">
                        <img
                            src="{{ auth('account')->user()->avatar_url }}"
                            alt="{{ auth('account')->user()->name }}"
                            class="avatar avatar-lg"
                        />
                    </div>
                    <div class="ps-block__right">
                        <p>{{ __('Hello') }}, {{ auth('account')->user()->name }}</p>
                        <small>{{ __('Joined on :date', ['date' => auth('account')->user()->created_at->translatedFormat('M d, Y')]) }}</small>
                    </div>
                    <div class="ps-block__action">
                        <a
                            href="{{ route('public.account.logout') }}"
                            title="{{ trans('plugins/real-estate::dashboard.header_logout_link') }}"
                            onclick="event.preventDefault(); document.getElementById('logout-form').submit();"
                        >
                            <x-core::icon name="ti ti-logout" />
                        </a>
                    </div>
                </div>

                <div class="ps-block--earning-count">
                    <small>{{ __('Credits') }}</small>
                    <h3 class="my-2">{{ number_format(auth('account')->user()->credits) }}</h3>
                    <a href="{{ route('public.account.packages') }}" target="_blank">
                        {{ __('Buy credits') }}
                    </a>
                </div>
            </div>
            <div class="ps-sidebar__content">
                <div class="ps-sidebar__center">
                    @include('plugins/real-estate::themes.dashboard.layouts.menu')
                </div>
                <div class="ps-sidebar__footer">
                    <div class="ps-copyright">
                        @php $logo = theme_option('logo', theme_option('logo')); @endphp
                        @if ($logo)
                            <img
                                src="{{ RvMedia::getImageUrl($logo) }}"
                                alt="{{ theme_option('site_title') }}"
                                height="40"
                            >
                        @endif
                        <p>{!! BaseHelper::clean(theme_option('copyright')) !!}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div
        class="ps-main__wrapper"
        id="vendor-dashboard"
    >
        <header class="d-flex justify-content-between align-items-center mb-3">
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
        </header>

        <div id="app">
            @if (auth('account')->check() && !auth('account')->user()->canPost())
                <x-core::alert :title="trans('plugins/real-estate::package.add_credit_warning')">
                    <a href="{{ route('public.account.packages') }}">
                        {{ trans('plugins/real-estate::package.add_credit') }}
                    </a>
                </x-core::alert>
            @endif

            @yield('content')
        </div>
        <div class="mb-6 pb-4 pl-3 rounded-md shadow bg-slate-50 dark:bg-slate-800 dark:shadow-gray-700">
    @auth('account')
        
        @php
            // Fetch the authenticated user's ID
            $userId = auth('account')->id();

            // Log the user ID for debugging
            \Log::info('Authenticated User ID: ' . $userId);

            // Fetch future bookings for the authenticated user with property details
            $futureBookings = \Botble\RealEstate\Models\Booking::where('user_id', $userId)
                ->where('scheduled_at', '>', now())
                ->with('property') // Eager load the property relationship
                ->get();

            // Log the future bookings for debugging
            \Log::info('Future Bookings: ', $futureBookings->toArray());
        @endphp

        @if ($futureBookings->isNotEmpty())
            <div class="mt-4 text-red-600">
                <p>Already booked for the following times:</p>
                <ul>
                    @foreach ($futureBookings as $booking)
                        <li>
                            {{ \Carbon\Carbon::parse($booking->scheduled_at)->format('Y-m-d H:i') }} - 
                            {{ $booking->property->name }} <!-- Display property name -->
                        </li>
                    @endforeach
                </ul>
            </div>
        @else
            <p class="mt-4 text-green-600">No bookings for this property.</p>
        @endif

        <div class="mt-6">
            <h3 class="font-semibold">Your Properties and Their Bookings:</h3>
            @php
                // Fetch properties owned by the authenticated user
                $ownedProperties = \Botble\RealEstate\Models\Property::where('author_id', $userId)->get(); // Assuming owner_id is the column for property ownership

                // Count bookings for each owned property
                $propertyBookingsCount = [];
                foreach ($ownedProperties as $property) {
                    $propertyBookingsCount[$property->id] = $property->bookings()->count(); // Count bookings for each property
                }
            @endphp

            <ul>
                @foreach ($ownedProperties as $property)
                    <li>
                        {{ $property->name }}: {{ $propertyBookingsCount[$property->id] ?? 0 }} bookings
                    </li>
                @endforeach
            </ul>
        </div>
    @else
        <p>Please log in to make a booking.</p>
    @endauth
</div>

    </div>
</main>
