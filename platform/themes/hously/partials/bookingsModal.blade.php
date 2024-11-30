
<div
    id="streamBookingModal"
    class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black bg-opacity-50">
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg w-11/12 md:w-2/3 lg:w-1/3 p-6">
        <h2 class="text-lg font-bold text-gray-800 dark:text-gray-200 mb-4">Live Stream Bookings</h2>
        <p class="text-gray-600 dark:text-gray-400 mb-6">Manage your live stream bookings here.</p>
        <div class="flex justify-end space-x-4">
            <button
                class="bg-gray-300 hover:bg-gray-400 text-gray-700 px-4 py-2 rounded-md"
                onclick="toggleModal('streamBookingModal')">
                Close
            </button>
            <a
                href="{{ route('user.show') }}"
                class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-md">
                View Bookings
            </a>
        </div>
    </div>
</div>