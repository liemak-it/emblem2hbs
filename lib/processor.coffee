fs = require("fs")
emblem = require("emblem")
emberHandlebars = require("ember-handlebars")
_ = require("underscore")

Processor = {}

Processor.process = (input) ->

  emblem.handlebarsVariant = emberHandlebars
  result = emblem.parse(input)
  
  handlebarsStringForValue = (value) ->
    switch value.type
      when "STRING" then "\"#{value.string}\""
      when "ID" then value.original
      when "BOOLEAN" then value.bool
      when "INTEGER" then value.integer
      else throw new Error("Unsupported value type: #{value.type}")

  pairsToAttrString = (pairs) ->
    return '' unless pairs? && pairs.length > 0
    ' ' + _(pairs).map((arr) ->
      key = arr[0]
      value = handlebarsStringForValue(arr[1])

      "#{key}=#{value}"
    ).join(' ').trim()

  paramsToString = (params) ->
    return '' unless params? && params.length > 0
    ' ' + _(params).map((p) -> handlebarsStringForValue(p)).join(' ')

  processStatements = (statements) ->
    _(statements).map (s) ->
      switch s.type
        when 'content' then s.string
        when 'block'
          arr = ["{{", '#', s.mustache.id.original, paramsToString(s.mustache.params), pairsToAttrString(s.mustache.hash?.pairs), "}}"]
          arr.push processStatements(s.program.statements) if s.program?
          arr.push ['{{else}}', processStatements(s.inverse.statements)] if s.inverse?.statements.length > 0
          arr.push "{{/#{s.mustache.id.original}}}"
          arr
        when 'mustache'
          arr = ["{{", s.id.original, paramsToString(s.params), pairsToAttrString(s.hash?.pairs), "}}"]
          arr.push processStatements(s.program.statements) if s.program?
          arr
        else ""

  _(processStatements(result.statements)).flatten().join('')
  
module.exports = Processor
