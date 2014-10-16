fs = require("fs")
emblem = require("emblem")
handlebars = require("handlebars")
html = require('html')
_ = require("underscore")

emblem.handlebarsVariant = handlebars
buf = fs.readFileSync("lib/slider.emblem", "utf8")
result = emblem.parse(buf)

processStatements = (statements) ->
  _(statements).map (s) ->
    switch s.type
      when 'content' then s.string
      when 'block'
        debugger
        r = ["{{#{s.mustache.id.original} #{_(s.mustache.params).map((p) -> p.string).join(' ')}}}"]
        if s.program?
          r.push processStatements(s.program.statements)
        r
      else ''

output = _(processStatements(result.statements)).flatten().join('')
fs.writeFileSync "output.hbs", html.prettyPrint(output)