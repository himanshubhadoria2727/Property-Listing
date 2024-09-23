<div class="mb-3">
    <label class="form-label">{{ __('Number of projects per page') }}</label>
    {!! Form::customSelect('per_page', RealEstateHelper::getProjectsPerPageList(), Arr::get($attributes, 'per_page')) !!}
</div>
