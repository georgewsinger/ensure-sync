#! /usr/bin/env node

var min = require('minimist');
var argv = min(process.argv.slice(2));
//var exec = require('child_process').exec;

//var one = argv["_"][0] ? argv["_"][0] : "1.day";
//var two = argv["_"][1] ? argv["_"][1] : "~";

//function puts(error, stdout, stderr) { console.log(stdout) };
//exec("./gg-log.sh " + one + " " + two, puts);

var prompt = require('prompt');
//prompt.message = "prompt (default value)";
//prompt.delimiter = "";


var schema = {
  properties: {
    ssh1: {
		  description: 'ssh1 description',
      message: 'ssh1 message',
      default: 'george@192.168.1.2'
    },
    port1: {
		  description: 'Port1 description',
      message: 'Port1 message',
      default: '58002'
    }
  }
};

prompt.start();

prompt.get(schema, function (err, result) {
  if (err) { return onErr(err); }
  console.log('Command-line input received:');
  console.log('  ssh1: ' + result.ssh1);
  console.log('  port1: ' + result.port1);
});

function onErr(err) {
  console.log(err);
  return 1;
}

