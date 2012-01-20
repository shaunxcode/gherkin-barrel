jqrest = {}
for verb in ["get", "post", "put", "delete"] 
	do (verb) -> 
		jqrest[verb] = (url, params, cb) ->
			params or= {}
			
			if params.id 
				id = params.id
				delete params.id

			if _.isString(params) or _.isNumber(params)
				id = params
				params = false

			if id then url += '/' + encodeURI(id)
			
			params or= ""

			$.ajax
				url: url
				type: verb
				mimeType: "application/json"
				contentType: "application/json"
				data: if params and verb in ["post", "put"] then JSON.stringify params else params
				dataType: "json"
				success: cb

window.api = require '\\api.coffee'
api.setRestHandler jqrest
api.setApiBase 'api'

window.App = Ember.Application.create()

App.ToolbarView = Ember.View.create
	tagName: 'div'
	classNames: ['toolbar']
	templateName: 'toolbar'
	newFeatureButtonView: Ember.View.extend
		tagName: 'a' 
		templateName: 'button'
		classNames: ['button']
		name: 'New Feature'
		click: (evt) ->
			alert "Clicked on the button"


$ ->
	App.ToolbarView.append() 