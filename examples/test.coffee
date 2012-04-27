require '../'

Feature "New Feature",
	"In order to use cool feature",
	"as a new user",
	"I want do include this", ->

		Scenario "Singing", ->

			voice = null

			Given "I am a good singing", ->
			When "I sing", ->
				voice = 'good'
			Then "it should sound good", ->
				voice.should.eql 'good'

			And "it should", ->
			But "it should", ->

			Describe '/test/describe.spec', ->


# Run with
# mocha examples/test.coffee -R spec -r should
#
# note: must have should installed in mocha for above example to work
