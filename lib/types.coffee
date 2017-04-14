filterType = /\[object ([^\]]+)\]/i

module.exports =
	getType: (obj) ->
		rawType = Object.prototype.toString.call obj
		(filterType.exec rawType)[1]
