colors = require 'colors'

exports.Feature = (feature, story..., callback)->
	#  exp. Feature 'new feature', 'in order to do good', 'as a user', 'I want to do good', ->
	# message = "Feature: #{feature} \n\n\t#{benefit}\n\t#{who}\n\t#{desire}"

	message = "Feature: #{feature} \n\n".green.underline
	(message += '\t'+part+'\n' for part in story)

	describe(message, callback)
	return

depict = (label, args)->
	if args.length == 1
		args[1] = args[0]
		label = ''

	describe label.replace('%s', args[0]), args[1]

exports.Background = (action, callback)->
	depict action.magenta, arguments

exports.Scenario = ->
	depict "\n    Scenario: %s".green, arguments

exports.Given = ->
	depict "Given:".yellow+" %s", arguments

exports.When = ->
	depict " When:".yellow+" %s", arguments

exports.And = ->
	depict "  and".grey+"  %s", arguments

exports.Then = ->
	depict " Then:".yellow+" %s", arguments

exports.But = ->
	depict "  But".yellow+"  %s", arguments

exports.Spec = ->  # describe() start of spec file
	depict '%s'.blue, arguments

# Add function names to global scope.
(global[name] = func for name, func of module.exports)
