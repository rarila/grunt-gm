module.exports = (grunt) ->

  fs = require 'fs'
  gm = require 'gm'

  grunt.task.registerMultiTask 'gm', ->
    for file in @files
      grunt.log.write "Processing #{file.src}... "
      cmd = "gm(\"#{file.src}\")"
      for name of file.tasks
        args = file.tasks[name].map (arg) ->
          if typeof arg isnt 'object' then arg
          else JSON.stringify arg
        cmd += ".#{name}(#{args})"
      cmd += ".write(\"#{file.dest}\",console.log)"
      from = fs.statSync(file.src[0]).size
      to = fs.statSync(file.dest).size
      grunt.log.write grunt.log.wordlist [
        (from / 1000).toFixed(2) + ' kB'
        (to / 1000).toFixed(2) + ' kB'
      ], color: 'green', separator: ' → '
      grunt.log.writeln ", #{(((to - from) / from) * 100).toFixed 2}%"
      grunt.log.debug cmd
      eval "#{cmd}"
