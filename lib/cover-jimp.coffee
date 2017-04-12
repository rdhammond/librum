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
			nPromise imgs[0], imgs[0].getBuffer, jimp.AUTO
			Promise.resolve imgs[0]._originalMime
			nPromise imgs[1], imgs[1].getBuffer, jimp.AUTO
			Promise.resolve imgs[1]._originalMime
		]
	.then (res) ->
		Promise.resolve 
			cover: res[0]
			coverMime: res[1]
			thumb: res[2]
			thumbMime: res[3]

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
