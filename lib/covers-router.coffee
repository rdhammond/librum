express = require 'express'
Book = require './Book'
router = express.Router()

router.get '/:id', (req, res, next) ->
	id = req.params.id
	Book.getCover id
	.then (cover, mimetype) ->
		res.writeHead 200,
			'Content-Type': mimetype
			'Content-length': cover.length
		res.end cover
	.catch (err) -> next err

router.get '/small/:id', (req, res, next) ->
	id = req.params.id
	Book.getSmallCover id
	.then (smallCover, mimetype) ->
		res.writeHead 200,
			'Content-Type': mimetype
			'Content-length': smallCover.length
		res.end smallCover
	.catch (err) -> next err

module.exports = router
