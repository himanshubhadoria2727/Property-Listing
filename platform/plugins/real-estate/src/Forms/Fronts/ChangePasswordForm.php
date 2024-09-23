<?php

namespace Botble\RealEstate\Forms\Fronts;

use Botble\Base\Forms\FormAbstract;
use Botble\Base\Models\BaseModel;
use Botble\RealEstate\Http\Requests\UpdatePasswordRequest;
use Illuminate\Support\Facades\Blade;

class ChangePasswordForm extends FormAbstract
{
    public function setup(): void
    {
        $this
            ->setupModel(new BaseModel())
            ->setMethod('PUT')
            ->setValidatorClass(UpdatePasswordRequest::class)
            ->setFormOption('template', 'core/base::forms.form-content-only')
            ->setUrl(route('public.account.post.security'))
            ->add('old_password', 'password', [
                'label' => trans('plugins/real-estate::dashboard.current_password'),
            ])
            ->add('password', 'password', [
                'label' => trans('plugins/real-estate::dashboard.password_new'),
            ])
            ->add('password_confirmation', 'password', [
                'label' => trans('plugins/real-estate::dashboard.password_new_confirmation'),
            ])
            ->add('submit', 'html', [
                'html' => Blade::render(sprintf(
                    '<x-core::button type="submit" color="primary">%s</x-core::button>',
                    trans('plugins/real-estate::dashboard.password_update_btn')
                )),
            ]);
    }
}
