assert = require 'assert'
lib = require '../identifiers/UUID.coffee'
            
describe "UUID", ->
    describe "Valid identifiers", ->
        it "should parse successfully", ->
            assert.equal lib.UUID.attempt('f47ac10b-58cc-4372-a567-0e02b2c3d479')[0], 'success',
        it "should return correct data", ->
            assert.deepEqual lib.UUID.attempt('f47ac10b-58cc-4372-a567-0e02b2c3d479'), ['success', new lib.UUID('f47ac10b-58cc-', '4', '372-a567-0e02b2c3d479')]
    
    describe "Invalid identifiers", ->
        it "should fail when given one too short", ->
            assert.deepEqual lib.UUID.attempt('f47ac10b-58cc-4372-a567-0e02b2c3d4798'), ['failure', "Didn't match regexp"]
        it "should fail when given one too long", ->
            assert.deepEqual lib.UUID.attempt('f47ac10b-58cc-4372-a567-0e02b2c3d47'), ['failure', "Didn't match regexp"]
