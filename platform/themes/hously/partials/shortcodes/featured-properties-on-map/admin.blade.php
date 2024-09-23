<div class="mb-3">
    <label class="form-label">{{ __('Search tabs') }}</label>
    <input name="search_tabs" class="form-control list-tagify" data-list="{{ json_encode($searchTabs) }}" value="{{ Arr::get($attributes, 'search_tabs') }}" placeholder="{{ __('Select search tabs to display on hero banner') }}">
</div>
