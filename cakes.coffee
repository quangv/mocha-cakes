colors = require 'colors'

exports.Feature = (feature, story..., callback)->
	#  exp. Feature 'new feature', 'in order to do good', 'as a user', 'I want to do good', ->
	# message = "Feature: #{feature} \n\n\t#{benefit}\n\t#{who}\n\t#{desire}"

	message = "Feature: #{feature} \n\n".green.underline
	(message += '\t'+part+'\n' for part in story)

	describe(message, callback)
	return

dic = (type, label, args, padding=false)->  # Dictate to describe() or it()

	if type in ['describe', 'it']
		if args.length == 1
			args[1] = args[0]
			label = ''

		if padding
			describe '|'.green, ->
				global[type] label.replace('%s', args[0]), args[1]
		else
			global[type] label.replace('%s', args[0]), args[1]


###
exports.Background = (action, callback)->
	depict action.magenta, arguments
###

exports.Scenario = ->
	dic 'describe', "\n    Scenario: %s".green, arguments


exports.Given = ->
	dic 'it', "Given:".yellow+" %s", arguments, true

exports.When = ->
	dic 'it', " When:".yellow+" %s", arguments, true

exports.Then = ->
	dic 'it', " Then:".yellow+" %s", arguments, true

exports.Given_ = ->
	dic 'describe', " Given:".yellow+" %s", arguments, true

exports.When_ = ->
	dic 'describe', "  When:".yellow+" %s", arguments, true

exports.Then_ = ->
	dic 'describe', "  Then:".yellow+" %s", arguments, true


exports.And = ->
	dic 'describe', "  and".grey+"  %s", arguments

exports.But = ->
	dic 'describe', "  But".grey+"  %s", arguments


exports.Step = ->
	dic 'it', '%s', arguments


exports.Spec = ->  # describe() start of spec file
	dic 'describe', '%s'.blue, arguments


# Add function names to global scope.
(global[name] = func for name, func of module.exports)
