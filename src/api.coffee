restHandler = false
apiBase = '/'

exports.setRestHandler = (handler) ->
	restHandler = handler

exports.setApiBase = (base) ->
	apiBase = '/' + base + '/'

restVerb = (verb, path) -> 
	(params, cb) ->
		restHandler[verb] apiBase + path, params, cb

REST = (name, path) ->
	path or= name
	exports[name] = {}
	for label, verb of {get: 'get', post: 'post', put: 'put', del: 'delete'}
		exports[name][label] = restVerb verb, path

REST 'features'
REST 'scenarios'