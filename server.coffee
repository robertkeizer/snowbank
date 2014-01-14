log	= require( "logging" ).from __filename
config	= require "config"
express	= require "express"

# Generic ODM class.
class generic_odm
	constructor: (@name) ->
		
	list: ( filters, cb ) ->
		cb null, "what?"

	create: ( doc, cb ) ->
		cb null

	delete: ( @_id, cb ) ->
		cb null

# Generate a ODM object based on the type specified.
gen_odm	= ( type, cb ) ->

	# sanity check on the type being requested.

	cb null, new generic_odm type

app = express( )

app.use express.logger( )
app.use express.compress( )
app.use express.cookieParser( )
app.use express.cookieSession( { "secret": "no" } )

# Handle the paramter 'type'.
app.param "type", ( req, res, cb, type ) ->

	gen_odm type, ( err, odm_obj ) ->
		if err
			return cb err

		req._type = odm_obj
		cb( )

app.get "/", ( req, res ) ->
	res.send "hi"

app.get "/list/:type", ( req, res ) ->
	req._type.list null, ( err, _res ) ->
		res.json _res

	res.end( )

app.listen config.api.port, ( ) ->
	log "listening on port #{config.api.port}."
