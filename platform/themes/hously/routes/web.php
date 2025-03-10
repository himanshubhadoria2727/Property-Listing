<?php

use Botble\Theme\Facades\Theme;
use Illuminate\Support\Facades\Route;
use Theme\Hously\Http\Controllers\HouslyController;
use Illuminate\Support\Facades\Broadcast;

Route::group(
    ['controller' => HouslyController::class, 'as' => 'public.', 'middleware' => ['web', 'core']],
    function () {
        Route::group(apply_filters(BASE_FILTER_GROUP_PUBLIC_ROUTE, []), function () {
            Route::get('ajax/cities', 'getAjaxCities')->name('ajax.cities');
            Route::get('ajax/regions', 'getAjaxRegions')->name('ajax.regions');
            Route::get('ajax/featured-properties-for-map', 'ajaxGetPropertiesFeaturedForMap')->name('ajax.featured-properties-for-map');
            Route::get('ajax/properties/map', 'ajaxGetPropertiesForMap')->name('ajax.properties.map');
            Route::get('ajax/projects/map', 'ajaxGetProjectsForMap')->name('ajax.projects.map');
            Route::get('ajax/projects-filter', 'ajaxGetProjectsFilter')->name('ajax.projects-filter');
        });
    }
);

Broadcast::routes(['middleware' => ['auth:account']]);

// Route::post('/broadcasting/auth', function () {
//     return Broadcast::auth(request());
// });

Theme::routes();
