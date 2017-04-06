(function($) {
	'use strict';

	function showDetails() {
		var details = getDetails.call(this);
		loadDetails(details);
		$('#bookDetails').modal('show');
	}

	function getDetails() {
		var $this = $(this);
		var $year = $this.find('.year');

		return {
			title: $this.find('.title').text(),
			coverUrl: $this.find('.cover img').data('coverUrl'),
			author: $this.find('.author').text(),
			publisher: $year.data('publisher'),
			year: $year.text(),
			estValue: $this.find('.estValue').text(),
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
		$('#searchTitle').attr('href', textSearch(details.title));
		$('#searchAuthor').attr('href', textSearch(details.author));
	}

	$(function() {
		$('#books tr').click(showDetails);
		$('#searchTitle').click(searchTitle);
		$('#searchAuthor').click(searchAuthor);
	});

})(jQuery);
