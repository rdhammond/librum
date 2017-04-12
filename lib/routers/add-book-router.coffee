express = require 'express'
expressValidator = require 'express-validator'
coverJimp = require '../cover-jimp'
multerSetup = require '../multer-setup'
nPromise = require '../nPromise'
Book = require '../models/Book'
router = express.Router()

multer = multerSetup().single 'fileupload'
validator = expressValidator()

validate = (req) ->
	req.checkBody('title').notEmpty()
	req.checkBody('author').notEmpty()
	req.checkBody('year').isInt {min: 1} if req.body.year
	req.checkBody('era').isIn ['CE', 'BCE'] if req.body.era
	req.checkBody('estValue').isFloat {min: 0} if req.body.estValue
	req.getValidationResult()

sanitizeBody = (req) ->
	title: req.sanitizeBody('title').escape().trim()
	author: req.sanitizeBody('author').escape().trim()
	year: req.sanitizeBody('year').toInt() if req.body.year
	era: req.sanitizeBody('era').escape().trim() if req.body.era
	publisher: req.sanitizeBody('publisher').escape().trim() if req.body.publisher
	estValue: req.sanitizeBody('estValue').toFloat() if req.body.estValue

router.get '/', (req, res) ->
	res.render 'add-book', {active: 'add-book'}

router.post '/', (req, res) ->
	nPromise multer, req, res
	.then () -> nPromise validator, req, res
	.then () -> validate req
	.then (results) ->
		console.log req.body
		return Promise.reject new Error 'One or more values are invalid.' if not results.isEmpty()
		coverJimp.getCoverBuffers req.file.buffer
	.then (result) ->
		bookInfo = sanitizeBody req
		bookInfo.cover = result.cover
		bookInfo.coverMimeType = result.coverMime
		bookInfo.thumbnail = result.thumb
		bookInfo.thumbnailMimeType = result.thumbMime
		Book.add bookInfo
	.then () ->
		res.render 'add-book',
			active: 'add-book'
			alertType: 'success'
			alertHeader: 'Added!'
			alertText: 'You can continue to add more books below.'
	.catch (err) ->
		console.log err
		res.render 'add-book',
			active: 'add-book'
			alertType: 'danger'
			alertHeader: 'Failed.'
			alertText: 'Check all your values and try again.'

module.exports = router
