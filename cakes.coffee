colors = require 'colors'
_ = require 'underscore'
_.str = require 'underscore.string'
_.mixin _.str.exports()

{argv} = require 'optimist'


interface =
	bdd :
		it : 'it'
		describe : 'describe'
	tdd :
		it : 'test'
		describe : 'suite'

argv.ui = argv.ui ? argv.u  # mocha option --ui overwrites -u
if argv.ui && (argv.ui == 'tdd' or _.last(argv.ui) == 'tdd')
	ui = interface.tdd
else
	ui = interface.bdd  # Default


exports.Feature = (feature, story..., callback)->
	#  exp. Feature 'new feature', 'in order to do good', 'as a user', 'I want to do good', ->
	# message = "Feature: #{feature} \n\n\t#{benefit}\n\t#{who}\n\t#{desire}"

	message = "Feature: #{feature} \n\n".green.underline
	(message += '\t'+part+'\n' for part in story)

	global[ui.describe](message, callback)
	return


args_wash = (args)->
	title = ''  # allow blank  labels
	cb = undefined

	if typeof args[0] == 'string' or typeof args[1] == 'function'
		title = args[0]
		cb = args[1]
	else if typeof args[0] == 'function'
		cb = args[0]

	return [title, cb]

dic = (type, label, args, options={})->  # Dictate to describe() or it()

	options = _.extend
		padding:false
		padding_color:'green'
	, options

	if type in ['describe', 'it']

		log args
		[title, cb] = args_wash args
		log title, cb

		if args.length == 1 and typeof args[0] == 'function'  # allow blank label
			label = ''
		else
			label = label.replace('%s', title)

		if options.pending
			if not cb or cb.toString() == (->).toString()  # If Blank
				label = '◊ '+_.clean(label.stripColors)+' (pending)'
				cb = null
				

		fn = ->
			if type is 'it' and not cb
				global[ui[type]] label
			else
				global[ui[type]] label, cb

		if options.padding
			global[ui.describe] '◦'[options.padding_color], ->
				fn()
		else
			fn()


###
exports.Background = (action, callback)->
	depict action.magenta, arguments
###

exports.Scenario = ->
	dic 'describe', "\n    Scenario: %s".green, arguments


gwt = (label, args, options)->
	[title, cb] = args_wash args

	options = _.extend
		padding:true
		pending:true
	, options

	###
	#log 'gwt', title, cb.length
	unless cb.length >= 1
		callback = (done)->
			cb()
			done()
	else
		callback = cb
	###

	dic 'it', label, [title,cb], options

exports.Given = ->
	gwt "Given:".yellow+" %s", arguments

exports.When = ->
	gwt " When:".yellow+" %s", arguments

exports.Then = ->
	gwt " Then:".yellow+" %s", arguments

exports.Given_ = ->
	dic 'describe', " Given:".yellow+" %s", arguments, padding:true

exports.When_ = ->
	dic 'describe', "  When:".yellow+" %s", arguments, padding:true

exports.Then_ = ->
	dic 'describe', "  Then:".yellow+" %s", arguments, padding:true


exports.And = ->
	gwt "  and".grey+"  %s", arguments, padding_color:'black'

exports.But = ->
	gwt "  But".grey+"  %s", arguments, padding_color:'black'


exports.Step = ->
	dic 'it', '%s', arguments, pending:true


exports.Spec = ->  # describe() start of spec file
	dic 'describe', '=== %s ==='.blue, arguments


# Add function names to global scope.
(global[name] = func for name, func of module.exports)
