colors = require 'colors'
_ = require 'underscore'
_.str = require 'underscore.string'
_.mixin _.str.exports()

{argv} = require 'optimist'

if argv.R == 'doc'  # No colors for doc reporter.
	colors.mode = 'none'
	SPEC_REPORTER = 'doc'

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
		unless typeof story[0] is 'function'
			(message += '\t'+part+'\n' for part in story)
		else
			callback = story[0]

		mocha.describe message, callback

exports.Feature = createFeature(['label', 'whitespace', 'style'])

### Start of Scenario ###

createScenario = (options)->

	# Options =
	#	label
	#	whitespace
	#	style

	return (message, callback)->

		if message == false  # First arg is false, skip
			message = callback
			return skipScenario message, options

		if 'label' in options
			message = 'Scenario: '+message
		if 'whitespace' in options
			message = '\n    '+message
		if 'style' in options
			message = message.green

		mocha.describe message, callback

skipScenario = (message, options)->
	if 'label' in options
		message = '(skipped) ' + message
	if 'whitespace' in options
		message = '\n    '+message
	if 'style' in options
		message = message.yellow.bold

	mocha.describe message, ->

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
		if 'style' in options
			if 'dark' in options
				label = label.black
			else
				label = label.green

	if SPEC_REPORTER == 'doc'
		label = ''

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
		if label && ('style' in options)
			if 'dark' in options
				label = label.grey
			else if 'white' in options
				label = label.white
			else
				label = label.yellow
	else
		label = ''

	return label


exports.Given = createGWTab('Given: ', ['label', 'style'])

exports.When = createGWTab(' When: ', ['label', 'style'])

exports.Then = createGWTab(' Then: ', ['label', 'style'])

exports.And = createGWTab('  And: ', ['label', 'style', 'dark'])

exports.But = createGWTab('  But: ', ['label', 'style', 'dark'])

exports.I = createGWTab('  I ', ['label', 'style', 'white'])

### End of GWTab ###
### Start of Describe ###

createDescribe = (options)->
	return (message, callback)->
		if 'label' in options
			message = "=== #{message} ==="

		if 'style' in options
			message = message.blue

		mocha.describe message, callback

exports.Describe = createDescribe(['label', 'style'])

createSystem = (options)->
	return (msg, callback)->
		label = ''
		if 'label' in options
			label = '[system]'

		if 'style' in options
			label = label.black.italic

		# If it has a message, it's an IT, or else it's a describe.
		if typeof msg is 'function'  # No msg, so it's a describe
			callback = msg
			msg = ''
			[command, msg, callback] = isPending('describe', msg, callback)
		else
			[command, msg, callback] = isPending('it', msg, callback)

			if 'style' in options and callback is null  # isPending
				msg = msg.cyan

		label += ' '+msg
		describeItNest command, label, callback, options


exports.System = createSystem(['label', 'style'])

# Add function names to global scope.
(global[name] = func for name, func of module.exports)
