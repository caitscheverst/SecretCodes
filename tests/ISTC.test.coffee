assert = require 'assert'
lib = require '../identifiers/ISTC.coffee'
            
describe "ISTC", ->
    describe "Valid identifiers", ->
        it "should parse successfully", ->
            assert.equal lib.ISTC.attempt('A02-2009-000004BE-A')[0], 'success',
        it "should return correct data", ->
            assert.deepEqual lib.ISTC.attempt('A02-2009-000004BE-A'), ['success', new lib.ISTC('A02', '2009', '000004BE', 'A')]
    
    describe "Invalid identifiers", ->
        it "should fail when given one too short", ->
            assert.deepEqual lib.ISTC.attempt('A02-2009-000004BE-AB'), ['failure', "Didn't match regexp"]
        it "should fail when given one too long", ->
            assert.deepEqual lib.ISTC.attempt('A02-2009-000004BE'), ['failure', "Didn't match regexp"]
        it "should not accept hex values in the year", ->
            assert.deepEqual lib.ISTC.attempt('A02-20F6-000004BE-A'), ['failure', "Didn't match regexp"]
