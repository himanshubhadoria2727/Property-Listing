@extends('plugins/real-estate::themes.dashboard.userLayouts.userLayout')

@section('content')
    <div class="bg-white rounded-lg shadow-md overflow-hidden">
        <div class="border-b border-gray-200">
            <nav class="flex space-x-4 px-4 py-3">
                <!-- <button
                    id="profile-tab"
                    class="px-3 py-2 text-sm font-medium rounded-md text-gray-500 hover:text-gray-700 hover:bg-gray-100 aria-selected:bg-blue-50 aria-selected:text-blue-600"
                    aria-selected="{{ request()->tab == 'profile' || !request()->tab ? 'true' : 'false' }}"
                    data-tab="profile-tab-pane"
                >
                    {{ trans('plugins/real-estate::dashboard.sidebar_information') }}
                </button> -->
                <button
                    id="avatar-tab"
                    class="px-3 py-2 text-sm font-medium rounded-md text-gray-500 hover:text-gray-700 hover:bg-gray-100 aria-selected:bg-blue-50 aria-selected:text-blue-600"
                    aria-selected="{{ request()->tab == 'avatar' ? 'true' : 'false' }}"
                    data-tab="avatar-tab-pane"
                >
                    {{ trans('plugins/real-estate::dashboard.profile-picture') }}
                </button>
                <button
                    id="change-password-tab"
                    class="px-3 py-2 text-sm font-medium rounded-md text-gray-500 hover:text-gray-700 hover:bg-gray-100 aria-selected:bg-blue-50 aria-selected:text-blue-600"
                    aria-selected="{{ request()->tab == 'password' ? 'true' : 'false' }}"
                    data-tab="change-password-tab-pane"
                >
                    {{ trans('plugins/real-estate::dashboard.sidebar_change_password') }}
                </button>
                {!! apply_filters('account_settings_register_content_tabs', null) !!}
            </nav>
        </div>

        <div class="p-6">
            <div>
                <div id="profile-tab-pane" class="tab-pane {{ request()->tab == 'profile' || !request()->tab ? 'block' : 'hidden' }}">
                    {!! $profileForm !!}
                </div>
                <div id="avatar-tab-pane" class="tab-pane {{ request()->tab == 'avatar' ? 'block' : 'hidden' }}">
                    <div class="max-w-md mx-auto">
                        <div class="mb-4">
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                {{ trans('plugins/real-estate::dashboard.profile-picture') }}
                            </label>
                            <div class="mt-1 flex items-center">
                                <img src="{{ auth('account')->user()->avatar_url }}" alt="Profile Picture" class="w-32 h-32 rounded-full object-cover border border-gray-200">
                            </div>
                        </div>
                        <form action="{{ route('public.account.avatar') }}" method="POST" enctype="multipart/form-data" class="space-y-4">
                            @csrf
                            <div>
                                <label class="block text-sm font-medium text-gray-700">
                                    {{ trans('core/base::forms.choose_file') }}
                                </label>
                                <input type="file" name="avatar_file" accept="image/*" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                            </div>
                            <button type="submit" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                {{ trans('core/base::forms.save') }}
                            </button>
                        </form>
                    </div>
                </div>
                <div id="change-password-tab-pane" class="tab-pane {{ request()->tab == 'password' ? 'block' : 'hidden' }}">
                    {!! $changePasswordForm !!}
                </div>
                {!! apply_filters('account_settings_register_content_tab_inside', null) !!}
            </div>
        </div>
    </div>
@stop

@push('styles')
    <script src="https://cdn.tailwindcss.com"></script>
@endpush

@push('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching functionality
            const tabs = document.querySelectorAll('[data-tab]');
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    // Deactivate all tabs
                    tabs.forEach(t => {
                        t.setAttribute('aria-selected', 'false');
                        const paneId = t.getAttribute('data-tab');
                        document.getElementById(paneId).classList.add('hidden');
                        document.getElementById(paneId).classList.remove('block');
                    });
                    
                    // Activate clicked tab
                    this.setAttribute('aria-selected', 'true');
                    const paneId = this.getAttribute('data-tab');
                    document.getElementById(paneId).classList.remove('hidden');
                    document.getElementById(paneId).classList.add('block');
                });
            });
        });
    </script>
    {!! JsValidator::formRequest(\Botble\RealEstate\Http\Requests\SettingRequest::class) !!}
    {!! JsValidator::formRequest(\Botble\RealEstate\Http\Requests\UpdatePasswordRequest::class) !!}
@endpush