@php
    Theme::set('pageCoverImage', $page->getMetaData('cover_image', true));
    Theme::set('pageDescription', $page->description);
    Theme::set('navStyle', $page->getMetaData('navbar_style', true));
@endphp

{!! apply_filters(PAGE_FILTER_FRONT_PAGE_CONTENT, Html::tag('div', BaseHelper::clean($page->content), ['class' => 'ck-content'])->toHtml(), 
$page) !!}

{{-- Load the external JS file --}}
<script type="module" src="{{ asset('themes/hously/js/calls.js') }}"></script>

@auth('account')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Ensure the user is authenticated
            @if(auth('account')->check())
                console.log('User authenticated');
                const userId = {{ auth('account')->id() }};
                console.log('User ID:', userId);

                if (typeof initialize === 'function') {
                    try {
                        // Pass the authenticated user's ID to the `initialize` function
                        initialize(userId);
                        console.log('Call initialized with ID:', userId);
                    } catch (error) {
                        console.error('Error initializing call:', error);
                    }
                } else {
                    console.error('The "initialize" function is not defined in calls.js.');
                }
            @else
                console.error('User is not authenticated.');
            @endif
        });
    </script>
@endauth

