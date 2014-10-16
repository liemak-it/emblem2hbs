#!/usr/bin/env coffee

fs = require("fs")
emblem = require("emblem")
handlebars = require("handlebars")
emberHandlebars = require("ember-handlebars")
html = require('html')
_ = require("underscore")

emblem.handlebarsVariant = emberHandlebars

emblemFile = process.argv[2]
hbsFile = emblemFile.substr(0, emblemFile.lastIndexOf(".")) + ".hbs";

buf = fs.readFileSync(emblemFile, "utf8")
result = emblem.parse(buf)

tokens = ['if', 'each', 'unless']

pairsToAttr = (pairs) ->
  _(pairs).map((arr) -> "#{arr[0]}=\"#{arr[1].string}\"").join(' ').trim()

processStatements = (statements) ->
  _(statements).map (s) ->
    switch s.type
      when 'content' then s.string
      when 'block'
        params = if s.mustache?.params?.length > 0 then ' ' + _(s.mustache.params).map((p) -> p.string).join(' ') else ''
        r = ["{{#{(if _(tokens).include(s.mustache.id.original) then '#' else '')}#{s.mustache.id.original} #{params}}}"]
        if s.program?
          r.push processStatements(s.program.statements)
        if s.inverse?
          r.push ['{{else}}']
          r.push processStatements(s.inverse.statements)
        r.push "{{/#{s.mustache.id.original}}}" if _(tokens).include(s.mustache.id.original)
        r
      when 'mustache'

        if s.isHelper.pairs?
          "{{bind-attr #{pairsToAttr(s.isHelper.pairs)}}}"

        else
          pairs = if s.hash?.pairs?.length > 0 then ' ' + pairsToAttr(s.hash.pairs) else ''
          params = if s.params?.length > 0 then ' ' + _(s.params).map((p) -> p.string).join(' ') else ''
          r = ["{{#{s.id.original}#{params}#{pairs}}}"]
          if s.program?
            r.push processStatements(s.program.statements)
          r.push "{{/#{s.id.original}}}" if _(tokens).include(s.id.original)
          r
      else ''

output = _(processStatements(result.statements)).flatten().join('')
pretty = html.prettyPrint(output, {'indent_size': 2, 'indent_char': ' ','max_char': 0})
pretty = pretty.replace(/" }}/g, '"}}')
fs.writeFileSync hbsFile, pretty


