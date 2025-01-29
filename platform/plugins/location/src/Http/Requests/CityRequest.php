<?php

namespace Botble\Location\Http\Requests;

use Botble\Base\Enums\BaseStatusEnum;
use Botble\Base\Rules\OnOffRule;
use Botble\Support\Http\Requests\Request;
use Illuminate\Validation\Rule;
use Botble\Base\Facades\Assets;

class CityRequest extends Request
{
    public function rules(): array

    {
        return [
            'name' => 'required|string|max:250',
            'state_id' => 'nullable|exists:states,id',
            'country_id' => 'required|exists:countries,id',
            'slug' => [
                'nullable',
                'string',
                Rule::unique('cities', 'slug')->ignore($this->route('city')),
            ],
            'image' => 'nullable|string|max:255',
            'order' => 'required|integer|min:0|max:127',
            'status' => Rule::in(BaseStatusEnum::values()),
            'is_default' => new OnOffRule(),
            'regions' => 'nullable',
        ];
    }

    protected function prepareForValidation()
    {
        // Ensure regions is always an array
        $regions = $this->regions;
        if (is_string($regions) && !empty($regions)) {
            $regions = array_map('trim', explode(',', $regions));
        }

        $this->merge([
            'regions' => $regions ?? [],
        ]);
    }
}
