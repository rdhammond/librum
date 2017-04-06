mongoose = require 'mongoose'
config = require '../config'

mongoose.Promise = global.Promise
mongoose.connect config.mongo
module.exports = () -> mongoose
