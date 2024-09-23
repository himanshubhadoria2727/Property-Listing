@php
    $categoryIds = explode(',', Arr::get($attributes, 'categories'));
@endphp

<div class="mb-3">
    <label class="form-label">{{ __('Categories') }}</label>
    <select class="select-full" name="categories" multiple>
        @foreach($categories as $category)
            <option @selected(in_array($category->id, $categoryIds)) value="{{ $category->id }}">{{ $category->name }}</option>
        @endforeach
    </select>
</div>
