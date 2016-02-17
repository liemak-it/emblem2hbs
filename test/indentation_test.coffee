chai = require("chai")
assert = chai.assert

Indentation = require("../lib/indentation")

describe 'Indentation', ->
  describe '#indent()', ->
    it 'should correctly indent HTML', ->
      unindented = "<div class=\"heading\"><h1>Hello world</h1><span>This is my page</span></div>"
      indented = """
      <div class="heading">
        <h1>
          Hello world
        </h1>
        <span>
          This is my page
        </span>
      </div>
      """
      assert.equal(Indentation.indent(unindented), indented)

    it 'should correctly indent Handlebars', ->
      unindented = "<div class=\"heading\" {{bind-attr disabled=model.disabled}}>{{#if conditional}}<h1>Hello world</h1>{{/if}}</div>"
      indented = """
      <div class="heading" {{bind-attr disabled=model.disabled}}>
        {{#if conditional}}
          <h1>
            Hello world
          </h1>
        {{/if}}
      </div>
      """
      assert.equal(Indentation.indent(unindented), indented)

    it 'should correctly indent Handlebars with triple-staches', ->
      unindented = "<div class=\"heading\" {{bind-attr disabled=model.disabled}}>{{{value}}}</div>"
      indented = """
      <div class="heading" {{bind-attr disabled=model.disabled}}>
        {{{value}}}
      </div>
      """
      assert.equal(Indentation.indent(unindented), indented)
