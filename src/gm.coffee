module.exports = (grunt) ->

  fs = require 'fs'
  mkdirp = require 'mkdirp'
  path = require 'path'

  grunt.task.registerMultiTask 'gm', ->

    done = @async()
    files = @files
    opts = @data.options

    # flags
    skipExisting = grunt.option('skipExisting') or opts.skipExisting

    # for log
    count = 0
    total = files.length

    (next = (file) ->
      count++

      # done
      return done true if not file

      # skip if set
      if (skipExisting or file.options?.skipExisting) and
      grunt.file.exists(file.dest) and fs.statSync(file.dest).size
        return next files.shift()

      # create dest
      mkdirp dir if not grunt.file.exists (dir = path.dirname file.dest)

      # form inline cmd
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

      # run
      grunt.util.spawn
          cmd: process.argv[0]
          args: ['-e', cmd]
          opts: stdio: 'inherit'
        , (e) ->
          # end early
          return done false if e
          from = fs.statSync(file.src[0]).size
          to = fs.statSync(file.dest).size
          grunt.log.write grunt.log.wordlist [
            (from / 1000).toFixed(2) + ' kB'
            (to / 1000).toFixed(2) + ' kB'
          ], color: 'green', separator: ' → '
          grunt.log.writeln ", \
            #{(((to - from) / from) * 100).toFixed 2}%, \
            #{count}/#{total}"
          # next
          next files.shift()

    ) files.shift()

    null

  null
