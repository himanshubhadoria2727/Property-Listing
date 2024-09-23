@php
    $images = $item->images;
    $images = array_values($images);
    $numberImages = count($images);
@endphp

<div class="container-fluid">
    <div class="mt-4 md:flex">
        @if (($firstImage = Arr::first($images)) && $numberImages != 4)
            <div class="@if ($numberImages > 1)lg:w-1/2 md:w-1/2 @else w-full @endif p-1">
                {!! Theme::partial('real-estate.properties.slider-image', ['property' => $item, 'image' => $firstImage]) !!}
            </div>
        @endif

        @if ($numberImages == 2)
            <div class="p-1 lg:w-1/2 md:w-1/2">
                {!! Theme::partial('real-estate.properties.slider-image', ['property' => $item, 'image' => $images[1]]) !!}
            </div>
        @elseif($numberImages == 3)
            <div class="p-1 lg:w-1/2 md:w-1/2">
                {!! Theme::partial('real-estate.properties.slider-image', ['property' => $item, 'image' => $images[1], 'mores' => $numberImages]) !!}
            </div>

            {!! Theme::partial('real-estate.properties.slider-image', ['property' => $item, 'image' => $images[2], 'hidden' => true]) !!}
        @elseif ($numberImages == 4)
            <div class="lg:w-full md:w-full">
                @for ($i = 0; $i < 4; $i++)
                    @if ($i % 2 == 0)
                        <div class="flex">
                            <div class="w-1/2 p-1">
                    @else
                        </div>
                        <div class="w-1/2 p-1">
                    @endif
                            {!! Theme::partial('real-estate.properties.slider-image', ['property' => $item, 'image' => $images[$i]]) !!}
                    @if (in_array($i, [1, 3]))
                            </div>
                        </div>
                    @endif
                @endfor
            </div>
        @elseif ($numberImages > 4)
            <div class="p-1 lg:w-1/2 md:w-1/2">
                <div class="grid grid-cols-2 gap-1">
                    @foreach(range(1, 4) as $i)
                        {!! Theme::partial('real-estate.properties.slider-image', ['property' => $item, 'image' => $images[$i], 'mores' => $i === 4 ? $numberImages : 0]) !!}
                    @endforeach
                </div>
            </div>

            @foreach($images as $key => $image)
                @if ($key > 4)
                    {!! Theme::partial('real-estate.properties.slider-image', ['property' => $item, 'image' => $image, 'hidden' => true]) !!}
                @endif
            @endforeach
        @endif
    </div>
</div>
