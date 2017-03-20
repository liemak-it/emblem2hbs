#!/usr/bin/env node

var fs = require('fs'),
    beautify = require('js-beautify').html,
    buf, emblemFile, hbsFile, output;

var beautifyOpts = {
  indent_size: 2,
  indent_handlebars: true,
  end_with_newline: true,
  brace_style: 'expand'
};

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
  fs.writeFileSync(hbsFile, beautify(output, beautifyOpts));
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
    output.end(beautify(converted, beautifyOpts));
  });

  output.on('error', function(err) {
    error = err;
  });
}
