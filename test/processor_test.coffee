chai = require("chai")
assert = chai.assert

Processor = require("../lib/processor")

examples =
  ember: [
    ['Ember.TextField valueBinding="firstName"', '{{view Ember.TextField valueBinding="firstName"}}']
    ['img src=logoUrl alt="Logo"', '<img {{bind-attr src="logoUrl"}} alt="Logo" />']
    ['div class=condition:whenTrue:whenFalse', '<div {{bind-attr class="condition:whenTrue:whenFalse"}}></div>']
    ['div class={ condition1:whenTrue:whenFalse condition2:whenTrue:whenFalse }', '<div {{bind-attr class="condition1:whenTrue:whenFalse condition2:whenTrue:whenFalse"}}></div>']
    ['a click="toggleHeader" x', '<a {{action "toggleHeader" on="click"}}>x</a>']
    ['a click="toggleHeader target=\'view\'" x', '<a {{action "toggleHeader" target="view" on="click"}}>x</a>']
    ['a click="toggleHeader this" x', '<a {{action "toggleHeader" this on="click"}}>x</a>']
    ['form submit="submitTheForm foo"', '<form {{action "submitTheForm" foo on="submit"}}></form>']
    ['button{action "delete"} Delete', '<button {{action "delete"}}>Delete</button>']
    ['img{bind-attr src="logoUrl"} alt="logo"', '<img {{bind-attr src="logoUrl"}} alt="logo" />']
    ['a{bind-attr class="isActive"}{action \'toggleHeader\'} x', '<a {{bind-attr class="isActive"}} {{action "toggleHeader"}}>x</a>']
    ['App.MyTextArea objectBinding="view.answer" hideFieldName=true rows=20 cols=40', '{{view App.MyTextArea objectBinding="view.answer" hideFieldName=true rows=20 cols=40}}']
  ]

describe 'Processor', ->
  describe '#process()', ->
    it 'should turn some plain HTML Emblem into Handlebars', ->
      emblem = """
        .heading
          h1 Hello world
          span This is my page
      """
      hbs = "<div class=\"heading\"><h1>Hello world</h1><span>This is my page</span></div>"
      assert.equal(Processor.process(emblem), hbs)
    
    it 'should turn some Emblem with Handlebars tags into Handlebars', ->
      emblem = """
        .heading
          if condition
            h1 Hello world
          span This is my page
      """
      hbs = "<div class=\"heading\">{{#if condition}}<h1>Hello world</h1>{{/if}}<span>This is my page</span></div>"
      assert.equal(Processor.process(emblem), hbs)
      
    for group_name, example_group of examples
      do (group_name, example_group) ->
        for example in example_group
          do (group_name, example) ->
            it "should process the #{group_name} example '#{example}' correctly", ->
              assert.equal(Processor.process(example[0]), example[1])
