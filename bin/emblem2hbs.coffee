#!/usr/bin/env coffee

fs = require("fs")
processor = require('../lib/processor')
indentation = require('../lib/indentation')

emblemFile = process.argv[2]
hbsFile = emblemFile.substr(0, emblemFile.lastIndexOf(".")) + ".js.hbs";

buf = fs.readFileSync(emblemFile, "utf8")
output = processor.process(buf)
fs.writeFileSync hbsFile, indentation.indent(output)