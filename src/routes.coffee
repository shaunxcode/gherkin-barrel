fs = require 'fs'
cukeConfig = require('cucumber/lib/cucumber/cli/configuration')
cukeRuntime = require('cucumber/lib/cucumber/Runtime')

exports.features = 
	GET: (params, next) ->
		if params.id 
			next({field: "Get a feature by #{params.id}"})
		else
			self = @
			@.visitFeature = -> 
				console.log 'inner call with', arguments
				
			cukeRuntime(cukeConfig(process.argv)).getFeatures().acceptVisitor self, -> 
				console.log 'called with', arguments

			files = []
			next(files)

	PUT: (params, data, next) ->
		next(params)
			
	POST: (params, data, next) ->
		next(params)