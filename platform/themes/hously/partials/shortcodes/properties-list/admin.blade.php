<div class="mb-3">
    <label class="form-label">{{ __('Number of properties per page') }}</label>
    {!! Form::customSelect('per_page', RealEstateHelper::getPropertiesPerPageList(), Arr::get($attributes, 'per_page')) !!}
</div>
