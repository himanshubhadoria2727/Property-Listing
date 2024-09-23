<div class="mb-3">
    <label class="form-label">{{ __('Title') }}</label>
    <input name="title" value="{{ Arr::get($attributes, 'title') }}" class="form-control">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Subtitle') }}</label>
    <textarea name="subtitle" class="form-control" rows="3">{{ Arr::get($attributes, 'subtitle') }}</textarea>
</div>

<div class="mb-3">
    <label class="form-label">{{ __('City') }}</label>
    <input name="city" class="form-control list-tagify" data-list="{{ json_encode($cities) }}" value="{{ Arr::get($attributes, 'city') }}" placeholder="{{ __('Select city from the list') }}">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('State') }}</label>
    <input name="state" class="form-control list-tagify" data-list="{{ json_encode($states) }}" value="{{ Arr::get($attributes, 'state') }}" placeholder="{{ __('Select state from the list') }}">
</div>
