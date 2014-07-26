module.exports = function(grunt) {
  var fs, gm;
  fs = require('fs');
  gm = require('gm');
  return grunt.task.registerMultiTask('gm', function() {
    var args, cmd, file, from, name, to, _i, _len, _ref, _results;
    _ref = this.files;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      file = _ref[_i];
      grunt.log.write("Processing " + file.src + "... ");
      cmd = "gm(\"" + file.src + "\")";
      for (name in file.tasks) {
        args = file.tasks[name].map(function(arg) {
          if (typeof arg !== 'object') {
            return arg;
          } else {
            return JSON.stringify(arg);
          }
        });
        cmd += "." + name + "(" + args + ")";
      }
      cmd += ".write(\"" + file.dest + "\",console.log)";
      from = fs.statSync(file.src[0]).size;
      to = fs.statSync(file.dest).size;
      grunt.log.write(grunt.log.wordlist([(from / 1000).toFixed(2) + ' kB', (to / 1000).toFixed(2) + ' kB'], {
        color: 'green',
        separator: ' → '
      }));
      grunt.log.writeln(", " + ((((to - from) / from) * 100).toFixed(2)) + "%");
      grunt.verbose.writeln(cmd);
      _results.push(eval("" + cmd));
    }
    return _results;
  });
};
