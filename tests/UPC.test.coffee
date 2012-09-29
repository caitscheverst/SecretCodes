assert = require 'assert'
lib = require '../identifiers/UPC.coffee'
            
describe "UPC", ->
    describe "Valid identifiers", ->
        it "should parse successfully", ->
            assert.equal lib.UPC.attempt('123456789999')[0], 'success',
        it "should return correct data", ->
            assert.deepEqual lib.UPC.attempt('123456789999'), ['success', new lib.UPC('1', '2345678999', '9')]
    
    describe "Invalid identifiers", ->
        it "should fail when given one too short", ->
            assert.deepEqual lib.UPC.attempt('1234567899999'), ['failure', "Didn't match regexp"]
        it "should fail when given one too long", ->
            assert.deepEqual lib.UPC.attempt('12345678999'), ['failure', "Didn't match regexp"]
