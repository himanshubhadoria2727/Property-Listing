@php
$navStyle = Theme::get('navStyle');
$navClass = $navStyle === 'light' ? ' nav-light' : null;
$logoLight = theme_option('logo');
$logoDark = theme_option('logo_dark');
$defaultLogo = theme_option('logo');
$siteName = theme_option('site_title');
$user = auth('account')->user();
@endphp

<nav id="topnav" class="defaultscroll is-sticky">
    <div class="" style="padding-right:5%; padding-left:5%">
        <a class="logo" href="{{ route('public.index') }}" title="{{ $siteName }}">
            @switch($navStyle)
            @case('light')
            <span class="inline-block dark:hidden">
                @if($logoLight || $logoDark)
                <img src="{{ RvMedia::getImageUrl($logoDark) }}" class="l-dark" alt="{{ $siteName }}">
                <img src="{{ RvMedia::getImageUrl($logoLight) }}" class="l-light" alt="{{ $siteName }}">
                @else
                <img src="{{ RvMedia::getImageUrl($defaultLogo) }}" alt="{{ $siteName }}">
                @endif
            </span>
            @if($logoLight)
            <img src="{{ RvMedia::getImageUrl($logoLight) }}" class="hidden dark:inline-block" alt="{{ $siteName }}">
            @else
            <img src="{{ RvMedia::getImageUrl($defaultLogo) }}" alt="{{ $siteName }}">
            @endif
            @break
            @default
            @if($logoLight || $logoDark)
            <img src="{{ RvMedia::getImageUrl($logoDark) }}" class="inline-block dark:hidden" alt="{{ $siteName }}">
            <img src="{{ RvMedia::getImageUrl($logoLight) }}" class="hidden dark:inline-block" alt="{{ $siteName }}">
            @else
            <img src="{{ RvMedia::getImageUrl($defaultLogo) }}" alt="{{ $siteName }}">
            @endif
            @break
            @endswitch
        </a>

        <div class="menu-extras">
            <div class="menu-item">
                <button type="button" class="navbar-toggle" id="isToggle" onclick="toggleMenu()">
                    <div class="lines">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </button>
            </div>
        </div>

        @if(is_plugin_active('real-estate'))
        <ul class="buy-button list-none mb-0">
            {!! Theme::partial('language-switcher.language-switcher') !!}
            @if(RealEstateHelper::isLoginEnabled())
            @if($user && $user->role==2)
            <li class="inline mx-1 mb-0">
                <a href="{{ route('public.account.login') }}" class="text-white rounded-full px-6 py-3 bg-primary hover:bg-secondary border-primary dark:border-primary" aria-label="{{ __('Sign in') }}">
                    Dashboard
                </a>
            </li>
            @elseif(!$user)
            <li class="inline mx-1 mb-0">
                <a href="{{ route('public.account.login') }}" class="text-white rounded-full px-6 py-3 bg-primary hover:bg-secondary border-primary dark:border-primary" aria-label="{{ __('Sign in') }}">
                    Sign In
                </a>
            </li>
            @endif
            @if($user)
            <li class="hidden mb-0 sm:inline mx-1 ps-1">
                <a href="{{ route('public.account.properties.index') }}" style="border: 1.5px solid green;" class="text-black dark:text-white rounded-full btn px-4 border-2 border-primary dark:border-primary" aria-label="{{ __('Add your listing') }}">
                    {{ __('Add your listing') }}<i data-feather="plus" class="h-4 w-4 text-red-600 hover:bg-red-100 stroke-[3]"></i>
                </a>
            </li>
            @endif
            @if($user && $user->role == 1)
            <!-- Dropdown Menu -->
            <div class="relative inline-block text-left">
                <button
                    type="button"
                    class="inline-flex justify-center items-center w-full rounded-full border border-gray-300 shadow-sm mx-1 px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-all ease-in-out duration-300 transform hover:scale-105"
                    id="dropdownButton"
                    aria-expanded="false"
                    aria-haspopup="true"
                    onclick="toggleDropdown()">
                    Profile Options
                    <svg
                        id="dropdownIcon"
                        class="-mr-1 ml-2 h-5 w-5 transition-transform duration-300"
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 20 20"
                        fill="currentColor"
                        aria-hidden="true">
                        <path
                            fill-rule="evenodd"
                            d="M5.23 7.21a.75.75 0 011.06.02L10 11.293l3.71-4.063a.75.75 0 011.14.976l-4.25 4.665a.75.75 0 01-1.08 0L5.23 8.243a.75.75 0 01.02-1.06z"
                            clip-rule="evenodd" />
                    </svg>
                </button>
                <div
                    id="dropdownMenu"
                    class="hidden absolute right-0 mt-2 w-56 rounded-lg shadow-lg bg-white dark:bg-gray-800 ring-1 ring-black ring-opacity-5 focus:outline-none transform scale-95 origin-top-right transition-all duration-200"
                    role="menu"
                    aria-orientation="vertical"
                    aria-labelledby="dropdownButton">
                    <div class="py-1">
                        <a href="#" class="block px-4 py-2 text-base text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md transition-all duration-150 ease-in-out" role="menuitem">
                            Account Settings
                        </a>
                        <a
                            href="javascript:void(0);"
                            class="block px-4 py-2 text-base text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md transition-all duration-150 ease-in-out"
                            onclick="toggleModal('streamBookingModal')">
                            Live Stream Bookings
                        </a>
                        <a href="#" target="_blank" class="block px-4 py-2 text-base text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md transition-all duration-150 ease-in-out" role="menuitem">
                            Chats
                        </a>
                        <a
                            class="flex gap-2 px-4 py-2 text-base text-red-600 hover:bg-red-100 dark:hover:bg-red-700 dark:hover:text-red-200 rounded-md transition-all duration-150 ease-in-out"
                            href="{{ route('public.account.logout') }}"
                            title="{{ trans('plugins/real-estate::dashboard.header_logout_link') }}"
                            onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
                            Log out
                            <x-core::icon name="ti ti-logout" />
                        </a>
                        <form id="logout-form" style="display: none;" action="{{ route('public.account.logout') }}" method="POST">
                            @csrf
                        </form>
                    </div>
                </div>
            </div>
            @endif
            <!-- End Dropdown Menu -->
            @endif
        </ul>
        @endif

        <div id="navigation">
            {!!
            Menu::renderMenuLocation('main-menu', [
            'options' => ['class' => 'navigation-menu justify-end' . $navClass],
            'view' => 'main-menu',
            ])
            !!}

            <ul class="navigation-menu">
                {!! Theme::partial('language-switcher.language-switcher-mobile') !!}
            </ul>

        </div>

    </div>
</nav>


<script>
    function toggleModal(modalId) {
        const modal = document.getElementById(modalId);
        modal.classList.toggle('hidden');
        modal.classList.toggle('flex');
    }
</script>


<script>
    function toggleDropdown() {
        const dropdownMenu = document.getElementById('dropdownMenu');
        const dropdownIcon = document.getElementById('dropdownIcon');
        const isExpanded = dropdownMenu.classList.contains('hidden');

        dropdownMenu.classList.toggle('hidden', !isExpanded);
        dropdownMenu.classList.toggle('block', isExpanded);

        // Toggle rotation of the icon
        dropdownIcon.classList.toggle('rotate-180');
    }
</script>