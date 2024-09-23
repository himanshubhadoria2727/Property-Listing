<?php

namespace Botble\RealEstate\Http\Controllers;

use Botble\Base\Facades\Assets;
use Botble\Base\Facades\BaseHelper;
use Botble\RealEstate\Exports\ProjectTemplateExport;
use Botble\RealEstate\Http\Requests\BulkImportRequest;
use Botble\RealEstate\Http\Requests\ImportProjectRequest;
use Botble\RealEstate\Imports\ProjectsImport;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Excel;
use Maatwebsite\Excel\Validators\ValidationException;

class ProjectImportController extends BaseController
{
    public function __construct()
    {
        parent::__construct();

        $this
            ->breadcrumb()
            ->add(trans('plugins/real-estate::project.name'), route('project.index'))
            ->add(trans('plugins/real-estate::project.import_projects'), route('import-projects.index'));
    }

    public function index(ProjectTemplateExport $export)
    {
        $this->pageTitle(trans('plugins/real-estate::project.import_projects'));

        Assets::addScriptsDirectly('vendor/core/plugins/real-estate/js/bulk-import.js');

        $projects = $export->collection();
        $headings = $export->headings();
        $rules = $export->rules();

        return view('plugins/real-estate::import.project', compact('projects', 'headings', 'rules'));
    }

    public function store(BulkImportRequest $request, ProjectsImport $projectsImport)
    {
        BaseHelper::maximumExecutionTimeAndMemoryLimit();

        try {
            $projectsImport->validator(ImportProjectRequest::class)->import($request->file('file'));

            $message = trans('plugins/real-estate::import.import_success_message');

            return $this
                ->httpResponse()
                ->setData([
                    'message' => $message . ' ' . trans('plugins/real-estate::import.results', [
                        'success' => $projectsImport->successes()->count(),
                        'failed' => $projectsImport->failures()->count(),
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

    public function downloadTemplate(Request $request, ProjectTemplateExport $export)
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
