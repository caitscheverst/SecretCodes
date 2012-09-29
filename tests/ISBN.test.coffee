mocha = require 'mocha'
assert = require 'assert'
lib = require '../identifiers/ISBN.coffee'
            
describe "ISBN", ->
    describe "Valid identifiers", ->
        it "should parse successfully", ->
            assert.equal lib.ISBN.attempt('978-18-53260865')[0], 'success',
        it "should return correct data", ->
            assert.deepEqual lib.ISBN.attempt('978-18-53260865'), ['success', new lib.ISBN('978', '18', '5326', '086', '5')]
    
    describe "Invalid identifiers", ->
        it "should fail when given one too short", ->
            assert.deepEqual lib.ISBN.attempt('18-53260865'), ['failure', "Didn't match regexp"]
        it "should fail when given one too long", ->
            assert.deepEqual lib.ISBN.attempt('978-18-532608653'), ['failure', "Didn't match regexp"]
