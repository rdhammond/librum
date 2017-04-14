DEFAULT_PAGE_SIZE = 20
SEARCH_LIMIT = 100

express = require 'express'
bodyParser = require 'body-parser'
Book = require '../models/Book'
router = express.Router()

urlencoded = bodyParser.urlencoded {extended: no}
json = bodyParser.json()

currentPage = (books, page) ->
	startIndex = DEFAULT_PAGE_SIZE * page
	total = Math.ceil (books.length/DEFAULT_PAGE_SIZE)
	books = books.slice startIndex, startIndex+DEFAULT_PAGE_SIZE

	if page < 3
		page = Math.max page, 0
		startPage = 0
		endPage = Math.min 4, total-1
	else if total >= 5 and page > total-3
		page = Math.min page, total-1
		startPage = total-5
		endPage = total-1
	else
		startPage = page-2
		endPage = page+2

	{
		active: 'books'
		page: page
		startPage: Math.max startPage, 0
		endPage: Math.min endPage, total-1
		books: books
	}

router.get '/', (req, res, next) ->
	total = null

	Book.search SEARCH_LIMIT
	.then (books) ->
		res.render 'books', (currentPage books, 0)
	.catch (err) ->
		next err

router.post '/', urlencoded, (req, res, next) ->
	total = null
	page = req.body.page ? 0
	keywords = (req.body.search ? '').split ' '
	
	Book.search keywords, SEARCH_LIMIT
	.then (books) ->
		model = currentPage books, page
		model.search = req.body.search
		res.render 'books', model
	.catch (err) ->
		next err

router.post '/notes/:id', json, (req, res) ->
	Book.setNotes req.params.id, req.body.notes
	.then () -> res.json {}
	.catch (err) ->
		res.json
			header: 'Save failed.'
			text: err.message

module.exports = router
