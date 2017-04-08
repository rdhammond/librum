mongoose = require 'mongoose'
validator = require 'validator'

toObjectId = (idStr) ->
	try
		[null, mongoose.Types.ObjectId idStr]
	catch err
		[err, null]

bookSchema = mongoose.Schema
	cover:
		type: Buffer
	coverMimeType:
		type: String
		minLength: 1
	smallCover:
		type: Buffer
	coverMimeType:
		type: String
		minLength: 1
	title:
		type: String
		required: yes
		minLength: 1
	author:
		type: String
		required: yes
		minLength: 1
	year:
		type: Number
		min: 1
	era:
		type: String
		enum: ['BCE', 'CE']
	publisher:
		type: String
		minLength: 1
	estValue:
		type: Number
		min: 0

bookSchema.statics.getPageCount = (limit) ->
	this.find {}
	.count()
	.then (total) -> Math.ceil (total/limit)

bookSchema.statics.getPage = (page, limit) ->
	page = page ? 0
	skip = (page-1) * limit
	skip = 0 if skip < 0
	limit = limit ? 0

	query = book.find {}, '_id,title,author,year,era,publisher,estValue'
	query = query.skip skip 
	query = query.limit limit if limit > 0
	query.exec()

bookSchema.statics.add = (bookInfo) ->
	delete bookInfo._id
	book = new Book bookInfo
	book.save()

bookSchema.statics.update = (bookInfo) ->
	this.findOneAndUpdate {_id: bookInfo.id}, {runValidators: yes, new: yes}, bookInfo

bookSchema.statics.delete = (id) ->
	[err, id] = toObject id
	return Promise.reject err if err?
	this.findOneAndRemove {_id: id}

bookSchema.statics.getCover = (id) ->
	this.findOne {_id:id}, 'cover,coverMimeType'
	.then (info) -> Promise.resolve info.cover, info.coverMimeType

bookSchema.statics.getSmallCover = (id) ->
	this.findOne {_id:id}, 'smallCover,smallCoverMimeType'
	.then (info) -> Promise.resolve info.smallCover, info.smallCoverMimeType

module.exports = Book = mongoose.model 'Book', bookSchema
