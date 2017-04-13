express = require 'express'
csp = require 'helmet-csp'
morgan = require 'morgan'
config = require './config'
setupMongoose = require './lib/setup-mongoose'

homeRouter = require './lib/routers/home-router'
booksRouter = require './lib/routers/books-router'
addBookRouter = require './lib/routers/add-book-router'
coversRouter = require './lib/routers/covers-router'

setupMongoose()

app = express();
app.set 'view engine', 'pug'
app.set 'views', "#{__dirname}/views"
app.use morgan 'tiny'

# Maybe? "'unsafe-inline'",
app.use csp
	directives:
		scriptSrc: [
			"'self'",
			"'unsafe-inline'",
			'data: https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js '+
				'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'
		]

app.use express.static "#{__dirname}/public"
app.use '/', homeRouter
app.use '/books', booksRouter
app.use '/add-book', addBookRouter
app.use '/covers', coversRouter

app.listen config.port, () ->
	console.log "Listening on port #{config.port}"
