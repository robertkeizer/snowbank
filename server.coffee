log	= require( "logging" ).from __filename
config	= require "config"
express	= require "express"
cradle	= require "cradle"

# Generic ODM class.
class generic_odm
	constructor: (@type, @database) ->
		@_db = new (cradle.Connection)( @database.url, @database.port ).database @database.db

	_force_ready: ( cb ) ->
		# This function only callbacks if everything is ready; such as
		# the database exists, and we've already loaded views are available
		# for this type.
		cb null

	_get_required_attributes: ( cb ) ->
		# In the future this will have some logic that will
		# return a list of the required attributes this type must
		# have.. or at least should have..
		cb [ ]

	list: ( filters, cb ) ->
		cb null, "what?"

	create: ( doc, cb ) ->
		@_db.save doc, cb

	delete: ( _id, cb ) ->

		# Allow an ID to be specified. If
		# it isn't, use @_id.
		if not cb
			cb	= _id
			_id	= @_id
		
		# use _id to remove the document..
		cb { "error": "would have deleted document of type '#{@type}' with id of '#{@_id}'" }

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
app.use express.bodyParser( )
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
	
	# Force the required fields based on the type..
	req._doc._get_required_attributes ( err, required_fields ) ->
		if err
			res.json err
			res.end( )
		
		async.each required_fields, ( required_field, cb ) ->
			cb ( not required_field of req.body ) ? ( required_field ) : null
		, ( err ) ->
			if err
				res.json err
				res.end( )

			# At this point we know that all the required fields have been met..
			# parse the body for the object properties..
			# TODO
			_o = { "name": "robert", "age": 23 }

			req._doc.create _o, ( err, _res ) ->
				res.json ( err ) ? err : _res
				res.end( )

app.get "/delete/:type/:id", ( req, res ) ->
	req._doc.delete ( err ) ->
		res.json err
	res.end( )

app.get "/update/:type/:id", ( req, res ) ->
	# parse the updated object from req..
	_o = { }
	req._type.update _o, ( err ) ->
		res.json err
	res.end( )

app.listen config.api.port, ( ) ->
	log "listening on port #{config.api.port}."
