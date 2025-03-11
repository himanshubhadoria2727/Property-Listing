@php
    $statuses = [
        'ready_possession' => __('Ready Possession'),
        'under_construction' => __('Under Construction'),
        'ready_to_move' => __('Ready to Move in')
    ];
@endphp

<div class="filter-search-form relative lg:mx-4">
    <label for="choices-status-{{ $type }}" class="font-medium form-label text-slate-900 dark:text-white">{{ __('Status:') }}</label>
    <div class="relative mt-2 filter-border">
        <span class="absolute top-[18px] start-4">
            <i class="mdi mdi-home-city-outline text-xl"></i>
        </span>
        <select class="form-input h-[50px] ps-11 w-full cursor-pointer" data-trigger name="status" id="choices-status-{{ $id ?? $type }}" aria-label="{{ __('Status') }}">
            <option value="">{{ __('All Status') }}</option>
            @foreach($statuses as $key => $value)
                <option value="{{ $key }}" @if(request()->input('status') === $key) selected @endif>{{ $value }}</option>
            @endforeach
        </select>
    </div>
</div>