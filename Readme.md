# What is it?        

[Cucumber](http://cukes.info/) syntax add-on for [mocha](https://github.com/visionmedia/mocha) javascript/node test framework.

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

Mocha-cakes gives you access to functions _"Feature", "Scenario", "Given", "When", "Then" "And", "But"_ that wraps around mocha's `describe()`. So the above would output something like:

```cucumber
  Feature: New Feature 

  In order to use cool feature
  as a new user
  I want do include this
    
    Scenario: Singing
      Given: I am a good singing
      When: I sing
      Then: it should sound good
        ✓ sound good  


  ✔ 1 tests complete (3ms)

```

# Use it

Prerequisite: `coffee-script`

Install local:

    cd my_project/node_modules
    git clone git@github.com:quangv/mocha-cakes.git

Or install it to your global `mocha/node_modules` directory and include it in your test suites `mocha.opts` file `--require mocha-cakes`

---

\*Special Thanks\* to [TJ Holowaychuk](https://github.com/visionmedia) for Mocha, awesome test framework.
