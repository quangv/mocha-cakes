colors = require 'colors'
_ = require 'underscore'
_.str = require 'underscore.string'
_.mixin _.str.exports()

{argv} = require 'optimist'

class MochaInterface
	_describe : 'describe'
	_it : 'it'

	constructor : ->
		# TDD Interface support
		argv.ui = argv.ui ? argv.u  # mocha option --ui overwrites -u
		if argv.ui && (argv.ui == 'tdd' or _.last(argv.ui) == 'tdd')
			@_describe = 'suite'
			@_it = 'test'

	describe : ->
		global[@_describe].apply global, arguments
	it : ->
		global[@_it].apply global, arguments

mocha = new MochaInterface

createFeature = (options)->

	# Options =
	#	label
	#	whitespace
	#	style

	return (feature, story..., callback)->
		#  exp. Feature 'new feature', 'in order to do good', 'as a user', 'I want to do good', ->

		if 'label' in options
			feature = 'Feature: '+feature

		if 'whitespace' in options
			feature = feature+'\n'

		if 'style' in options
			feature = feature.green.underline.bold
			
		message = feature+'\n'
		(message += '\t'+part+'\n' for part in story)

		mocha.describe message, callback

exports.Feature = createFeature(['label', 'whitespace', 'style'])

createScenario = (options)->

	# Options =
	#	label
	#	whitespace
	#	style
	#	pending

	return (message, callback)->

		if 'label' in options
			message = 'Scenario: '+message
		if 'whitespace' in options
			message = '\n    '+message
		if 'style' in options
			message = message.green
		if 'pending' in options  # TODO
			###
			unless arguments[0]
				arguments = _.toArray(arguments)
				arguments.shift()  # removes false
				arguments[1] = ->  # removes call body
				arguments[0] = ('(skipped) '+arguments[0]).yellow.bold
			###
			

		mocha.describe message, callback

exports.Scenario = createScenario(['whitespace', 'label', 'style', 'pending'])


createGiven = (options)->
	return (message, callback)->
		if 'label' in options
			label = 'Given: '
			if 'labelcolor' in options
				label = label.yellow
			message = label+message

		mocha.it message, callback

exports.Given = createGiven(['label', 'labelcolor'])

createWhen = (options)->
	return (message, callback)->
		if 'label' in options
			label = ' When: '
			if 'labelcolor' in options
				label = label.yellow
			message = label+message

		mocha.it message, callback

exports.When = createWhen(['label', 'labelcolor'])

createThen = (options)->
	return (message, callback)->
		if 'label' in options
			label = ' Then: '
			if 'labelcolor' in options
				label = label.yellow
			message = label+message

		mocha.it message, callback

exports.Then = createThen(['label', 'labelcolor'])

createAnd = (options)->
	return (message, callback)->
		if 'label' in options
			label = '  And: '
			if 'labelcolor' in options
				label = label.grey
			message = label+message

		mocha.it message, callback

exports.And = createAnd(['label', 'labelcolor'])

createBut = (options)->
	return (message, callback)->
		if 'label' in options
			label = '  But: '
			if 'labelcolor' in options
				label = label.grey
			message = label+message

		mocha.it message, callback

exports.But = createBut(['label', 'labelcolor'])

createDescribe = (options)->
	return (message, callback)->
		if 'label' in options
			message = "=== #{message} ==="

		if 'color' in options
			message = message.blue

		mocha.describe message, callback

exports.Describe = exports.Spec = createDescribe(['label', 'color'])

createSystem = (options)->
	return (callback)->
		label = 'System'
		if 'style' in options
			label = label.yellow.inverse.italic

		mocha.describe label, callback

exports.System = createSystem(['style'])


###
gwt = (label, args, options)->
	[title, cb] = args_wash args

	options = _.extend
		padding:true
		pending:true
	, options

	dic 'it', label, [title,cb], options

args_wash = (args)-  # allow blank  labels
	title = ''
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

		[title, cb] = args_wash args

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
				mocha[type] label
			else
				mocha[type] label, cb

		if options.padding  # NESTING Support
			mocha.describe '◦'[options.padding_color], ->
				fn()
		else
			fn()


exports.Given = ->
	gwt "Given:".yellow+" %s", arguments

exports.When = ->
	gwt " When:".yellow+" %s", arguments

exports.Then = ->
	gwt " Then:".yellow+" %s", arguments


exports.And = ->
	gwt "  And".grey+"  %s", arguments, padding_color:'black'

exports.But = ->
	gwt "  But".grey+"  %s", arguments, padding_color:'black'

exports.Describe = exports.Spec = ->  # describe() start of spec file
	dic 'describe', '=== %s ==='.blue, arguments
###

# Add function names to global scope.
(global[name] = func for name, func of module.exports)
