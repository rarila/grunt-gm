module.exports = function(grunt) {
  var fs, mkdirp, path;
  fs = require('fs');
  mkdirp = require('mkdirp');
  path = require('path');
  grunt.task.registerMultiTask('gm', function() {
    var done, files, next, pos, total;
    done = this.async();
    files = this.files;
    pos = 0;
    total = files.length;
    (next = function(file) {
      var args, cmd, dir, name;
      if (!file) {
        return done(true);
      }
      if (!grunt.file.exists((dir = path.dirname(file.dest)))) {
        mkdirp(dir);
      }
      grunt.log.write("Processing " + file.src + "... ");
      cmd = 'require("gm")("' + file.src + '")';
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
      cmd += ".write(\"" + file.dest + "\",function(e){if(e)throw new Error(e)})";
      grunt.verbose.write("" + process.argv[0] + " -e '" + cmd + "'... ");
      return grunt.util.spawn({
        cmd: process.argv[0],
        args: ['-e', cmd],
        opts: {
          stdio: 'inherit'
        }
      }, function(e) {
        var from, to;
        if (e) {
          return done(false);
        }
        from = fs.statSync(file.src[0]).size;
        to = fs.statSync(file.dest).size;
        grunt.log.write(grunt.log.wordlist([(from / 1000).toFixed(2) + ' kB', (to / 1000).toFixed(2) + ' kB'], {
          color: 'green',
          separator: ' → '
        }));
        grunt.log.writeln(", " + ((((to - from) / from) * 100).toFixed(2)) + "%, " + (pos++) + "/" + total);
        return next(files.shift());
      });
    })(files.shift());
    return null;
  });
  return null;
};
