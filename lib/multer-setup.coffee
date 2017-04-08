Multer = require 'multer'

validMimeTypes = [
	'image/jpeg'
	'image/png'
	'image/gif'
]

multer = Multer
	storage: Multer.memoryStorage()
	limits:
		fileSize: 1024*1024
		files: 1
	fileFilter: (req, file, cb) ->
		cb null, validMimeTyeps.indexOf file.mimetype > -1

module.exports = () -> multer
