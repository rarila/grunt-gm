module.exports = (grunt) ->

  fs = require 'fs'

  grunt.task.registerMultiTask 'gm', ->
    files = @files
    done = @async()

    (next = (file) ->
      return done true if not file
      grunt.log.write "Processing #{file.src}... "
      cmd = 'require("gm")("' + file.src + '")'
      for name of file.tasks
        args = file.tasks[name].map (arg) ->
          if typeof arg isnt 'object' then arg
          else JSON.stringify arg
        cmd += ".#{name}(#{args})"
      cmd += ".write(\"#{file.dest}\",function(e){if(e)throw new Error(e)})"
      grunt.util.spawn
          cmd: process.argv[0]
          args: ['-e', cmd]
          opts: stdio: 'inherit'
        , (e) ->
          return done false if e
          from = fs.statSync(file.src[0]).size
          to = fs.statSync(file.dest).size
          grunt.log.write grunt.log.wordlist [
            (from / 1000).toFixed(2) + ' kB'
            (to / 1000).toFixed(2) + ' kB'
          ], color: 'green', separator: ' → '
          grunt.log.writeln ", #{(((to - from) / from) * 100).toFixed 2}%"
          next files.shift()
    ) files.shift()

    null

  null
