assert = require 'assert'

lib = require '../identifiers/Meyers-Briggs.coffee'

describe "MeyersBriggs", ->
    describe "Valid identifiers", ->
        it "should parse successfully", ->
            assert.equal lib.MeyersBriggs.attempt('INTP')[0], 'success',
        it 'should be introverted', ->
            assert.equal lib.MeyersBriggs.attempt('INTP')[1].a, 'I'
        it 'should be intuitive', ->
            assert.equal lib.MeyersBriggs.attempt('INTP')[1].p, 'N'
        it 'should be thoughtful', ->
            assert.equal lib.MeyersBriggs.attempt('INTP')[1].j, 'T'
        it 'should be perceptive', ->
            assert.equal lib.MeyersBriggs.attempt('INTP')[1].l, 'P'
    describe "Invalid identifiers", ->
        it "should fail when given invalid input", ->
            assert.deepEqual lib.MeyersBriggs.attempt('HTTP'), ['failure', "Didn't match regexp"]
