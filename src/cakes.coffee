exports.Feature = (feature, story..., callback)->
	#  exp. Feature 'new feature', 'in order to do good', 'as a user', 'I want to do good', ->
	# message = "Feature: #{feature} \n\n\t#{benefit}\n\t#{who}\n\t#{desire}"

	message = "Feature: #{feature} \n"
	(message += '\n\t'+part for part in story)

	describe(message, callback)
	return

exports.Scenario = (message, callback)->
	describe("\n    Scenario: #{message}", callback)

exports.Given = (context, callback)->
	if arguments.length == 1
		callback = context
		message = 'before'

	describe("Given: #{context}", callback)

exports.When = (action, callback)->
	describe("When: #{action}", callback)

exports.And = (more_action_or_outcome, callback)->
	describe("  and: #{more_action_or_outcome}", callback)

exports.Then = (outcome, callback)->
	describe("Then: #{outcome}", callback)

exports.But = (not_outcome)->
	describe(" but: #{not_outcome}", callback)

# Add function names to global scope.
(global[name] = func for name, func of module.exports)
