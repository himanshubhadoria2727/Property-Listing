<div class="mb-3">
    <label class="form-label">{{ __('Title') }}</label>
    <input type="text" name="title" value="{{ Arr::get($attributes, 'title') }}" class="form-control" placeholder="{{ __('Title') }}">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Description') }}</label>
    <textarea name="description" class="form-control" rows="3" placeholder="{{ __('Description') }}">{{ Arr::get($attributes, 'description') }}</textarea>
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Text button action') }}</label>
    <input type="text" name="text_button_action" value="{{ Arr::get($attributes, 'text_button_action') }}" class="form-control" placeholder="{{ __('Text button action') }}">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Url button action') }}</label>
    <input type="text" name="url_button_action" value="{{ Arr::get($attributes, 'url_button_action') }}" class="form-control" placeholder="{{ __('Url button action') }}">
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Image') }}</label>
    {!! Form::mediaImage('image', Arr::get($attributes, 'image')) !!}
</div>

<div class="mb-3">
    <label class="form-label">{{ __('Youtube Video URL') }}</label>
    <input type="text" name="youtube_video_url" value="{{ Arr::get($attributes, 'youtube_video_url') }}" class="form-control" placeholder="{{ __('Enter Youtube video URL') }}">
</div>
