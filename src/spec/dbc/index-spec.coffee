{expect, fixtures, memo, sinon} = require('../spec-helper')

{floatle, int32le, uint32le} = require('../../lib/types')
fs = require('fs')
r = require('restructure')
Entity = require('../../lib/dbc/entity')
StringRef = require('../../lib/dbc/string-ref')

describe 'DBC', ->

  Sample = Entity(
    id: uint32le
    name: StringRef
    points: int32le
    height: floatle
    friend1: uint32le
    friend2: uint32le
  )

  dummy = memo().is ->
    data = fs.readFileSync fixtures + 'Sample.dbc'
    stream = new r.DecodeStream data
    Sample.dbc.decode stream

  describe '#signature', ->
    it 'returns WDBC', ->
      expect(dummy().signature).to.eq 'WDBC'

  describe '#recordCount', ->
    it 'returns amount of records', ->
      expect(dummy().recordCount).to.eq 8

  describe '#fieldCount', ->
    it 'returns amount of fields', ->
      expect(dummy().fieldCount).to.eq 6

  describe '#recordSize', ->
    it 'returns size of a single record', ->
      expect(dummy().recordSize).to.eq 24

  describe '#stringBlockSize', ->
    it 'returns size of string block', ->
      expect(dummy().stringBlockSize).to.eq 96

  describe '#stringBlockOffset', ->
    it 'returns offset of string block', ->
      expect(dummy().stringBlockOffset).to.eq 212

  describe '#records', ->
    it 'returns records', ->
      [first, ..., last] = dummy().records

      expect(first).to.deep.eq(
        id: 1
        name: 'John'
        points: 100
        height: 1.7999999523162842
        friend1: 2
        friend2: 0
      )

      expect(last).to.deep.eq(
        id: 10
        name: 'Brad'
        points: -10
        height: 1.5499999523162842
        friend1: 0
        friend2: 0
      )