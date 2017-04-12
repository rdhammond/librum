DEFAULT_PAGE_SIZE = 25

express = require 'express'
bodyParser = require 'body-parser'
Book = require '../models/Book'
router = express.Router()

urlencoded = bodyParser.urlencoded {extended: no}

router.get '/', (req, res, next) ->
	Book.getPage 0, DEFAULT_PAGE_SIZE
	.then (books, total) ->
		res.render 'books',
			active: 'books'
			page: 0
			startPage: 0
			endPage: Math.min 4, total-1
			books: books
	.catch (err) ->
		next err

router.post '/', urlencoded, (req, res, next) ->
	page = req.body.page ? 0
	
	Books.getPage page, DEFAULT_PAGE_SIZE
	.then (books, total) ->
		if page < 3
			startPage = 0
			endPage = Math.min 4, total-1
		else if total >= 5 and page > total-3
			startPage = total-5
			endPage = total-1
		else
			startPage = page-2
			endPage = page+2

		res.render 'books',
			active: 'books'
			page: page
			startPage: startPage
			endPage: endPage
			books: books
	.catch (err) ->
		next err

module.exports = router
