<?php

namespace Botble\RealEstate\Http\Controllers;

use Botble\Base\Facades\Assets;
use Botble\Base\Facades\BaseHelper;
use Botble\RealEstate\Exports\PropertyTemplateExport;
use Botble\RealEstate\Http\Requests\BulkImportRequest;
use Botble\RealEstate\Http\Requests\ImportPropertyRequest;
use Botble\RealEstate\Imports\PropertiesImport;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Excel;
use Maatwebsite\Excel\Validators\ValidationException;

class PropertyImportController extends BaseController
{
    public function __construct()
    {
        parent::__construct();

        $this
            ->breadcrumb()
            ->add(trans('plugins/real-estate::property.name'), route('property.index'))
            ->add(trans('plugins/real-estate::property.import_properties'), route('import-properties.index'));
    }

    public function index(PropertyTemplateExport $export)
    {
        $this->pageTitle(trans('plugins/real-estate::property.import_properties'));

        Assets::addScriptsDirectly('vendor/core/plugins/real-estate/js/bulk-import.js');

        $properties = $export->collection();
        $headings = $export->headings();
        $rules = $export->rules();

        return view('plugins/real-estate::import.property', compact('properties', 'headings', 'rules'));
    }

    public function store(BulkImportRequest $request, PropertiesImport $propertiesImport)
    {
        BaseHelper::maximumExecutionTimeAndMemoryLimit();

        try {
            $propertiesImport->validator(ImportPropertyRequest::class)->import($request->file('file'));

            $message = trans('plugins/real-estate::import.import_success_message');

            return $this
                ->httpResponse()
                ->setData([
                    'message' => $message . ' ' . trans('plugins/real-estate::import.results', [
                            'success' => $propertiesImport->successes()->count(),
                            'failed' => $propertiesImport->failures()->count(),
                        ]),
                ])
                ->setMessage($message);
        } catch (ValidationException $e) {
            return $this
                ->httpResponse()
                ->setError()
                ->setData($e->failures())
                ->setMessage(trans('plugins/real-estate::import.import_failed_message'));
        }
    }

    public function downloadTemplate(Request $request, PropertyTemplateExport $export)
    {
        $request->validate([
            'extension' => 'required|in:csv,xlsx',
        ]);

        $extension = Excel::XLSX;
        $contentType = 'text/xlsx';

        if ($request->input('extension') === 'csv') {
            $extension = Excel::CSV;
            $contentType = 'text/csv';
        }

        $fileName = 'template_properties_import.' . $extension;

        return $export->download($fileName, $extension, ['Content-Type' => $contentType]);
    }
}
