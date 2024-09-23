@php $numbers = $mores ?? false @endphp
<div @class(['group relative overflow-hidden pt-[56.25%]', 'hidden' => $hidden ?? false])>
    <a href="{{ RvMedia::getImageUrl($image) }}" class="absolute inset-0 lightbox" data-group="lightbox-pt-images-{{ $property->id }}">
        <img src="{{ RvMedia::getImageUrl($image) }}" alt="{{ $property->name }}" class="w-full">

        @if ($numbers > 5 || $numbers === 3)
            <div class="absolute inset-0 duration-500 ease-in-out bg-slate-900/70 group-hover:bg-slate-900/70"></div>
            <div class="absolute start-0 end-0 visible text-center -translate-y-1/2 top-1/2">
                <span class="text-black bg-white rounded-full btn">+{{ $numbers > 5 ? $numbers - 5 : $numbers - 2 }}</span>
            </div>
        @else
            <div class="absolute inset-0 duration-500 ease-in-out group-hover:bg-slate-900/70"></div>
            <div class="absolute start-0 end-0 invisible text-center -translate-y-1/2 top-1/2 group-hover:visible">
                <span class="text-white rounded-full btn btn-icon bg-primary hover:bg-secondary">
                    <i class="mdi mdi-camera"></i>
                </span>
            </div>
        @endif
    </a>
</div>
