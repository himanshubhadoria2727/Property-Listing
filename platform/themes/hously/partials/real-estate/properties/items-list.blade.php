@if($properties->isNotEmpty())
    <div class="mt-8 grid grid-cols-1 lg:grid-cols-2 gap-[30px]">
        @foreach($properties as $property)
            <div class="w-full mx-auto overflow-hidden duration-500 ease-in-out bg-white shadow property-item group rounded-xl dark:bg-slate-900 hover:shadow-xl dark:hover:shadow-xl dark:shadow-gray-700 dark:hover:shadow-gray-700 lg:max-w-2xl">
                <div class="h-full md:flex">
                    <div class="relative overflow-hidden md:shrink-0">
                        <a href="{{ $property->url }}">
                            <img class="object-cover w-full h-full transition-all duration-500 md:w-48 hover:scale-110" src="{{ RvMedia::getImageUrl($property->image, 'large', false, RvMedia::getDefaultImage()) }}" alt="{{ $property->name }}">
                        </a>
                        <div class="absolute top-6 end-6">
                            <button type="button" class="text-lg text-red-600 bg-white rounded-full shadow btn btn-icon dark:bg-slate-900 dark:shadow-gray-700 add-to-wishlist" aria-label="{{ __('Add to wishlist') }}" data-box-type="property" data-id="{{ $property->id }}">
                                <i class="mdi mdi-heart-outline"></i>
                            </button>
                        </div>
                        @if($property->images && $imagesCount = count($property->images))
                            <div class="absolute top-6 start-6">
                                <div class="flex items-center justify-center content-center p-2 pt-2.5 bg-gray-700 rounded-md bg-opacity-60 text-white text-sm">
                                    <i class="leading-none mdi mdi-camera-outline me-1"></i>
                                    <span class="leading-none">{{ $imagesCount }}</span>
                                </div>
                            </div>
                        @endif
                        <div class="absolute bottom-0 flex text-sm md:hidden start-0 item-info-wrap">
                            <span class="flex items-center py-1 ps-6 pe-4 text-white">{{ $property->category->name }}</span>
                            {!! $property->status->toHtml() !!}
                        </div>
                    </div>
                    <div class="p-6">
                        <div>
                            <div class="hidden md:block -ms-0.5 mb-2">
                                <a href="{{ $property->category->url }}" class="text-sm transition-all hover:text-primary">
                                    <i class="mdi mdi-tag-outline"></i>
                                    {{ $property->category->name }}
                                </a>
                            </div>
                            <a href="{{ $property->url }}" class="text-lg font-medium duration-500 ease-in-out hover:text-primary" title="{{ $property->name }}">
                                {{ $property->name }}
                            </a>
                            @if($property->city->name || $property->state->name)
                                <p class="truncate text-slate-600 dark:text-slate-300">{{ $property->city->name ? $property->city->name . ', ' : '' }}{{ $property->state->name }}</p>
                            @else
                                <p class="truncate text-slate-600 dark:text-slate-300">&nbsp;</p>
                            @endif
                        </div>

                        <ul class="flex items-center justify-between py-4 ps-0 mb-0 list-none border-b md:py-4 dark:border-gray-800">
                            @php
                                $enabledBhks = [];
                                $bhkTypes = [
                                    ['id' => '1', 'label' => '1 BHK'],
                                    ['id' => '2', 'label' => '2 BHK'],
                                    ['id' => '2_5', 'label' => '2.5 BHK'],
                                    ['id' => '3', 'label' => '3 BHK'],
                                    ['id' => '3_5', 'label' => '3.5 BHK'],
                                    ['id' => '4', 'label' => '4 BHK'],
                                    ['id' => '4_5', 'label' => '4.5 BHK'],
                                    ['id' => '5', 'label' => '5 BHK']
                                ];
                                foreach ($bhkTypes as $bhk) {
                                    $field = 'has_' . str_replace('.', '_', $bhk['id']) . '_bhk';
                                    if ($property->$field) {
                                        $enabledBhks[] = $bhk['label'];
                                    }
                                }
                            @endphp
                            <li class="w-full">
                                <span class="block mb-2 text-sm font-medium text-slate-400">Available Units</span>
                                <div class="flex flex-wrap gap-2">
                                    @foreach($enabledBhks as $bhk)
                                        <span class="px-3 py-1.5 text-sm font-medium bg-slate-100 dark:bg-slate-700 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-600 transition-all">{{ $bhk }}</span>
                                    @endforeach
                                </div>
                            </li>
                        </ul>

                        <div class="pt-4 ps-0">
                            <div class="flex flex-wrap items-start gap-6 md:gap-8">
                                <div class="flex-1">
                                    <span class="block mb-1 text-sm font-medium text-slate-400">{{ __('Price') }}</span>
                                    <p class="text-base font-medium text-slate-800 dark:text-slate-200">
                                        @if($property->max_price && count($enabledBhks) > 1)
                                            {{ format_price($property->price, $property->currency) }} - {{ format_price($property->max_price, $property->currency) }}
                                        @else
                                            {{ format_price($property->price, $property->currency) }}
                                        @endif
                                    </p>
                                </div>

                                @if($property->square)
                                <div class="flex-1">
                                    <span class="block mb-1 text-sm font-medium text-slate-400">{{ __('Square') }}</span>
                                    <p class="text-base font-medium text-slate-800 dark:text-slate-200">
                                        @if($property->max_square && count($enabledBhks) > 1)
                                            {{ $property->square }} - {{ $property->max_square }} ft²
                                        @else
                                            {{ $property->square }} ft²
                                        @endif
                                    </p>
                                </div>
                                @endif

                                @if(RealEstateHelper::isEnabledReview())
                                <div class="flex-1">
                                    <span class="block mb-2 text-sm font-medium text-slate-400">{{ __('Rating') }}</span>
                                    @include(Theme::getThemeNamespace('views.real-estate.partials.review-star'), ['avgStar' => $property->reviews_avg_star, 'count' => $property->reviews_count])
                                </div>
                                @endif
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        @endforeach
    </div>
@else
    <div class="my-16 text-center">
        <svg class="mx-auto h-24 w-24 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 21v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21m0 0h4.5V3.545M12.75 21h7.5V10.75M2.25 21h1.5m18 0h-18M2.25 9l4.5-1.636M18.75 3l-1.5.545m0 6.205l3 1m1.5.5l-1.5-.5M6.75 7.364V3h-3v18m3-13.636l10.5-3.819" />
        </svg>
        <p class="mt-3 text-xl text-gray-500 dark:text-gray-300">{{ __('No properties found.') }}</p>
    </div>
@endif
