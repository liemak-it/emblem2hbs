#!/usr/bin/env coffee

fs = require("fs")
emblem = require("emblem")
handlebars = require("handlebars")
emberHandlebars = require("ember-handlebars")
html = require('html')
_ = require("underscore")

emblem.handlebarsVariant = emberHandlebars
buf = fs.readFileSync(process.argv[2], "utf8")
result = emblem.parse(buf)

tokens = ['if', 'each', 'unless']

processStatements = (statements) ->
  _(statements).map (s) ->
    switch s.type
      when 'content' then s.string
      when 'block'
        r = ["{{#{(if _(tokens).include(s.mustache.id.original) then '#' else '')}#{s.mustache.id.original} #{_(s.mustache.params).map((p) -> p.string).join(' ')}}}"]
        if s.program?
          r.push processStatements(s.program.statements)
        r.push "{{/#{s.mustache.id.original}}}" if _(tokens).include(s.mustache.id.original)
        r
      when 'mustache'
        if s.isHelper.pairs?
          "{{bind-attr #{s.isHelper.pairs[0][0]}=\"#{s.isHelper.pairs[0][1].string}\"}}"
        else
          r = ["{{#{(if _(tokens).include(s.id.original) then '#' else '')}#{s.id.original} #{_(s.params).map((p) -> p.string).join(' ')}}}"]
          if s.program?
            r.push processStatements(s.program.statements)
          r.push "{{/#{s.id.original}}}" if _(tokens).include(s.id.original)
          r
      else ''

# setInterval (() ->), 500

output = _(processStatements(result.statements)).flatten().join('')
console.log html.prettyPrint(output)