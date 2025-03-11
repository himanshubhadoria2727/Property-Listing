'use strict';

$(document).ready(function() {
    const bhkTypes = [
        { id: '1', label: '1' },
        { id: '2', label: '2' },
        { id: '2_5', label: '2.5' },
        { id: '3', label: '3' },
        { id: '3_5', label: '3.5' },
        { id: '4', label: '4' },
        { id: '4_5', label: '4.5' },
        { id: '5', label: '5' }
    ];

    function createBhkDetailsForm() {
        const detailsSection = $('#bhk-details-section');
        detailsSection.empty();

        let selectedBhkCount = 0;
        bhkTypes.forEach(bhk => {
            const checkbox = $(`#has_${bhk.id}_bhk`);
            if (checkbox.length && checkbox.prop('checked')) {
                selectedBhkCount++;
            }
        });

        // Show/hide max fields based on BHK selection
        const maxSquareWrapper = $('[name="max_square"]').closest('.form-group');
        const maxPriceWrapper = $('[name="max_price"]').closest('.form-group');

        if (selectedBhkCount > 1) {
            maxSquareWrapper.removeClass('hidden');
            maxPriceWrapper.removeClass('hidden');
        } else {
            maxSquareWrapper.addClass('hidden');
            maxPriceWrapper.addClass('hidden');
        }

        if (detailsSection.children().length > 0) {
            detailsSection.prepend('<hr class="my-4">');
        }

        // Update labels for square and price fields based on BHK selection
        const mainSquareLabel = $('[name="square"]').closest('.form-group').find('label');
        const mainPriceLabel = $('[name="price"]').closest('.form-group').find('label');
        const originalSquareText = mainSquareLabel.data('original-text') || mainSquareLabel.text();
        const originalPriceText = mainPriceLabel.data('original-text') || mainPriceLabel.text();

        // Store original text if not already stored
        if (!mainSquareLabel.data('original-text')) {
            mainSquareLabel.data('original-text', originalSquareText);
        }
        if (!mainPriceLabel.data('original-text')) {
            mainPriceLabel.data('original-text', originalPriceText);
        }

        // Update labels based on BHK selection
        if (selectedBhkCount > 1) {
            mainSquareLabel.text('Minimum ' + originalSquareText);
            mainPriceLabel.text('Minimum ' + originalPriceText);
        } else {
            mainSquareLabel.text(originalSquareText);
            mainPriceLabel.text(originalPriceText);
        }

        // Reinitialize input mask for price fields
        $('.input-mask-number').inputmask({
            alias: 'numeric',
            groupSeparator: ',',
            digits: 0,
            digitsOptional: false,
            prefix: '',
            placeholder: '0',
        });
    }

    // Watch for changes in BHK checkboxes
    bhkTypes.forEach(bhk => {
        $(`#has_${bhk.id}_bhk`).on('change', createBhkDetailsForm);
    });

    // Initial form creation
    createBhkDetailsForm();
}); 