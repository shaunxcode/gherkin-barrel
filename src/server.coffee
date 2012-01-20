http = require "http"
fs = require "fs"
url = require "url"
routes = require "./routes"
	
http.createServer((req, res) ->
	request = url.parse req.url, true
	console.log request.pathname
	filename = request.pathname.slice 1

	if filename.indexOf('api/') is 0
		params = request.query
		body = ''

		dispatch = -> 
			data = if body.length then JSON.parse body else {}

			params.id = false

			[_, route, params.id] = filename.split('/')

			console.log req.method, route, params, data

			next = (result) -> 
				console.log result
				if not result
					res.writeHead 500
					res.end()
				
				res.writeHead 200, {"Content-Type": "application/json"}
				res.write JSON.stringify(result)
				res.end()

			if routes[route]
				if req.method in ['POST', 'PUT']
					routes[route][req.method](params, data, next)
				else 
					routes[route][req.method](params, next)
		
		if req.method in ['POST', 'PUT']
			req.addListener 'data', (chunk) -> body += chunk
			req.addListener 'end', dispatch
		else 
			dispatch()
		
		return false

	try
		fs.realpathSync filename
	catch e
		res.writeHead 404
		res.end()

	contentType = "text/plain"

	if request.pathname.match ".js$"
		contentType = "text/javascript"
	if request.pathname.match ".html$"
		contentType = "text/html"

	fs.readFile filename, (err, data) ->
		if err
			res.writeHead 500
			res.end()
			return

		res.writeHead 200, {"Content-Type": contentType}
		res.write data 
		res.end()
).listen(1337, "127.0.0.1")