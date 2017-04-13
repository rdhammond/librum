(function($) {
	'use strict';

	function goPrevious() {
		var page = $('.pagination .active .page').data('page');
		goTo(page-1);
		return false;
	}

	function goNext() {
		var page = $('.pagination .active .page').data('page');
		goTo(page+1);
		return false;
	}

	function goPage() {
		goTo($(this).data('page'));
		return false;
	}

	function goTo(page) {
		$('#page').val(page);
		$('#pageForm').submit();
	}

	function showDetails() {
		var details = getDetails($(this));
		loadDetails(details);
		$('#bookDetails').modal('show');
	}

	function getDetails($row) {
		var $year = $row.find('.year');

		return {
			id: $row.data('id'),
			title: $row.find('.title').text(),
			coverUrl: $row.find('.cover img').data('coverUrl'),
			author: $row.find('.author').text(),
			publisher: $year.data('publisher'),
			year: $year.text(),
			estValue: $row.find('.estValue').text(),
			notes: $row.data('notes')
		};
	}

	function textSearch(keywords) {
		return 'https://www.google.com/?q=intext%3A%22'
			 + keywords + '%22';
	}

	function loadDetails(details) {
		$('#bookDetails').data('id', details.id);
		$('#title').text(details.title);
		$('#cover').attr('src', details.coverUrl);
		$('#author').text(details.author);
		$('#publisher').text(details.publisher);
		$('#year').text(details.year);
		$('#estValue').text(details.estValue);
		$('#googleTitle').attr('href', textSearch(details.title));
		$('#googleAuthor').attr('href', textSearch(details.author));

		var $notes = $('#notes');
		$notes.data('originalText', details.notes || '');
		$notes.text(details.notes || '');

		var $button = $('#save-and-close');
		$button.data('save', false);
		$button.text('Close');
	}

	function changeButtonText() {
		var $this = $(this);
		var $button = $('#save-and-close');

		if ($this.val() !== $this.data('originalText')) {
			$button.data('save', true)
			$button.text('Save and Close');

			$button.removeClass('btn-default')
				.addClass('btn-primary')
		}
		else {
			$button.data('save', false)
			$button.text('Close');

			$button.removeClass('btn-primary')
				.addClass('btn-default');
		}
	}

	function saveAndClose() {
		var $this = $(this);
		var $modal = $('#bookDetails');
		
		if (!$this.data('save')) {
			$modal.modal('hide');
			return;
		}

		$.ajax({
			contentType: 'application/json',
			data: JSON.stringify({ notes: $('#notes').val() }),
			method: 'POST',
			url: '/books/notes/' + $('#bookDetails').data('id'),
			success: finishSave,
			error: function() {
				showError('Oh no!', 'Something went wrong and your changes weren\'t saved.');
			}
		});
	}

	function finishSave(result) {
		if (result.error) {
			showError(result.error.header, result.error.msg);
			return;
		}

		var $modal = $('#bookDetails');

		$('#books tr[data-id=' + $modal.data('id') + ']')
			.data('notes', $('#notes').val());

		$modal.modal('hide');
	}

	function showError(header, msg) {
		var $alert = $('#alert');
		$alert.children('.header').text(header + ' ')
		$alert.children('.msg').text(msg);
		$alert.removeClass('hidden');
		$('#bookDetails').modal('hide');
	}

	$(function() {
		$('.prev').click(goPrevious);
		$('.next').click(goNext);
		$('.page').click(goPage);
		$('#books tr').click(showDetails);
		$('#notes').on('input', changeButtonText);
		$('#save-and-close').click(saveAndClose);
	});

})(jQuery);
