module.exports = (obj, func, args...) ->
	if typeof obj is 'function'
		args.unshift func
		func = obj
		obj = null
	
	new Promise (resolve, reject) ->
		args.push (err, res) ->
			return reject err if err?
			return resolve res
		func.apply obj, args
