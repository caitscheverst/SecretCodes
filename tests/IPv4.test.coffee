assert = require 'assert'
lib = require '../identifiers/IPv4.coffee'
            
describe "IPv4", ->
    describe "Valid identifiers", ->
        it "should parse successfully", ->
            assert.equal lib.IPv4.attempt('192.168.1.1')[0], 'success',
        it "should return correct data", ->
            assert.deepEqual lib.IPv4.attempt('192.168.1.1'), ['success', new lib.IPv4(['192', '168', '1', '1'])]
    
    describe "Invalid identifiers", ->
        it "should fail when given one too short", ->
            assert.deepEqual lib.IPv4.attempt('192.168.1.1.1'), ['failure', "Didn't match regexp"]
        it "should fail when given one too long", ->
            assert.deepEqual lib.IPv4.attempt('192.168.1'), ['failure', "Didn't match regexp"]
        it "should fail when given values over 255", ->
            assert.deepEqual lib.IPv4.attempt('192.168.386.50'), ['failure', "Numbers out of range"]
        it "should not accept CIDR notation", ->
            assert.deepEqual lib.IPv4.attempt('192.168.0.0/16'), ['failure', "Didn't match regexp"]
