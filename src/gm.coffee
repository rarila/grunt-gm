module.exports = (grunt) ->

  fs = require 'fs'
  mkdirp = require 'mkdirp'
  path = require 'path'

  grunt.task.registerMultiTask 'gm', ->
    done = @async()
    files = @files

    # for log
    pos = 0
    total = files.length

    (next = (file) ->
      return done true if not file
      mkdirp dir if not grunt.file.exists (dir = path.dirname file.dest)
      grunt.log.write "Processing #{file.src}... "
      # TODO how to require properly with -e
      cmd = "require(\"#{__dirname}/../node_modules/gm\")(\"#{file.src}\")"
      for name of file.tasks
        args = file.tasks[name].map (arg) ->
          if typeof arg isnt 'object' then arg
          else JSON.stringify arg
        cmd += ".#{name}(#{args})"
      cmd += ".write(\"#{file.dest}\",function(e){if(e)throw new Error(e)})"
      grunt.verbose.write "#{process.argv[0]} -e '#{cmd}'... "
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
          grunt.log.writeln ", \
            #{(((to - from) / from) * 100).toFixed 2}%, \
            #{pos++}/#{total}"
          next files.shift()
    ) files.shift()

    null

  null
