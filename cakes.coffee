colors = require 'colors'
_ = require 'underscore'
_.str = require 'underscore.string'
_.mixin _.str.exports()

{argv} = require 'optimist'

class MochaInterface  # Support for Mocha BDD&TDD Interfaces
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

### Start of Feature ###

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

### Start of Scenario ###

createScenario = (options)->

	# Options =
	#	label
	#	whitespace
	#	style

	return (message, callback)->

		if 'label' in options
			message = 'Scenario: '+message
		if 'whitespace' in options
			message = '\n    '+message
		if 'style' in options
			message = message.green
		if 'skippable' in options  # TODO
			###
			unless arguments[0]
				arguments = _.toArray(arguments)
				arguments.shift()  # removes false
				arguments[1] = ->  # removes call body
				arguments[0] = ('(skipped) '+arguments[0]).yellow.bold
			###
			

		mocha.describe message, callback

exports.Scenario = createScenario(['whitespace', 'label', 'style'])


### Beginning of GWTab ###

describeItNest = (command, message, callback, options)->  # nest commands inside a Describe so mixed describe/its will line up on spec output.
	label = nestLabel options  # get pretty labels for nest.
	mocha.describe label, ->
		if command == 'it'
			mocha.it message, callback
		else
			mocha.describe '', ->
				mocha.describe message, callback

nestLabel = (options)->  # returns label of nested describes/its
	label = ''
	if 'label' in options
		label = '◦'
		if 'labelcolor' in options
			if 'dark' in options
				label = label.black
			else
				label = label.green
	return label

isPending = (command, message, cb)->  # Return Pending message.
	if not cb or cb.toString() == (->).toString()  # If Blank
		command = 'it'  # Convert pendings to It
		message = '◊ '+_.clean(message.stripColors)+' (pending)'
		cb = null
	return [command, message, cb]

gwtItDescribe = (label, message, callback, options)->  # routes command to a Describe or an It
	# If it's not passed a message, it'll be describe.
	if typeof message == 'function'
		callback = message
		message = label
		command = 'describe'
	else  # It's an it
		message = label+message
		command = 'it'

	[command, message, callback] = isPending(command, message, callback)

	describeItNest command, message, callback, options


createGWTab = (label, options)->  # Creates Given, When, Then, and, but commands
	return (message, callback)->
		label = gwtLabel label, options
		gwtItDescribe label, message, callback, options

gwtLabel = (label, options)->  # Returns pretty GWTab labels
	if 'label' in options
		if label && ('labelcolor' in options)
			if 'dark' in options
				label = label.grey
			else
				label = label.yellow
	else
		label = ''

	return label


exports.Given = createGWTab('Given: ', ['label', 'labelcolor'])

exports.When = createGWTab(' When: ', ['label', 'labelcolor'])

exports.Then = createGWTab(' Then: ', ['label', 'labelcolor'])

exports.And = createGWTab('  And: ', ['label', 'labelcolor', 'dark'])

exports.But = createGWTab('  But: ', ['label', 'labelcolor', 'dark'])

### End of GWTab ###
### Start of Spec/Describe ###

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
		label = '[system]'
		if 'style' in options
			label = label.grey.italic

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
