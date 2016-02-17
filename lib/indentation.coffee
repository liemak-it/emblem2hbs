_ = require("underscore")

Indentation = {}

Indentation.indent = (handlebars) ->

  tagsArray = handlebars.match(/<.+?>|{{{?.+?}}}?|[^<>{}]+/g) || []
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
    wordChars = t.match(/\w+/)
    if wordChars
      currentTag = wordChars[0]
    else
      currentTag = t
    unless !isElse && (((isOpening || isSelfClosed) && prevTagIsSelfClosed) || (prevTagIsClosed && !isClosing) || prevTagIsOpening && isClosing && (prevTag == currentTag))
      indent += (if isOpening then 1 else -1)
    prevTag = currentTag
    prevTagIsOpening = isOpening
    prevTagIsClosed = isClosing
    prevTagIsElse = isElse
    prevTagIsSelfClosed = isSelfClosed
    (if indent == 0 then '' else ("  " for n in [0..indent-1]).join('')) + t

  spaced.join("\n")

module.exports = Indentation
