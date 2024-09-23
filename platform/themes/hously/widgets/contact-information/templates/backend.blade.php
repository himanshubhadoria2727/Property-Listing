<div class="mb-3">
    <label for="widget-name">{{ __('Name') }}</label>
    <input type="text" id="widget-name" class="form-control" name="name" value="{{ Arr::get($config, 'name') }}">
</div>

<div class="mb-3">
    <label for="address">{{ __('Address') }}</label>
    <input type="text" id="address" class="form-control" name="address" value="{{ Arr::get($config, 'address') }}">
</div>

<div class="mb-3">
    <label for="email">{{ __('Email') }}</label>
    <input type="email" id="email" class="form-control" name="email" value="{{ Arr::get($config, 'email') }}">
</div>

<div class="mb-3">
    <label for="phone">{{ __('Phone number') }}</label>
    <input type="tel" id="phone" class="form-control" name="phone" value="{{ Arr::get($config, 'phone') }}">
</div>
