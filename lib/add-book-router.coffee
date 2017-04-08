express = require 'express'
expressValidator = require 'express-validator'
Multer = require 'multer'
jimp = require 'jimp'
router = express.Router()

validMimeTypes = [
	'image/jpeg',
	'image/png',
	'image/gif'
]

multer = Multer
	storage: Multer.memoryStorage()
	limits:
		fileSize: 1024*1024
		files: 1
	fileFilter: (req, file, cb) ->
		cb null, validMimeTypes.indexOf file.mimetype > -1

single = multer.single 'fileupload'
validator = expressValidator()

nPromise = (obj, func, args...) ->
	if typeof obj is 'function'
		args.unshift func
		func = obj
		obj = null

	new Promise (resolve, reject) ->
		args.push (err, res) ->
			return reject err if err?
			return resolve res
		func.apply obj, args

validate = (req) ->
	req.validateBody('title').notEmpty()
	req.validateBody('author').notEmpty()
	req.validateBody('year').isInt {min: 1}
	req.validateBody('era').isIn ['CE', 'BCE']
	req.validateBody('estValue').isFloat {min: 0}
	req.getValidationResult()

getCovers = (file) ->
	jimp.read file.buffer
	.then (img) -> img.contain 200, 300
	.then (cover) ->
		smallCover = cover.clone()
		Promise.all [
			Promise.resolve cover
			nPromise smallCover, smallCover.contain, 100, 150
		]
		.then (res) -> Promise.resolve res[0], res[1]

sanitizeBody = (req) ->
	title: req.sanitizeBody('title').escape().trim()
	author: req.sanitizeBody('author').escape().trim()
	year: req.sanitizeBody('year').toInt()
	era: req.sanitizeBody('era').escape().trim()
	publisher: req.sanitizeBody('publisher').escape().trim()
	estValue = req.sanitizeBody('estValue').toFloat()

router.get '/', (req, res) ->
	res.render 'add-book', {active: 'add-book'}

router.post '/', (req, res) ->
	nPromise single, req, res
	.then () -> nPromise validator, req, res
	.then () -> validate req
	.then (results) ->
		return Promise.reject new Error 'One or more values are invalid.' if not results.isEmpty()
		getCovers req.file
	.then (cover, smallCover) ->
		Promise.all [
			nPromise cover, cover.getBuffer, jimp.AUTO
			nPromise smallCover, smallCover.getBuffer, jimp.AUTO
		]
		.then (results) -> Promise.resolve results[0], results[1]
	.then (covBuf, smallCovBuf) ->
		bookInfo = sanitizeBody req
		[bookInfo.cover, bookInfo.smallCover] = [covBuf, smallCovBuf]
		Book.add bookInfo
	.then () ->
		res.render 'add-book',
			active: 'add-book'
			alertType: 'success'
			alertHeader: 'Added!'
			alertText: 'You can continue to add more books below.'
	.catch (err) ->
		res.render 'add-book',
			active: 'add-book'
			alertType: 'danger'
			alertHeader: 'Failed.'
			alertText: 'Check all your values and try again.'

router.post '/preview-cover', (req, res) ->
	nPromise single, req, res
	.then () -> getCovers req.file
	.then (cover, smallCover) -> nPromise cover, cover.getBase64, jimp.AUTO
	.then (base64) -> res.json {img64: base64}
	.catch (err) ->
		console.log err
		res.json {error: err.message}

module.exports = router
