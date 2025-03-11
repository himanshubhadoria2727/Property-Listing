@php
    $statuses = [
        'ready_possession' => __('Ready Possession'),
        'under_construction' => __('Under Construction'),
        'ready_to_move' => __('Ready to Move in')
    ];
@endphp

<div>
    <label for="choices-status-{{ $type }}" class="text-sm font-medium text-gray-900 dark:text-white">{{ __('Status:') }}</label>
    <div class="relative mt-2">
        <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-orange-400 " fill="none" viewBox="0 0 24 24" stroke="currentColor" >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
        </div>
        <select 
            name="status" 
            id="choices-status-{{ $id ?? $type }}" 
            aria-label="{{ __('Status') }}"
            class="block w-full h-[3.7rem] pl-10 pr-10 py-1 text-xl border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-sm appearance-none dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        >
            <option value="">{{ __('All Status') }}</option>
            @foreach($statuses as $key => $value)
                <option value="{{ $key }}" @if(request()->input('status') === $key) selected @endif>{{ $value }}</option>
            @endforeach
        </select>
        <div class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
            <svg class="w-5 h-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
        </div>
    </div>
</div>