@if (is_plugin_active('language'))
    @php
        $supportedLocales = Language::getSupportedLocales();
    @endphp

    @if ($supportedLocales && count($supportedLocales) > 1)
        @if (count(Botble\Base\Supports\Language::getAvailableLocales()) > 1)
            <footer>
                <p>{{ __('Languages') }}:
                    @foreach ($supportedLocales as $localeCode => $properties)
                        <a
                            hreflang="{{ $localeCode }}"
                            href="{{ route('settings.language', $localeCode) }}"
                            rel="alternate"
                            @if ($localeCode == Language::getCurrentLocale()) class="active" @endif
                        >
                            {!! language_flag($properties['lang_flag'], $properties['lang_name']) !!}
                            &nbsp;<span>{{ $properties['lang_name'] }}</span>
                        </a> &nbsp;
                    @endforeach
                </p>
            </footer>
        @endif
    @endif
@endif
