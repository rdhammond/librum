mongoose = require 'mongoose'
types = require '../types'

MAX_PAGES = 10

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
	thumbnail:
		type: Buffer
	thumbnailMimeType:
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
	notes:
		type: String

Object.assign bookSchema.statics,
	search: (keywords, limit) ->
		criteria = {}

		if (types.getType keywords) isnt 'Array'
			limit = keywords
			keywords = []
		
		if keywords?.length > 0
			tokens = keywords.map (x) -> "#{x}"
			regex = new RegExp (tokens.join '|'), 'i'
			criteria =
				$or: [
					{title: regex}
					{author: regex}
					{publisher: regex}
				]

		query = this.find(criteria).lean()
		query = query.limit limit if limit? > 0
		query.exec()

	add: (bookInfo) ->
		delete bookInfo._id
		book = new Book bookInfo
		book.save()

	update: (bookInfo) ->
		this.findOneAndUpdate {_id: bookInfo.id},
			{runValidators: yes, new: yes},
			bookInfo

	delete: (id) ->
		[err, id] = toObject id
		return Promise.reject err if err?
		this.findOneAndRemove {_id: id}

	getCover: (id) ->
		this.findOne {_id: id}, 'cover coverMimeType'

	getThumbnail: (id) ->
		this.findOne {_id: id}, 'thumbnail thumbnailMimeType'

	setNotes: (id, notes) ->
		this.findOneAndUpdate {_id: id}, {notes: notes}
		

module.exports = Book = mongoose.model 'Book', bookSchema
