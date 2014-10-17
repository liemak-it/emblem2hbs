fs = require("fs")
emblem = require("emblem")
emberHandlebars = require("ember-handlebars")
_ = require("underscore")

Processor = {}

Processor.process = (input) ->

  emblem.handlebarsVariant = emberHandlebars
  result = emblem.parse(input)
  tokens = ['if', 'each', 'unless']

  pairsToAttrString = (pairs) ->
    return '' unless pairs? && pairs.length > 0
    ' ' + _(pairs).map((arr) -> "#{arr[0]}=\"#{arr[1].string}\"").join(' ').trim()

  paramsToString = (params) ->
    return '' unless params? && params.length > 0
    ' ' + _(params).map((p) -> p.string).join(' ')

  processStatements = (statements) ->
    _(statements).map (s) ->
      switch s.type
        when 'content' then s.string
        when 'block'
          isToken = _(tokens).include(s.mustache.id.original)
          arr = ["{{", (if isToken then '#' else ''), s.mustache.id.original, paramsToString(s.mustache.params), "}}"]
          arr.push processStatements(s.program.statements) if s.program?
          arr.push ['{{else}}', processStatements(s.inverse.statements)] if s.inverse?.statements.length > 0
          arr.push "{{/#{s.mustache.id.original}}}" if isToken
          arr
        when 'mustache'
          if s.isHelper.pairs?
            "{{bind-attr #{pairsToAttrString(s.isHelper.pairs)}}}"
          else
            arr = ["{{", s.id.original, paramsToString(s.params), pairsToAttrString(s.hash?.pairs), "}}"]
            arr.push processStatements(s.program.statements) if s.program?
            arr.push "{{/#{s.id.original}}}" if _(tokens).include(s.id.original)
            arr
        else ''

  _(processStatements(result.statements)).flatten().join('')
  
module.exports = Processor
