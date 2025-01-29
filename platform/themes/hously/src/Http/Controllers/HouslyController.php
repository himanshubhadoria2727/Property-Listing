<?php

namespace Theme\Hously\Http\Controllers;

use Botble\Base\Http\Responses\BaseHttpResponse;
use Botble\Location\Repositories\Interfaces\CityInterface;
use Botble\RealEstate\Repositories\Interfaces\ProjectInterface;
use Botble\RealEstate\Repositories\Interfaces\PropertyInterface;
use Botble\Theme\Facades\Theme;
use Illuminate\Support\Facades\Log;
use Botble\Theme\Http\Controllers\PublicController;
use Botble\Location\Models\City;
use Illuminate\Http\Request;
use Theme\Hously\Http\Resources\ProjectResource;
use Theme\Hously\Http\Resources\PropertyResource;

class HouslyController extends PublicController
{
    public function getAjaxCities(Request $request, CityInterface $cityRepository, BaseHttpResponse $response)
    {
        if (! $request->ajax()) {
            abort(404);
        }

        $location = $request->input('location');

        $locations = $cityRepository->filters($location);
        $locations->loadMissing('state');

        return $response->setData(Theme::partial('filters.location-suggestion', compact('locations')));
    }

    public function getAjaxRegions(Request $request)
{
    Log::info('Fetching regions for city in api: ' . $request->query('city'));

    try {
        $cityName = $request->query('city');

        // Check if the city parameter is provided
        if (!$cityName) {
            Log::warning('City parameter is required');
            return response()->json([
                'success' => false,
                'message' => 'City parameter is required',
                'regions' => []
            ], 400);
        }

        // Find the city by name
        $city = City::where('name', $cityName)->first();

        // Check if the city exists
        if (!$city) {
            Log::warning('City not found');
            return response()->json([
                'success' => false,
                'message' => 'City not found',
                'regions' => []
            ], 404);
        }

        // Assuming the regions are stored in a column named 'regions' as a JSON array
        $regions = $city->regions;

        Log::info('Regions fetched successfully');

        return response()->json([
            'success' => true,
            'regions' => $regions
        ]);

    } catch (\Exception $e) {
        Log::error('Error fetching regions: ' . $e->getMessage());
        return response()->json([
            'success' => false,
            'message' => 'Error fetching regions',
            'regions' => []
        ], 500);
    }
}

    public function ajaxGetPropertiesFeaturedForMap(BaseHttpResponse $response)
    {
        $properties = app(PropertyInterface::class)->advancedGet([
            'condition' => [
                'is_featured' => true,
            ],
            'paginate' => [
                'per_page' => 12,
                'current_paged' => 1,
            ],
        ]);

        return $response
            ->setData(PropertyResource::collection($properties))
            ->toApiResponse();
    }

    public function ajaxGetPropertiesForMap(Request $request, BaseHttpResponse $response)
    {
        $filters = [
            'keyword' => $request->input('keyword'),
            'type' => $request->input('type'),
            'bedroom' => $request->input('bedroom'),
            'bathroom' => $request->input('bathroom'),
            'floor' => $request->input('floor'),
            'min_price' => $request->input('min_price'),
            'max_price' => $request->input('max_price'),
            'min_square' => $request->input('min_square'),
            'max_square' => $request->input('max_square'),
            'project' => $request->input('project'),
            'category_id' => $request->input('category_id'),
            'city' => $request->input('city'),
            'city_id' => $request->input('city_id'),
            'location' => $request->input('location'),
        ];

        $params = [
            'paginate' => [
                'per_page' => 20,
                'current_paged' => (int)$request->input('page', 1),
            ],
        ];

        $properties = app(PropertyInterface::class)->getProperties($filters, $params);

        return $response
            ->setData(PropertyResource::collection($properties))
            ->toApiResponse();
    }

    public function ajaxGetProjectsForMap(Request $request, BaseHttpResponse $response)
    {
        $filters = [
            'keyword' => $request->input('keyword'),
            'type' => $request->input('type'),
            'bedroom' => $request->input('bedroom'),
            'bathroom' => $request->input('bathroom'),
            'floor' => $request->input('floor'),
            'min_price' => $request->input('min_price'),
            'max_price' => $request->input('max_price'),
            'min_square' => $request->input('min_square'),
            'max_square' => $request->input('max_square'),
            'project' => $request->input('project'),
            'category_id' => $request->input('category_id'),
            'city' => $request->input('city'),
            'city_id' => $request->input('city_id'),
            'location' => $request->input('location'),
        ];

        $params = [
            'paginate' => [
                'per_page' => 20,
                'current_paged' => (int)$request->input('page', 1),
            ],
        ];

        $properties = app(ProjectInterface::class)->getProjects($filters, $params);

        return $response
            ->setData(ProjectResource::collection($properties))
            ->toApiResponse();
    }

    public function ajaxGetProjectsFilter(Request $request, BaseHttpResponse $response, ProjectInterface $projectRepository)
    {
        if (! $request->ajax()) {
            abort(404);
        }

        $request->validate([
            'project' => 'nullable|string',
        ]);

        $keyword = $request->input('project');

        $projects = $projectRepository->advancedGet([
            'condition' => [
                ['name', 'LIKE', '%' . $keyword . '%'],
            ],
            'select' => ['id', 'name'],
            'take' => 10,
            'order_by' => ['name' => 'ASC'],
        ]);

        return $response->setData(Theme::partial('filters.projects-suggestion', compact('projects')));
    }
}
