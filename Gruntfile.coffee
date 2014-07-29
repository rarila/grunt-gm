module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      compile:
        options:
          bare: true
        files:
          'tasks/gm.js': 'src/gm.coffee'
    gm:
      test:
        options:
          skipExisting: false
          stopOnError: false
        files: [
            cwd: 'test'
            dest: 'test/out'
            expand: true
            filter: 'isFile'
            src: ['**/*', '!**/out/*', '!sample.png']
            options:
              skipExisting: true
              stopOnError: true
            tasks:
              options: [{imageMagick:true}]
              resize: [300]
              command: ['composite']
              in: ['test/sample.png']
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadTasks 'tasks'

  grunt.registerTask 'default', ['gm']
