# What is it?        

[Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin)-[Cucumber](http://cukes.info/) syntax add-on for [mocha](https://github.com/visionmedia/mocha) javascript/node test framework for customer acceptance testing.

Provides high-level/functional/acceptance test organization lingo, using _'Feature'_, _Stories_, _'Scenarios'_, _'Given/Then/When'_.

![Mocha-Cakes Pretty Output](http://i.imgur.com/cKUO8.png)

# Mocha-Cakes Commands Breakdown
  
  Mocha-Cakes extends Mocha, by adding on helpful commands and print-outs for Acceptance Tests. (Given, When, Then, etc.)

##Acceptance Tests

`Feature`, `Scenario`  (maps to _describe_)

`Given`, `When`, `Then` (maps to _it_, but if first message argument is ommited, it'll be a _describe_)

`And`, `But` (maps to _it_ but if first message argument is ommited, it'll be a _describe_)

### GWTab
  GWTab commands can map to a describe if the message argument is ommited.

  ```coffeescript
    Given 'I am at home', ->  # it's an it
      home.should.eql 'home'

    Given ->  # it's a describe
      it 'is dark', ->
        outside.should.eql 'dark'
  ```

## Grey-Box, System Tests

`System` (if it has a message it'll be an  _it_, if not it'll be a _describe_ with System label, useful for testing (grey box) system resources, database, not directly observable by Customer etc.)

## Pretty Commands for Specs/Unit Tests

`Describe`, `Spec` (maps to _describe_ used for things like filenames)

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

_"Given", "When", "Then", "And", "But"_ wraps around mocha's `it()`.

Also bonus, "Spec" and "Describe" wraps around mocha's _describe()_ also, that could be used at the start of spec files. It prints out in bolded blue header with `-R Spec`.

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

## How to Use

Mocha-Cakes provides GWT commands to mocha, and pretty prints it.

To use just:

1. require 'mocha-cakes'

Then you will have access to the mocha-cakes commands _Feature, Scenario, Given, When, Then, etc._

Also to _see_ the pretty output, use the _spec_ reporter

`mocha -R spec -r mocha-cakes acceptance_tests.coffee`

Note: You can use mocha-cakes with plain javascript.

## Features

```coffeescript

require 'mocha-cakes'

Feature "Big Buttons",
  "As a user",
  "I want big buttons",
  "So it'll be easier to use", ->

    Scenario "On Homepage", ->

      Given "I am a new user", ->
      When "I go to homepage", ->

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

Install:

    cd my_project
    npm -d install mocha-cakes

# Mocha Reporter Support

Mocha-Cakes was developed with the `-R spec` in mind.

You can use Mocha-Cakes also with the `-R doc` reporter.

All other reporters should function, but have not been tested.


If you have any questions, issues or comments, please leave them on [mocha-cakes' github](https://github.com/quangv/mocha-cakes/issues).

Thanks!

---

\*Special Thanks\* to [TJ Holowaychuk](https://github.com/visionmedia) for Mocha, awesome test framework.
