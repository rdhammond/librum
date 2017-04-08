express = require 'express'
jimp = require 'jimp'
multerSetup = require '../multer-setup'
nPromise = require '../nPromise'
coverJimp = require '../cover-jimp'
Book = require '../models/Book'
router = express.Router()

single = multerSetup().single 'fileupload'

router.get '/:id', (req, res, next) ->
	id = req.params.id

	Book.getCover id
	.then (info) ->
		res.writeHead 200,
			'Content-Type': info.coverMimeTye
			'Content-length': info.cover.length
		res.end info.cover
	.catch (err) ->
		next err

router.get '/thumbnail/:id', (req, res, next) ->
	id = req.params.id

	Book.getThumbnail id
	.then (info) ->
		res.writeHead 200,
			'Content-Type': info.thumbnailMimeType
			'Content-length': info.thumbnail.length
		res.end info.thumbnail
	.catch (err) ->
		next err

router.post '/preview', (req, res, next) ->
	nPromise single, req, res
	.then () -> coverJimp.echoBase64 req.file.buffer
	.then (base64) -> res.json {img64: base64}
	.catch (err) -> res.json {error: err.message}

module.exports = router
