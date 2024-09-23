<?php

namespace Botble\RealEstate\Forms\Settings;

use Botble\Base\Forms\Fields\MultiCheckListField;
use Botble\RealEstate\Enums\ProjectStatusEnum;
use Botble\RealEstate\Enums\PropertyStatusEnum;
use Botble\RealEstate\Facades\RealEstateHelper;
use Botble\RealEstate\Http\Requests\Settings\GeneralSettingRequest;
use Botble\Setting\Forms\SettingForm;
use Illuminate\Support\Facades\Blade;

class GeneralSettingForm extends SettingForm
{
    public function setup(): void
    {
        parent::setup();

        $this
            ->setSectionTitle(trans('plugins/real-estate::settings.general.name'))
            ->setSectionDescription(trans('plugins/real-estate::settings.general.description'))
            ->addCustomField('multiCheckList', MultiCheckListField::class)
            ->setValidatorClass(GeneralSettingRequest::class)
            ->add('real_estate_square_unit', 'customSelect', [
                'label' => trans('plugins/real-estate::settings.general.form.square_unit'),
                'choices' => [
                    '' => trans('plugins/real-estate::settings.general.form.square_unit_none'),
                    'm²' => trans('plugins/real-estate::settings.general.form.square_unit_meter'),
                    'ft2' => trans('plugins/real-estate::settings.general.form.square_unit_feet'),
                    'yd2' => trans('plugins/real-estate::settings.general.form.square_unit_yard'),
                ],
                'selected' => setting('real_estate_square_unit', 'm²'),
            ])
            ->add('real_estate_display_views_count_in_detail_page', 'onOffCheckbox', [
                'label' => trans('plugins/real-estate::settings.general.form.display_views_count_in_detail_page'),
                'value' => setting('real_estate_display_views_count_in_detail_page', false),
            ])
            ->add('label_real_estate_hide_properties', 'html', [
                'html' => Blade::render(sprintf(
                    '<x-core::form.label>%s</x-core::form.label>',
                    trans('plugins/real-estate::settings.general.form.hide_properties_in_statuses')
                )),
            ])
            ->add('real_estate_hide_properties_in_statuses[]', 'multiCheckList', [
                'label' => false,
                'choices' => PropertyStatusEnum::labels(),
                'value' => old('real_estate_hide_properties_in_statuses', RealEstateHelper::exceptedPropertyStatuses()),
                'inline' => true,
            ])
            ->add('label_real_estate_hide_projects', 'html', [
                'html' => Blade::render(sprintf(
                    '<x-core::form.label>%s</x-core::form.label>',
                    trans('plugins/real-estate::settings.general.form.hide_projects_in_statuses'),
                )),
            ])
            ->add('real_estate_hide_projects_in_statuses[]', 'multiCheckList', [
                'label' => false,
                'choices' => ProjectStatusEnum::labels(),
                'value' => old('real_estate_hide_projects_in_statuses', RealEstateHelper::exceptedProjectsStatuses()),
                'inline' => true,
            ])
            ->add('real_estate_enable_review_feature', 'onOffCheckbox', [
                'label' => trans('plugins/real-estate::settings.general.form.enable_review_feature'),
                'value' => RealEstateHelper::isEnabledReview(),
                'attr' => [
                    'data-bb-toggle' => 'collapse',
                    'data-bb-target' => '.review-settings',
                ],
            ])
            ->add('open_fieldset_reviews_setting', 'html', [
                'html' => Blade::render(sprintf(
                    '<fieldset class="review-settings form-fieldset"
                    data-bb-value="1"
                    style="display: %s"/>',
                    old('real_estate_enable_review_feature', RealEstateHelper::isEnabledReview() ? 'block' : 'none')
                )),
            ])
            ->add('real_estate_reviews_per_page', 'text', [
                'label' => trans('plugins/real-estate::settings.general.form.reviews_per_page'),
                'value' => setting('real_estate_reviews_per_page', 10),
            ])
            ->add('close_fieldset_reviews_setting', 'html', [
                'html' => '</fieldset>',
            ])
            ->add('real_estate_enabled_custom_fields_feature', 'onOffCheckbox', [
                'label' => trans('plugins/real-estate::settings.general.form.enable_custom_fields'),
                'value' => RealEstateHelper::isEnabledCustomFields(),
                'attr' => [
                    'data-bb-toggle' => 'collapse',
                    'data-bb-target' => '.custom-fields-settings',
                ],
            ])
            ->add('open_fieldset_custom_fields_setting', 'html', [
                'html' => Blade::render(sprintf(
                    '<fieldset class="custom-fields-settings form-fieldset"
                    data-bb-value="1"
                    style="display: %s"/>',
                    old('real_estate_enabled_custom_fields_feature', RealEstateHelper::isEnabledCustomFields() ? 'block' : 'none')
                )),
            ])
            ->add('label_fieldset_custom_fields_setting', 'html', [
                'html' =>
                    Blade::render(sprintf(
                        '<x-core::form.label>%s</x-core::form.label>',
                        trans('plugins/real-estate::settings.general.form.mandatory_fields_at_consult_form')
                    )),
            ])
            ->add('real_estate_mandatory_fields_at_consult_form[]', 'multiCheckList', [
                'label' => false,
                'choices' => RealEstateHelper::getMandatoryFieldsAtConsultForm(),
                'value' => old('real_estate_mandatory_fields_at_consult_form', RealEstateHelper::enabledMandatoryFieldsAtConsultForm()),
                'inline' => true,
            ])
            ->add('label_real_estate_mandatory_fields_at_consult_form', 'html', [
                'html' =>
                    Blade::render(sprintf(
                        '<x-core::form.label>%s</x-core::form.label>',
                        trans('plugins/real-estate::settings.general.form.hide_fields_at_consult_form'),
                    )),
            ])
            ->add('real_estate_hide_fields_at_consult_form[]', 'multiCheckList', [
                'label' => false,
                'choices' => RealEstateHelper::getMandatoryFieldsAtConsultForm(),
                'value' => old('real_estate_hide_fields_at_consult_form', RealEstateHelper::getHiddenFieldsAtConsultForm()),
                'inline' => true,
            ])
            ->add('close_fieldset_custom_fields_setting', 'html', [
                'html' => '</fieldset>',
            ]);
    }
}
