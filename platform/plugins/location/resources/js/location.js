class Location {
    static getStates($el, countryId, $button = null) {
        $.ajax({
            url: $el.data('url'),
            data: {
                country_id: countryId,
            },
            type: 'GET',
            beforeSend: () => {
                $button && $button.prop('disabled', true)
            },
            success: (res) => {
                if (res.error) {
                    Botble.showError(res.message)
                } else {
                    let options = ''
                    $.each(res.data, (index, item) => {
                        options += '<option value="' + (item.id || '') + '">' + item.name + '</option>'
                    })

                    $el.html(options)
                }
            },
            complete: () => {
                $button && $button.prop('disabled', false)
            },
        })
    }

    static getCities($el, stateId, $button = null, countryId = null) {
        $.ajax({
            url: $el.data('url'),
            data: {
                state_id: stateId,
                country_id: countryId,
            },
            type: 'GET',
            beforeSend: () => {
                $button && $button.prop('disabled', true)
            },
            success: (res) => {
                if (res.error) {
                    Botble.showError(res.message)
                } else {
                    let options = ''
                    $.each(res.data, (index, item) => {
                        options += '<option value="' + (item.id || '') + '">' + item.name + '</option>'
                    })

                    $el.html(options)
                    $el.trigger('change')
                }
            },
            complete: () => {
                $button && $button.prop('disabled', false)
            },
        })
    }

    static getRegions($el, cityId, $button = null) {
        $.ajax({
            url: $el.data('url'),
            data: {
                city_id: cityId,
            },
            type: 'GET',
            beforeSend: () => {
                $button && $button.prop('disabled', true)
            },
            success: (res) => {
                if (res.error) {
                    Botble.showError(res.message)
                } else {
                    let options = '<option value="">Select region</option>'
                    // Handle array of strings
                    if (Array.isArray(res.data)) {
                        res.data.forEach(region => {
                            options += `<option value="${region}">${region}</option>`
                        })
                    } else {
                        // Fallback for object format if needed
                        $.each(res.data, (index, item) => {
                            if (typeof item === 'string') {
                                options += `<option value="${item}">${item}</option>`
                            } else {
                                options += `<option value="${item.id || ''}">${item.name}</option>`
                            }
                        })
                    }
                    $el.html(options)
                    $el.trigger('change')
                }
            },
            complete: () => {
                $button && $button.prop('disabled', false)
            },
        })
    }

    init() {
        const country = 'select[data-type="country"]'
        const state = 'select[data-type="state"]'
        const city = 'select[data-type="city"]'
        const region = 'select[data-type="region"]'

        $(document).on('change', country, function (e) {
            e.preventDefault()

            const $parent = getParent($(e.currentTarget))

            const $state = $parent.find(state)
            const $city = $parent.find(city)
            const $region = $parent.find(region)

            $state.find('option:not([value=""]):not([value="0"])').remove()
            $city.find('option:not([value=""]):not([value="0"])').remove()
            if ($region.length) {
                $region.html('<option value="">Select region</option>')
            }

            const $button = $(e.currentTarget).closest('form').find('button[type=submit], input[type=submit]')
            const countryId = $(e.currentTarget).val()

            if (countryId) {
                if ($state.length) {
                    Location.getStates($state, countryId, $button)
                    Location.getCities($city, null, $button, countryId)
                } else {
                    Location.getCities($city, null, $button, countryId)
                }
            }
        })

        $(document).on('change', state, function (e) {
            e.preventDefault()

            const $parent = getParent($(e.currentTarget))
            const $city = $parent.find(city)
            const $region = $parent.find(region)

            if ($city.length) {
                $city.find('option:not([value=""]):not([value="0"])').remove()
                if ($region.length) {
                    $region.html('<option value="">Select region</option>')
                }
                const stateId = $(e.currentTarget).val()
                const $button = $(e.currentTarget).closest('form').find('button[type=submit], input[type=submit]')

                if (stateId) {
                    Location.getCities($city, stateId, $button)
                } else {
                    const countryId = $parent.find(country).val()
                    Location.getCities($city, null, $button, countryId)
                }

                stateFieldUsingSelect2()
            }
        })

        $(document).on('change', city, function (e) {
            e.preventDefault()

            const $parent = getParent($(e.currentTarget))
            const $region = $parent.find(region)

            if ($region.length) {
                const cityId = $(e.currentTarget).val()
                const $button = $(e.currentTarget).closest('form').find('button[type=submit], input[type=submit]')

                if (cityId) {
                    Location.getRegions($region, cityId, $button)
                } else {
                    $region.html('<option value="">Select region</option>')
                }
            }
        })

        function stateFieldUsingSelect2() {
            if (jQuery().select2) {
                $(document)
                    .find('select[data-using-select2="true"]')
                    .each(function (index, input) {
                        let options = {
                            width: '100%',
                            minimumInputLength: 0,
                            ajax: {
                                url: $(input).data('url'),
                                dataType: 'json',
                                delay: 250,
                                type: 'GET',
                                data: function (params) {
                                    return {
                                        state_id: $(input).closest('form').find(state).val(),
                                        k: params.term,
                                        page: params.page || 1,
                                    }
                                },
                                processResults: function (data, params) {
                                    return {
                                        results: $.map(data.data[0], function (item) {
                                            return {
                                                text: item.name,
                                                id: item.id,
                                                data: item,
                                            }
                                        }),
                                        pagination: {
                                            more: params.page * 10 < data.total,
                                        },
                                    }
                                },
                            },
                        }

                        let parent = $(input).closest('div[data-select2-dropdown-parent]') || $(input).closest('.modal')
                        if (parent.length) {
                            options.dropdownParent = parent
                            options.width = '100%'
                            options.minimumResultsForSearch = -1
                        }

                        $(input).select2(options)
                    })
            }
        }

        stateFieldUsingSelect2()

        function getParent($el) {
            let $parent = $(document)
            let formParent = $el.data('form-parent')
            if (formParent && $(formParent).length) {
                $parent = $(formParent)
            }

            return $parent
        }
    }
}

$(() => {
    new Location().init()
})