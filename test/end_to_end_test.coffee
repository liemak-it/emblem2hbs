chai = require("chai")
assert = chai.assert

fs = require("fs")
Processor = require("../lib/processor")
Indentation = require("../lib/indentation")

describe 'emblem2hbs', ->
  it 'should process a real-world complex emblem template correctly', ->
    input = fs.readFileSync('./test/fixtures/test_template.emblem', 'utf8')
    expected = fs.readFileSync('./test/fixtures/test_template.js.hbs', 'utf8')

    assert.equal(Indentation.indent(Processor.process(input)), expected)