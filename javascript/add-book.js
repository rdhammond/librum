(function($) {
	'use strict';

	function clearError() {
		$('#alert').hide();
	}

	function showError(header, msg) {
		if (typeof(msg) === 'undefined') {
			msg = header;
			header = null;
		}

		if (header)
			msg = ' ' + msg;
		
		var $alert = $('#alert');
		$alert.removeClass().addClass('alert').addClass('alert-danger');
		$alert.children('.header').text(header || '');
		$alert.children('.msg').text(msg || '');
		$alert.removeClass('hidden');
	}

	function showPreview(resp) {
		if (resp.error) {
			showError('Upload failed.', resp.error);
			return;
		}
		$('#cover').attr('src', resp.img64);
		clearError();
	}

	function uploadPreview() {
		var data = new FormData();
		data.append('fileupload', fileupload.files[0]);

		$.ajax({
			url: '/add-book/preview-cover',
			type: 'POST',
			data: data,
			cache: false,
			contentType: false,
			processData: false,
			success: showPreview,
			error: function() {
				showError('Uh oh.', 'Something went wrong uploading to the server.');
			}
		});
	}

	$(function() {
		$('#selectfile').click(function() {
			$('#fileupload').click();
		});
		$('#fileupload').change(uploadPreview);
	});

})(jQuery);
