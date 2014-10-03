extend = require 'extend'
fs = require 'fs'
gm = require 'gm'
mkdirp = require 'mkdirp'
path = require 'path'

module.exports = (grunt) ->

  grunt.task.registerMultiTask 'gm', ->

    # refs
    done = @async()
    skippedItems = []
    errorItems = []

    # for log
    count = 0
    total = @files.length

    (next = (file, files) =>

      # stop the loop and dump summary
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
      opts = extend {}, @data.options, file.options,
        skipExisting: grunt.option 'skipExisting'
        stopOnError: grunt.option 'stopOnError'

      # skip
      if opts.skipExisting and
      fs.existsSync(file.dest) and fs.statSync(file.dest).size
        grunt.verbose.writeln "Processing #{file.src}...skipped, #{count}/#{total}"
        skippedItems.push file.dest
        next files.shift(), files

      # process
      else

        grunt.log.write "Processing #{file.src}..."

        # create dest
        mkdirp dir if not fs.existsSync (dir = path.dirname file.dest)

        # create gm proc
        proc = gm file.src[0]

        # loop tasks
        for task, i in file.tasks

          # inject task
          for name, args of task

            # parse task args
            _args = []
            for arg in args
              if typeof arg is 'function'
                _args.push arg extend true, {}, {options:opts}, file
              else _args.push arg

            # let gm setup task
            proc = proc[name].apply proc, _args

          # dump gm args
          grunt.verbose.write "\n  #{proc.args().join ' '}"

          # create new gm proc with prev output as stream input, and continue
          proc = gm proc.stream(), file.src[0] if i isnt file.tasks.length

        # tidy verbose log
        grunt.verbose.write '\n'

        # run task, and write dest, asynchronously
        proc.write file.dest, (e) ->

          # gm err or file write err
          if e or not fs.existsSync file.dest
            grunt.log.error "Not written: #{file.dest}, #{count}/#{total}"
            grunt.log.writeln arguments[2]
            errorItems.push file.dest
            return done false if opts.stopOnError

          # dump result
          else
            from = fs.statSync(file.src[0]).size
            to = fs.statSync(file.dest).size
            grunt.log.write grunt.log.wordlist [
              (from / 1000).toFixed(2) + ' kB'
              (to / 1000).toFixed(2) + ' kB'
            ], color: 'green', separator: ' → '
            grunt.log.writeln ", #{(((to - from) / from) * 100).toFixed 2}%, #{count}/#{total}"

          # continue
          next files.shift(), files

    ) @files.shift(), @files

    null

  null
