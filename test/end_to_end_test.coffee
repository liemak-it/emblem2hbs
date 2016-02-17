chai = require("chai")
assert = chai.assert

fs = require("fs")
Indentation = require("../lib/indentation")

emblem = require('emblem')

describe 'emblem2hbs', ->
  it 'should process a real-world complex emblem template correctly', ->
    input = fs.readFileSync('./test/fixtures/test_template.emblem', 'utf8')
    expected = fs.readFileSync('./test/fixtures/test_template.js.hbs', 'utf8')

    assert.equal(Indentation.indent(emblem.default.compile(input)), expected)
