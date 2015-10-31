#!/usr/bin/env node

require('coffee-script').register()

var fs = require('fs'),
    processor = require('../lib/processor'),
    indentation = require('../lib/indentation'),
    buf, emblemFile, hbsFile, output;

if (process.argv.length < 3) {
  console.log('USAGE: emblem2hbs filetoconvert.emblem')
} else {
  emblemFile = process.argv[2];
  hbsFile = emblemFile.substr(0, emblemFile.lastIndexOf('.')) + '.hbs';
  buf = fs.readFileSync(emblemFile, 'utf8');
  output = processor.process(buf);
  fs.writeFileSync(hbsFile, indentation.indent(output));
}
