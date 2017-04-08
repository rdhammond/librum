COVER_WIDTH = 200
COVER_HEIGHT = 300
THUMBNAIL_SCALE = 0.5

jimp = require 'jimp'
nPromise = require './nPromise'

getCoverBuffers = (buffer) ->
	Promise.all [
		read buffer, 1
		read buffer, THUMBNAIL_SCALE
	]
	.then (imgs) ->
		Promise.all [
			toBuffer imgs[0]
			Promise.resolve imgs[0].getMIME()
			toBuffer imgs[1]
			Promise.resolve imgs[1].getMIME()
		]
	.then (res) ->
		Promise.resolve res[0], res[1], res[2], res[3]

echoBase64 = (buffer) ->
	read buffer, 1
	.then (img) -> nPromise img, img.getBase64, jimp.AUTO

read = (buffer, scale) ->
	scale = scale ? 1
	jimp.read buffer
	.then (img) -> img.contain COVER_WIDTH*scale, COVER_HEIGHT*scale

module.exports = {
	getCoverBuffers
	echoBase64
}
