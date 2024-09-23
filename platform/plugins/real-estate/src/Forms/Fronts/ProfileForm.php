<?php

namespace Botble\RealEstate\Forms\Fronts;

use Botble\RealEstate\Forms\AccountForm;
use Botble\RealEstate\Http\Requests\SettingRequest;
use Illuminate\Support\Facades\Blade;

class ProfileForm extends AccountForm
{
    public function setup(): void
    {
        parent::setup();

        $this
            ->setValidatorClass(SettingRequest::class)
            ->setFormOption('template', 'core/base::forms.form-content-only')
            ->modify('description', 'textarea', [
                'attr' => [
                    'rows' => 3,
                ],
            ])
            ->modify('email', 'text', [
                'required' => false,
                'attr' => [
                    'disabled' => true,
                ],
            ], true)
            ->remove(['is_change_password', 'password', 'password_confirmation', 'avatar_image', 'is_featured', 'is_public_profile'])
            ->addAfter('dob', 'gender', 'select', [
                'label' => trans('plugins/real-estate::dashboard.gender'),
                'choices' => [
                    'male' => trans('plugins/real-estate::dashboard.gender_male'),
                    'female' => trans('plugins/real-estate::dashboard.gender_female'),
                    'other' => trans('plugins/real-estate::dashboard.gender_other'),
                ],
            ])
            ->add('submit', 'html', [
                'html' => Blade::render(sprintf(
                    '<x-core::button type="submit" color="primary">%s</x-core::button>',
                    trans('plugins/real-estate::dashboard.save')
                )),
            ]);
    }
}
