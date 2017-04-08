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
		var details = getDetails($this);
		loadDetails(details);
		$('#bookDetails').modal('show');
	}

	function getDetails($row) {
		var $year = $row.find('.year');

		return {
			title: $row.find('.title').text(),
			coverUrl: $row.find('.cover img').data('coverUrl'),
			author: $row.find('.author').text(),
			publisher: $year.data('publisher'),
			year: $year.text(),
			estValue: $row.find('.estValue').text(),
		};
	}

	function textSearch(keywords) {
		return 'https://www.google.com/?q=intext%3A%22'
			 + keywords + '%22';
	}

	function loadDetails(details) {
		$('#title').text(details.title);
		$('#cover').attr('src', details.coverUrl);
		$('#author').text(details.author);
		$('#publisher').text(details.publisher);
		$('#year').text(details.year);
		$('#estValue').text(details.estValue);
		$('#googleTitle').attr('href', textSearch(details.title));
		$('#googleAuthor').attr('href', textSearch(details.author));
	}

	$(function() {
		$('.prev').click(goPrevious);
		$('.next').click(goNext);
		$('.page').click(goPage);
		$('#books tr').click(showDetails);
		$('#googleTitle').click(searchTitle);
		$('#googleAuthor').click(searchAuthor);
	});

})(jQuery);
