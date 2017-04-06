express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
	# ** TODO:
	model =
		active: 'books'
		page: 0
		pages: 3
		books: [{
			smallCoverUrl: 'img/generic-book-small.jpg'
			coverUrl: 'img/generic-book.jpg'
			title: 'Spiffy Book'
			author: 'A. Spiffy Guy'
			year: '1996'
			publisher: 'Spiffy Books Ltd.'
			estValue: '$1,384.69'
		}]
	res.render 'books', model

module.exports = router
