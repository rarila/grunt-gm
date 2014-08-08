module.exports = (grunt) ->

  fs = require 'fs'
  gm = require 'gm'
  mkdirp = require 'mkdirp'
  path = require 'path'

  grunt.task.registerMultiTask 'gm', ->

    done = @async()
    files = @files
    opts = @data.options
    skippedItems = []
    errorItems = []

    # flags
    skipExisting = opts.skipExisting
    stopOnError = opts.stopOnError
    SKIP_EXISTING = grunt.option 'skipExisting'
    STOP_ON_ERROR = grunt.option 'stopOnError'

    # for log
    count = 0
    total = files.length

    (next = (file) ->

      # done
      if not file
        if skippedItems.length
          grunt.log.subhead "#{skippedItems.length} items skipped:"
          grunt.log.writeln grunt.log.wordlist skippedItems,
            color: 'cyan', separator: '\n'
        if errorItems.length
          grunt.log.subhead "#{errorItems.length} items with error:"
          grunt.log.writeln grunt.log.wordlist errorItems,
            color: 'red', separator: '\n'
        return done true

      # refs
      count++
      _skipExisting = file.options?.skipExisting
      _stopOnError = file.options?.stopOnError
      if _skipExisting is undefined then _skipExisting = skipExisting
      if _stopOnError is undefined then _stopOnError = stopOnError
      if SKIP_EXISTING isnt undefined then _skipExisting = SKIP_EXISTING
      if STOP_ON_ERROR isnt undefined then _stopOnError = STOP_ON_ERROR

      grunt.log.write "Processing #{file.src}... "

      # skip if set
      if _skipExisting and
      grunt.file.exists(file.dest) and fs.statSync(file.dest).size
        grunt.log.writeln "skipped, #{count}/#{total}"
        skippedItems.push file.dest
        return next files.shift()

      # create dest
      mkdirp dir if not grunt.file.exists (dir = path.dirname file.dest)

      # form inline cmd
      handle = gm file.src[0]
      for task, i in file.tasks
        for name, args of task
          handle = handle[name].apply handle, args
        grunt.verbose.write "#{JSON.stringify handle.args()}... "
        if i isnt file.tasks.length
          handle = gm handle.stream(), file.src[0]

      handle.write file.dest, (e) ->
        # gm err or file write err
        if e or not grunt.file.exists file.dest
          grunt.log.error "Not written: #{file.dest}, #{count}/#{total}"
          grunt.log.writeln arguments[2]
          errorItems.push file.dest
          return done false if _stopOnError
        else
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
