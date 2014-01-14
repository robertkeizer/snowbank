log	= require( "logging" ).from __filename
config	= require "config"
express	= require "express"

# Generic ODM class.
class generic_odm
	constructor: (@type, @database) ->
		
	list: ( filters, cb ) ->
		cb null, "what?"

	create: ( doc, cb ) ->
		cb null

	delete: ( _id, cb ) ->

		# Allow an ID to be specified. If
		# it isn't, use @_id.
		if not cb
			cb	= _id
			_id	= @_id
		
		# use _id to remove the document..
		cb null

	update: ( _id, doc, cb ) ->

		# Allow for an optional ID to be
		# specified.
		if not cb
			cb	= doc
			doc	= _id
			_id	= @_id

		# Update document with id _id to have
		# the contents of doc
			
		cb null

# Generate a ODM object based on the type specified.
gen_odm	= ( type, cb ) ->

	# sanity check on the type being requested.

	cb null, new generic_odm type, config.database

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

		req._doc = odm_obj
		cb( )

app.param "id", ( req, res, cb, id ) ->
	# If a type object is already
	# defined, then fill in the ID.
	if req._doc
		req._doc._id = id

	req._id = id
	cb( )

app.get "/", ( req, res ) ->
	res.send "hi"

app.get "/list/:type", ( req, res ) ->
	req._doc.list null, ( err, _res ) ->
		res.json _res

	res.end( )

app.get "/create/:type", ( req, res ) ->
	# parse the body for the object properties..
	# TODO
	_o = { "name": "robert", "age": 23 }

	req._doc.create _o, res.json 
	res.end( )

app.get "/delete/:type/:id", ( req, res ) ->
	req._doc.delete res.json 
	res.end( )

app.get "/update/:type/:id", ( req, res ) ->
	# parse the updated object from req..
	_o = { }
	req._type.update _o, res.json 
	res.end( )

app.listen config.api.port, ( ) ->
	log "listening on port #{config.api.port}."
