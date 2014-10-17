#!/usr/bin/env coffee

fs = require("fs")
emblem = require("emblem")
handlebars = require("handlebars")
emberHandlebars = require("ember-handlebars")
html = require('html')
_ = require("underscore")

emblem.handlebarsVariant = emberHandlebars

emblemFile = process.argv[2]
hbsFile = emblemFile.substr(0, emblemFile.lastIndexOf(".")) + ".js.hbs";

buf = fs.readFileSync(emblemFile, "utf8")
result = emblem.parse(buf)

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

tagsArray = _(processStatements(result.statements)).flatten().join('').match(/<.+?>|{{.+?}}|[^<>{}]+/g);
_(tagsArray).reject((t,i,ctx) -> t == '{{else}}' && _(['{{/if}}', '{{/unless}}']).include(ctx[i+1]))

indent = -1
prevTag = ''
currentTag = ''
prevTagIsOpening = false
prevTagIsElse = false
prevTagIsSelfClosed = false
prevTagIsClosed = false
spaced = tagsArray.map (t) ->
  isElse = t == '{{else}}'
  isOpening = t[1] != '/' && t[2] != '/' && !isElse
  isClosing = t.indexOf('</') == 0 || t.indexOf('{{/') == 0
  isTokenTag = isElse || t.indexOf('{{#') == 0 || t.indexOf('{{/') == 0
  isPlainString = _.intersection(['{', '<'], t.match(/./g)).length == 0
  isMustachey = t[0] == '{' && t[t.length-1] == '}'
  isHtmlSelfClosing = t[0] == '<' && t[t.length-2] == '/'
  isSelfClosed =  isPlainString || isHtmlSelfClosing || (isMustachey && !isTokenTag)
  currentTag = t.match(/\w+/)[0]
  unless !isElse && (((isOpening || isSelfClosed) && prevTagIsSelfClosed) || (prevTagIsClosed && !isClosing) || prevTagIsOpening && isClosing && (prevTag == currentTag))
    indent += (if isOpening then 1 else -1) 
  prevTag = currentTag
  prevTagIsOpening = isOpening
  prevTagIsClosed = isClosing
  prevTagIsElse = isElse
  prevTagIsSelfClosed = isSelfClosed
  (if indent == 0 then '' else ("  " for n in [0..indent-1]).join('')) + t
fs.writeFileSync hbsFile, spaced.join("\n")


