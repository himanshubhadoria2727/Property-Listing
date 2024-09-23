<div class="mb-3">
    <label class="form-label">{{ __('Style') }}</label>
    {!!
        Form::customSelect('style', $styles, Arr::get($attributes, 'style'))
    !!}
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Title') }}</label>
    <input name="title" value="{{ Arr::get($attributes, 'title') }}" class="form-control">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Title highlight') }}</label>
    <input name="title_highlight" value="{{ Arr::get($attributes, 'title_highlight') }}" class="form-control">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Subtitle') }}</label>
    <textarea name="subtitle" class="form-control">{{ Arr::get($attributes, 'subtitle') }}</textarea>
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Background Image') }}</label>
    {!! Form::mediaImages('background_images', explode(',', Arr::get($attributes, 'background_images'))) !!}
</div>

<fieldset class="border p-2 mb-3">
    <div class="mb-3">
        <label class="form-label">{{ __('YouTube video URL') }}</label>
        <input name="youtube_video_url" value="{{ Arr::get($attributes, 'youtube_video_url') }}" class="form-control" placeholder="https://www.youtube.com/watch?v=p3r7-BHAvLU">
    </div>
    {{ Form::helper(__('YouTube video is just available if you use "Style 4".')) }}

    <div class="mb-3">
        <label class="form-label">{{ __('YouTube thumbnail') }}</label>
        {!! Form::mediaImage('preview_video_image', Arr::get($attributes, 'preview_video_image')) !!}
    </div>
</fieldset>

<div class="mb-3">
    <label class="form-label">{{ __('Enable search box on hero banner?') }}</label>
    {!! Form::customSelect('enabled_search_box', [
            true => trans('core/base::base.yes'),
            false => trans('core/base::base.no'),
        ], Arr::get($attributes, 'enabled_search_box', true))
    !!}
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Search tabs') }}</label>
    <input name="search_tabs" class="form-control list-tagify" data-list="{{ json_encode($searchTabs) }}" value="{{ Arr::get($attributes, 'search_tabs') }}" placeholder="{{ __('Select search tabs to display on hero banner') }}">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Search type') }}</label>
    {!! Form::customSelect('search_type', [
            'properties' => __('Properties search'),
            'projects' => __('Projects search'),
        ], Arr::get($attributes, 'search_type', true))
    !!}
</div>
