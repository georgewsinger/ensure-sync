#! /usr/bin/env node

var min = require('minimist');
var argv = min(process.argv.slice(2));
var exec = require('child_process');

var prompt = require('prompt');
prompt.message = "";
prompt.delimiter = "";


var schema = {
  properties: {
    targetSSH: {
      description: '    ssh (i.e., user@192.168.1.2):'
    },
    targetPort: {
      description: '    port (i.e., 22):'
    },
    sourceDir: {
      description: '    source directory (use full path i.e., /home/user/Dropbox):'
    },
    targetDir: {
      description: '    target directory (use full path i.e., /home/user/Dropbox):'
    }
  }
};

console.log("Please enter the SSH address of your target computer.");
prompt.start();

prompt.get(schema, function (err, result) {
  if (err) { return onErr(err); }

  console.log("Computing differences between folders (this may take several seconds)..");

  function puts(error, stdout, stderr) { console.log(stdout); };
  exec.execFile(__dirname + "/ensure-sync.sh", ["local", result.sourceDir, "ssh -p " + result.targetPort + " " + result.targetSSH, result.targetDir], puts);
});

function onErr(err) {
  console.log(err);
  return 1;
}

