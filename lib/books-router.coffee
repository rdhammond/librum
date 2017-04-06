express = require 'express'
bodyParser = require 'body-parser'
Book = require './Book'
router = express.Router()

DEFAULT_PAGE_SIZE = 25

urlencoded = bodyParser.urlencoded {extended: no}

router.get '/', (req, res, next) ->
	pages = null

	Book.getPageCount DEFAULT_PAGE_SIZE
		.then (_pages) ->
			pages = _pages
			Book.getPage 0, DEFAULT_PAGE_SIZE
		.then (books) ->
			model =
				active: 'books'
				pageSize: DEFAULT_PAGE_SIZE
				pages: pages
				page: 0
				books: books
			res.render 'books', model
		.catch (err) ->
			next err

router.post '/', urlencoded, (req, res) ->
	req.body.page = req.body.page ? 0
	req.body.pageSize = req.body.pageSize ? DEFAULT_PAGE_SIZE

	model =
		active: 'books'
		pageSize: req.body.pageSize
		pages: Book.getPageCount req.body.pageSize
		page: req.body.page
		books: Book.getPage req.body.page, req.body.pageSize
	res.render 'books', model

module.exports = router
