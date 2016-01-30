#! /usr/bin/env node

var min = require('minimist');
var argv = min(process.argv.slice(2));
//var exec = require('child_process').exec;

//var one = argv["_"][0] ? argv["_"][0] : "1.day";
//var two = argv["_"][1] ? argv["_"][1] : "~";


var prompt = require('prompt');
prompt.message = "";
prompt.delimiter = "";


var schema = {
  properties: {
    targetSSH: {
      description: '    ssh (i.e., user@192.168.1.2):'
      //message: 'ssh1 message',
      //default: 'george@192.168.1.2'
    },
    targetPort: {
      description: '    port (i.e., 22):'
      //message: 'Port1 message',
      //default: '58002'
    },
    targetDir: {
      description: '    target directory (i.e., ~/Dropbox):'
      //message: 'Port1 message',
      //default: '58002'
    }
  }
};

console.log("Please enter the SSH address of your target computer.");
prompt.start();

prompt.get(schema, function (err, result) {
  if (err) { return onErr(err); }
  /*
  console.log('  ssh: ' + result.targetSSH);
  console.log('  port: ' + result.targetPort);
  console.log('  port: ' + result.targetDir);
  */
  console.log('Ensuring ' + result.targetDir + ' is synced at ' + result.targetSSH + ":" + result.targetPort);

  //function puts(error, stdout, stderr) { console.log(stdout) };
  //exec("./ensure-sync.sh " + result.targetDir + " " + result.targetSSH + " " + result.targetPort, puts);
});

function onErr(err) {
  console.log(err);
  return 1;
}

