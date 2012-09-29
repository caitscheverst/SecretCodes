assert = require 'assert'
lib = require '../identifiers/MAC.coffee'

describe "MAC", ->
    describe "Valid identifiers", ->
        it "should parse successfully", ->
            assert.equal lib.MAC.attempt('00:11:22:33:44:55')[0], 'success',
        it "should return correct data", ->
            assert.deepEqual lib.MAC.attempt('00:11:22:33:44:55'), ['success', new lib.MAC( ['00', '11', '22', '33', '44', '55'] )]
        it "should accept hexadecimal values", ->
            assert.deepEqual lib.MAC.attempt('FE:DC:BA:98:76:54'), ['success', new lib.MAC( ['FE', 'DC', 'BA', '98', '76', '54'] )]
        it "should return a valid OUI", (done) ->
            assert.equal lib.MAC.attempt('00:11:22:33:44:55')[1].getVendor (vendor) ->
                assert.equal vendor, "CIMSYS Inc"
                done()
    
    describe "Invalid identifiers", ->
        it "should fail when given one too short", ->
            assert.deepEqual lib.MAC.attempt('00:11:22:33:44'), ['failure', "Didn't match regexp"]
        it "should fail when given one too long", ->
            assert.deepEqual lib.MAC.attempt('00:11:22:33:44:55:66'), ['failure', "Didn't match regexp"]
        it "should fail when given bad hex values", ->
            assert.deepEqual lib.MAC.attempt('EA:24:37:20:X6:05'), ['failure', "Didn't match regexp"]