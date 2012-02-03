# What is it?        

[Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin)-[Cucumber](http://cukes.info/) syntax add-on for [mocha](https://github.com/visionmedia/mocha) javascript/node test framework for customer acceptance testing.

Provides high-level/functional/acceptance test organization lingo, using _'Feature'_, _Stories_, _'Scenarios'_, _'Given/Then/When'_.

# Example

_Coffee-Script: test.coffee_ 

```coffeescript

require 'mocha-cakes'

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
        it 'sound good', ->
          voice.should.eql 'good'

```
 
Run this test using mocha command:

`mocha test.coffee -R spec -r should`

# What's going on?

Mocha-cakes gives you access to function names 

_"Feature", "Scenario"_ that wraps around mocha's `describe()`. 

_"Given", "When", "Then", "And", "But", "Step"_ wraps around mocha's `it()`.

"Given\_", "When\_", "Then\_" (with underscore) also converts to _describe()_

So the above would output something like:

```cucumber
  Feature: New Feature 

  In order to use cool feature
  as a new user
  I want do include this
    
    Scenario: Singing
      ✓ Given: I am a good singing
      ✓ When: I sing
      ✓ Then: it should sound good
        ✓ sound good  


  ✔ 1 tests complete (3ms)

```

# Documentation

## Features

```coffeescript

require 'mocha-cakes'

Feature "Big Buttons",
  "As a user",
  "I want big buttons",
  "So it'll be easier to use", ->

    Scenario "On Homepage", ->

      Given "I am a new user", ->
      When_ "I go to homepage", ->
        Step 'open browser', (done)->
        Step 'visit page', ->

      And "I scroll down", ->
      Then "I see big buttons", ->
      But "no small text", ->

      Given ->  # Previous
      When "I scroll down more", ->
      And "I reach end of page", ->
      Then "all I see is big buttons", ->

      Spec 'test.spec.coffee', ->

```

_\* Remember, they're all either `describe()`'s or `it()`_

## Reference

[The WHY behind TDD/BDD and the HOW with RSpec](http://www.slideshare.net/bmabey/the-why-behind-tddbdd-and-the-how-with-rspec)


# Use it

Prerequisite: `coffee-script`

Install local:

    cd my_project/node_modules
    npm -d install mocha-cakes

---

\*Special Thanks\* to [TJ Holowaychuk](https://github.com/visionmedia) for Mocha, awesome test framework.
