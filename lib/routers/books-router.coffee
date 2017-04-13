DEFAULT_PAGE_SIZE = 20

express = require 'express'
bodyParser = require 'body-parser'
Book = require '../models/Book'
router = express.Router()

urlencoded = bodyParser.urlencoded {extended: no}
json = bodyParser.json()

router.get '/', (req, res, next) ->
	total = null

	Book.getPageCount DEFAULT_PAGE_SIZE
	.then (_total) ->
		total = _total
		Book.getPage 0, DEFAULT_PAGE_SIZE
	.then (books) ->
		res.render 'books',
			active: 'books'
			page: 0
			startPage: 0
			endPage: Math.min 4, total-1
			books: books
	.catch (err) ->
		next err

router.post '/', urlencoded, (req, res, next) ->
	total = null
	page = req.body.page ? 0
	
	Book.getPageCount DEFAULT_PAGE_SIZE
	.then (_total) ->
		total = _total
		Book.getPage page, DEFAULT_PAGE_SIZE
	.then (books) ->
		if page < 3
			startPage = 0
			endPage = Math.min 4, total-1
		else if total >= 5 and page > total-3
			startPage = total-5
			endPage = total-1
		else
			startPage = page-2
			endPage = page+2

		console.log "#{startPage} #{page} #{endPage}"
		res.render 'books',
			active: 'books'
			page: page
			startPage: startPage
			endPage: endPage
			books: books
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
