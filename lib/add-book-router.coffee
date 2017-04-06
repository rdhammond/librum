express = require 'express'
bodyParser = require 'body-parser'
Multer = require 'multer'
jimp = require 'jimp'

urlencoded = bodyParser.urlencoded {extended: no}
router = express.Router()

validMimeTypes = [
	'image/jpeg',
	'image/png',
	'image/gif'
]

multer = Multer
	storage: Multer.memoryStorage()
	dest: "#{__dirname}/public/upload/temp"
	limits:
		fileSize: 1024*1024
		files: 1
	fileFilter: (req, file, cb) ->
		cb null, validMimeTypes.indexOf file.mimetype > -1

single = multer.single 'fileupload'

router.get '/', (req, res) ->
	res.render 'add-book', {active: 'add-book'}

router.post '/', urlencoded, (req, res) ->
	# ** TODO: Verify
	# ** TODO: Save file
	# ** TODO: Save book
	#
	res.render 'add-book',
		active: 'add-book',
		alertType: 'Success',
		alertHeader: 'Book added.',
		alertMsg: 'You can continue to add more books below.'

router.post '/preview-cover', single, (req, res) ->
	if not req.file?
		return res.json
			error: 'Maybe it was too big? Try to keep it under one meg!'

	jimp.read req.file.buffer, (err, img) ->
		return res.json { error: 'Not a valid image.' } if not img? or err?

		img.getBase64 img._originalMime, (err, base64) ->
			if err?
				return res.json
					error: 'Something went wrong processing the image. Try again in a bit.'

			res.json {img64: base64}

module.exports = router
