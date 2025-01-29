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
            data-url="{{ route('public.ajax.cities') }}">
        <i class="absolute hidden mdi mdi-loading mdi-spin top-5 end-5"></i>
    </div>
    
    <!-- Initially hidden regions section -->
    <div id="regions-container" class="mt-2 hidden">
        <label for="regions" class="font-medium form-label text-slate-900 dark:text-white">{{ __('Regions:') }}</label>
        <select name="regions" id="regions" class="form-select filter-input-box bg-gray-50 dark:bg-slate-800">
            <option value="">{{ __('Select a region') }}</option>
        </select>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const locationInput = document.getElementById('location-{{ $type }}');
    const regionsContainer = document.getElementById('regions-container');
    const regionsSelect = document.getElementById('regions');
    const loadingIcon = document.querySelector('.mdi-loading');
    let selectedCity = '';

    // Function to handle city selection
    function handleCitySelection(city) {
        selectedCity = city.trim();
        console.log('Selected City:', selectedCity);

        // Show loading indicator
        loadingIcon.classList.remove('hidden');

        // Fetch regions for the selected city
        fetch(`{{ route('public.ajax.regions') }}?city=${encodeURIComponent(selectedCity)}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                // Clear and reset regions dropdown
                regionsSelect.innerHTML = '<option value="">{{ __('Select a region') }}</option>';

                if (data.regions && data.regions.length > 0) {
                    // Populate regions dropdown
                    data.regions.forEach(region => {
                        const option = document.createElement('option');
                        option.value = region;
                        option.textContent = region;
                        regionsSelect.appendChild(option);
                    });
                    // Show regions container
                    regionsContainer.classList.remove('hidden');
                } else {
                    // Hide regions container if no regions available
                    regionsContainer.classList.add('hidden');
                }
            })
            .catch(error => {
                console.error('Error fetching regions:', error);
                regionsContainer.classList.add('hidden');
            })
            .finally(() => {
                // Hide loading indicator
                loadingIcon.classList.add('hidden');
            });
    }

    // Event listener for when a city is selected (e.g., from autocomplete or dropdown)
    locationInput.addEventListener('change', function(event) {
        const selectedValue = event.target.value;
        handleCitySelection(selectedValue);
    });

    // Optional: Clear regions if the city input is cleared
    locationInput.addEventListener('input', function() {
        if (!this.value.trim()) {
            regionsContainer.classList.add('hidden');
            regionsSelect.innerHTML = '<option value="">{{ __('Select a region') }}</option>';
            selectedCity = '';
        }
    });

    // Example: If using an autocomplete library like jQuery UI Autocomplete
    $(locationInput).autocomplete({
        source: function(request, response) {
            $.ajax({
                url: $(locationInput).data('url'),
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
            // Set the selected city value
            locationInput.value = ui.item.value;
            handleCitySelection(ui.item.value);
        }
    });
});
</script>