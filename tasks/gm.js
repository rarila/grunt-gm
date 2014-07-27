module.exports = function(grunt) {
  var fs, mkdirp, path;
  fs = require('fs');
  mkdirp = require('mkdirp');
  path = require('path');
  grunt.task.registerMultiTask('gm', function() {
    var SKIP_EXISTING, STOP_ON_ERROR, count, done, errorItems, files, next, opts, skipExisting, skippedItems, stopOnError, total;
    done = this.async();
    files = this.files;
    opts = this.data.options;
    skippedItems = [];
    errorItems = [];
    skipExisting = opts.skipExisting;
    stopOnError = opts.stopOnError;
    SKIP_EXISTING = grunt.option('skipExisting');
    STOP_ON_ERROR = grunt.option('stopOnError');
    count = 0;
    total = files.length;
    (next = function(file) {
      var args, cmd, dir, name, _ref, _ref1, _skipExisting, _stopOnError;
      if (!file) {
        if (skippedItems.length) {
          grunt.log.subhead("" + skippedItems.length + " items skipped:");
          grunt.log.writeln(grunt.log.wordlist(skippedItems, {
            color: 'cyan',
            separator: '\n'
          }));
        }
        if (errorItems.length) {
          grunt.log.subhead("" + errorItems.length + " items with error:");
          grunt.log.writeln(grunt.log.wordlist(errorItems, {
            color: 'red',
            separator: '\n'
          }));
        }
        return done(true);
      }
      count++;
      _skipExisting = (_ref = file.options) != null ? _ref.skipExisting : void 0;
      _stopOnError = (_ref1 = file.options) != null ? _ref1.stopOnError : void 0;
      if (_skipExisting === void 0) {
        _skipExisting = skipExisting;
      }
      if (_stopOnError === void 0) {
        _stopOnError = stopOnError;
      }
      if (SKIP_EXISTING !== void 0) {
        _skipExisting = SKIP_EXISTING;
      }
      if (STOP_ON_ERROR !== void 0) {
        _stopOnError = STOP_ON_ERROR;
      }
      grunt.log.write("Processing " + file.src + "... ");
      if (_skipExisting && grunt.file.exists(file.dest) && fs.statSync(file.dest).size) {
        grunt.log.writeln("skipped, " + count + "/" + total);
        skippedItems.push(file.dest);
        return next(files.shift());
      }
      if (!grunt.file.exists((dir = path.dirname(file.dest)))) {
        mkdirp(dir);
      }
      cmd = "require(\"" + __dirname + "/../node_modules/gm\")(\"" + file.src + "\")";
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
        if (e || !grunt.file.exists(file.dest)) {
          grunt.log.error("Not written: " + file.dest + ", " + count + "/" + total);
          errorItems.push(file.dest);
          if (_stopOnError) {
            return done(false);
          }
        } else {
          from = fs.statSync(file.src[0]).size;
          to = fs.statSync(file.dest).size;
          grunt.log.write(grunt.log.wordlist([(from / 1000).toFixed(2) + ' kB', (to / 1000).toFixed(2) + ' kB'], {
            color: 'green',
            separator: ' → '
          }));
          grunt.log.writeln(", " + ((((to - from) / from) * 100).toFixed(2)) + "%, " + count + "/" + total);
        }
        return next(files.shift());
      });
    })(files.shift());
    return null;
  });
  return null;
};
