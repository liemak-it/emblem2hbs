#!/usr/bin/env node

require('coffee-script').register()

var fs = require('fs'),
    indentation = require('../lib/indentation'),
    buf, emblemFile, hbsFile, output;

if (process.argv.length < 3) {
  if (process.stdin.isTTY) {
    console.log('USAGE: `emblem2hbs filetoconvert.emblem [destinationFilename]` or in piped format `pbcopy | emblem2hbs | pbpaste`');
  }
  else {
    processFromPipe();
  }
} else {
  emblemFile = process.argv[2];
  hbsFile = process.argv[3] ? process.argv[3] : emblemFile.substr(0, emblemFile.lastIndexOf('.')) + '.hbs';
  buf = fs.readFileSync(emblemFile, 'utf8');
  output = require('emblem').default.compile(buf);
  fs.writeFileSync(hbsFile, indentation.indent(output));
}

function processFromPipe() {
  var input = process.stdin;
  var output = process.stdout;
  var error = null;
  var data = '';

  input.setEncoding('utf8');

  input.on('data', function(chunk){
    data += chunk;
  });

  input.on('end', function(){
    var converted = require('emblem').default.compile(data);
    output.end(indentation.indent(converted));
  });

  output.on('error', function(err) {
    error = err;
  });
}
