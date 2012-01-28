log = require 'log'

colors = require 'colors'
_ = require 'underscore'
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
	if args.length == 1  # allow blank label
		title = ''
		cb = args[0]
	else
		title = args[0]
		cb = args[1]

	return [title, cb]

dic = (type, label, args, options={})->  # Dictate to describe() or it()

	options = _.extend
		padding:false
		padding_color:'green'
	, options

	if type in ['describe', 'it']

		[title, cb] = args_wash args

		if args.length == 1  # allow blank label
			label = ''
		else
			label = label.replace('%s', title)

		if options.pending
			if cb.toString() == (->).toString()  # If Blank
				label = '(Pending) '+label
				

		fn = ->
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
	dic 'it', '%s', arguments


exports.Spec = ->  # describe() start of spec file
	dic 'describe', '=== %s ==='.blue, arguments


# Add function names to global scope.
(global[name] = func for name, func of module.exports)
