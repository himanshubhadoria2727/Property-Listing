<div>
    <label for="location-{{ $type }}" class="font-medium form-label text-slate-900 dark:text-white">{{ __('Location:') }}</label>
    <div class="relative mt-2 filter-search-form filter-border">
        <i class="mdi mdi-map-marker-outline icons"></i>
        <input 
            name="location" 
            type="text" 
            id="location-{{ $type }}" 
            class="border-0 form-input filter-input-box bg-gray-50 dark:bg-slate-800" 
            placeholder="{{ __('City, state') }}" 
            autocomplete="off" 
            data-url="{{ route('public.ajax.cities') }}"
            style="width: 100%; padding-right: 30px;">
        <i class="absolute hidden mdi mdi-loading mdi-spin top-5 end-5"></i>
    </div>
    
    <!-- Improved regions section with better styling -->
    <div id="regions-container-{{ $type }}" class="mt-2 hidden" style="transition: all 0.3s ease;">
        <label for="regions-{{ $type }}" class="font-medium form-label text-slate-900 dark:text-white" style="margin-bottom: 5px; display: block;">
            {{ __('Regions:') }}
        </label>
        <select 
            name="region" 
            id="regions-{{ $type }}" 
            class="form-select filter-input-box bg-gray-50 dark:bg-slate-800"
            style="width: 100%; padding: 8px 12px; border-radius: 5px; appearance: auto;">
            <option value="">{{ __('Select a region') }}</option>
        </select>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    initializeLocationFilter('{{ $type }}');
});

function initializeLocationFilter(type) {
    const locationInput = document.getElementById(`location-${type}`);
    const regionsContainer = document.getElementById(`regions-container-${type}`);
    const regionsSelect = document.getElementById(`regions-${type}`);
    const loadingIcon = locationInput.parentElement.querySelector('.mdi-loading');
    let selectedCity = '';

    // Initialize with any existing values from URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    const locationParam = urlParams.get('location');
    const regionParam = urlParams.get('region');
    
    if (locationParam) {
        locationInput.value = locationParam;
        handleCitySelection(locationParam, regionParam);
    }

    function handleCitySelection(city, preSelectedRegion = null) {
        if (!city) return;
        
        selectedCity = city.trim();
        console.log('Selected City:', selectedCity);

        loadingIcon.classList.remove('hidden');

        fetch(`{{ route('public.ajax.regions') }}?city=${encodeURIComponent(selectedCity)}`)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                regionsSelect.innerHTML = '<option value="">{{ __('Select a region') }}</option>';

                if (data.regions && data.regions.length > 0) {
                    data.regions.forEach(region => {
                        const option = document.createElement('option');
                        option.value = region;
                        option.textContent = region;
                        if (preSelectedRegion && preSelectedRegion === region) {
                            option.selected = true;
                        }
                        regionsSelect.appendChild(option);
                    });
                    
                    regionsContainer.style.opacity = '0';
                    regionsContainer.classList.remove('hidden');
                    setTimeout(() => {
                        regionsContainer.style.opacity = '1';
                    }, 50);
                } else {
                    regionsContainer.classList.add('hidden');
                }
            })
            .catch(error => {
                console.error('Error fetching regions:', error);
                regionsContainer.classList.add('hidden');
            })
            .finally(() => {
                loadingIcon.classList.add('hidden');
            });
    }

    locationInput.addEventListener('change', function(event) {
        handleCitySelection(event.target.value);
    });

    locationInput.addEventListener('input', function() {
        if (!this.value.trim()) {
            regionsContainer.classList.add('hidden');
            regionsSelect.innerHTML = '<option value="">{{ __('Select a region') }}</option>';
            selectedCity = '';
        }
    });

    // Enhanced autocomplete with better handling
    $(locationInput).autocomplete({
        source: function(request, response) {
            $.ajax({
                url: locationInput.dataset.url,
                dataType: 'json',
                data: {
                    term: request.term
                },
                success: function(data) {
                    response(data);
                }
            });
        },
        select: function(event, ui) {
            locationInput.value = ui.item.value;
            handleCitySelection(ui.item.value);
            return false;
        },
        minLength: 2,
        position: {
            my: "left top+2"
        }
    }).autocomplete("instance")._renderItem = function(ul, item) {
        return $("<li>")
            .append("<div style='padding: 8px 12px; cursor: pointer;'>" + item.label + "</div>")
            .appendTo(ul);
    };

    // Handle form reset
    const resetButton = document.querySelector('.reset-filter');
    if (resetButton) {
        resetButton.addEventListener('click', function() {
            locationInput.value = '';
            regionsContainer.classList.add('hidden');
            regionsSelect.innerHTML = '<option value="">{{ __('Select a region') }}</option>';
            selectedCity = '';
        });
    }
}
</script>