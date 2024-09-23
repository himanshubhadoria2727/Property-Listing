<div @class(['grid grid-cols-1', 'mt-10' => $style === 2])>
    <ul @class([
        'flex-wrap justify-center inline-block w-full p-4 text-center bg-white border-b sm:w-fit rounded-t-xl dark:border-gray-800 mb-0',
        'dark:bg-slate-900' => $style === 1,
        'mx-auto mt-10 sm:w-fit bg-white/80 dark:bg-slate-900/80 backdrop-blur-sm' => $style === 2,
        'relative -mt-[6.5rem] z-10' => $shortcode->getName() === 'featured-properties-on-map'
    ]) id="searchTab" data-tabs-toggle="#search-filter" role="tablist">
        @foreach($searchTabs as $key => $value)
            @continue(! in_array($key, $shortcode->search_tabs))
            <li role="presentation" class="inline-block">
                <button @class(['w-full px-6 py-2 text-base font-medium transition-all duration-500 ease-in-out hover:text-primary', 'rounded-md' => $style === 1, 'rounded-xl' => $style === 2, 'rounded-3xl' => $style === 4]) id="{{ $key }}-tab" data-tabs-target="#{{ $key }}" type="button" role="tab" aria-controls="{{ $key }}" aria-selected="false">
                    {{ $value }}
                </button>
            </li>
        @endforeach
    </ul>

    <div @class([
        'p-6 bg-white shadow-md search-filter dark:bg-slate-900 rounded-se-none md:rounded-se-xl rounded-xl dark:shadow-gray-700',
        'rounded-ss-none' => $style == 1,
        'border-t -mt-8 z-10' => $shortcode->getName() === 'featured-properties-on-map'
    ])>
        @foreach($searchTabs as $key => $value)
            @continue(! in_array($key, $shortcode->search_tabs))
            <div @class(['hidden' => ! $loop->first]) id="{{ $key }}" role="tabpanel" aria-labelledby="{{ $key }}-tab">
                @php($type = $key === 'projects' ? 'project' : 'property')
                {!! Theme::partial("filters.$type", ['type' => $key, 'categories' => $categories]) !!}
            </div>
        @endforeach
    </div>
</div>
