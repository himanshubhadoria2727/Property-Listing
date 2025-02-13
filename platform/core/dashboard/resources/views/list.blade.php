@extends(BaseHelper::getAdminMasterLayoutTemplate())

@php
$expoEnabled = Botble\RealEstate\Models\Expo::where('enabled', true)->exists();
@endphp
@push('header-action')
@if (count($widgets) > 0)
<x-core::button
    color="primary"
    :outlined="true"
    class="manage-widget"
    data-bs-toggle="modal"
    data-bs-target="#widgets-management-modal"
    icon="ti ti-layout-dashboard">
    {{ trans('core/dashboard::dashboard.manage_widgets') }}
</x-core::button>
@endif

@endpush

@section('content')
<div class="row">
    <div class="col-12">
        <!-- Toggle for enabling/disabling expo in the header -->
        <div style="display: inline-block; margin-left: 12px; margin-bottom: 20px;">
            <div style="position: relative;">
                <input
                    type="checkbox"
                    id="headerExpoToggle"
                    style="position: absolute; opacity: 0; width: 0; height: 0;"
                    @if($expoEnabled) checked @endif
                    onchange="toggleExpo(this.checked)">
                <label for="headerExpoToggle" style="display: flex; align-items: center; cursor: pointer;">
                    <div style="width: 40px; height: 20px; background-color: #e2e8f0; border-radius: 10px; position: relative; transition: background-color 0.3s;">
                        <div style="width: 16px; height: 16px; background-color: white; border-radius: 50%; position: absolute; top: 2px; left: 2px; transition: transform 0.3s;"></div>
                    </div>
                    <span style="margin-left: 8px; font-weight: 500; color: #4a5568;">{{ trans('Live Tour Expo') }}</span>
                </label>
            </div>
        </div>
        <!-- @if (config('core.base.general.enable_system_updater') && Auth::user()->isSuperUser())
                <v-check-for-updates
                    check-update-url="{{ route('system.check-update') }}"
                    v-slot="{ hasNewVersion, message }"
                    v-cloak
                >
                    <x-core::alert
                        v-if="hasNewVersion"
                        type="warning"
                    >
                        @{{ message }}, please go to <a
                            href="{{ route('system.updater') }}"
                            class="text-warning fw-bold"
                        >System Updater</a> to upgrade to the latest version!
                    </x-core::alert>
                </v-check-for-updates>
            @endif -->
    </div>

    <div class="col-12">
        {!! apply_filters(DASHBOARD_FILTER_ADMIN_NOTIFICATIONS, null) !!}
    </div>

    <div class="col-12">
        <div class="row row-cards">
            @foreach ($statWidgets as $widget)
            {!! $widget !!}
            @endforeach
        </div>
    </div>
</div>

<div class="mb-3 col-12">
    {!! apply_filters(DASHBOARD_FILTER_TOP_BLOCKS, null) !!}
</div>

<div class="col-12">
    <div
        id="list_widgets"
        class="row row-cards"
        data-bb-toggle="widgets-list">
        @foreach ($userWidgets as $widget)
        {!! $widget !!}
        @endforeach
    </div>
</div>
@endsection

@push('footer')
@include('core/dashboard::partials.modals', compact('widgets'))
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const expoToggle = document.querySelector("#headerExpoToggle");
        const toggleTrack = document.querySelector("#headerExpoToggle + label div");
        const toggleThumb = document.querySelector("#headerExpoToggle + label div div");

        function updateToggleAppearance(isEnabled) {
            if (isEnabled) {
                toggleTrack.style.backgroundColor = '#4299e1'; // Blue for enabled
                toggleThumb.style.transform = 'translateX(20px)';
            } else {
                toggleTrack.style.backgroundColor = '#e2e8f0'; // Gray for disabled
                toggleThumb.style.transform = 'translateX(0)';
            }
        }

        // Set initial state based on the checkbox value
        updateToggleAppearance(expoToggle.checked);

        expoToggle.addEventListener("change", function () {
            updateToggleAppearance(this.checked);
            console.log("Expo enabled:", this.checked);

            axios.post('/expos', {
                enabled: this.checked,
                expo_date: this.checked ? new Date().toISOString() : null
            }, {
                headers: {
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                }
            })
            .then(response => console.log(response.data))
            .catch(error => console.error('Error:', error));
        });
    });
</script>

@endpush