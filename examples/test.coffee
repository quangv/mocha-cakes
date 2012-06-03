require '../'

Feature "New Feature",
	"In order to use cool feature",
	"as a new user",
	"I want do include this", ->

		Scenario "Singing", ->

			voice = null

			Given "I am a good singing", ->
				it 'should be true', ->
					true.should.eql true

				it 'should be true too', ->
					true.should.eql true

			When "I sing", ->
				voice = 'good'
			Then "it should sound good", ->
				voice.should.eql 'good'

			And "it should do this", ->
			But "it shouldn't do that", ->

			Describe '/test/describe.spec', ->

			Given 'Test', ->
				true.should.eql true

			When ->
				it 'should be true', ->
					true.should.eql true
			Then 'Yup', ->
				true.should.eql true

			# Pendings

			Given "It's Pending", ->
			When ->
			Then ->

Feature "Mix & Match", ->
  Scenario 'Mix-in Mocha', ->
	Given "I'm using Cakes", ->
	Then ->
	  describe 'Also using regular mocha', ->
		I 'should be able to do this', ->
		  true.should.eql true
		it 'should work too', ->
		  true.should.eql true

# Run with
# mocha examples/test.coffee -R spec -r should
#
# note: must have should installed in mocha for above example to work
