log	= require( "logging" ).from __filename
config	= require "config"
express	= require "express"

app = express( )

app.get "/", ( req, res ) ->
	res.send "hi"

app.listen config.api.port
