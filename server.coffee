log	= require( "logging" ).from __filename
config	= require "config"
express	= require "express"

app = express( )

app.use express.logger( )

app.param "type", ( req, res, cb, type ) ->
	req._type = type
	cb( )

app.get "/", ( req, res ) ->
	res.send "hi"

app.get "/list/:type", ( req, res ) ->
	res.json req._type

app.listen config.api.port, ( ) ->
	log "listening on port #{config.api.port}."
