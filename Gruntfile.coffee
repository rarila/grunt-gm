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
            src: ['**/*', '!**/out/*']
            options:
              skipExisting: true
              stopOnError: true
            tasks:
              options: [{imageMagick:true}]
              noProfile: []
              resize: [200]
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadTasks 'tasks'

  grunt.registerTask 'default', ['gm']
