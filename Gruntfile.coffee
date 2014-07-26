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
        files: [
            cwd: 'test'
            dest: 'test/out'
            expand: true
            filter: 'isFile'
            src: ['**/*', '!**/out/*']
            tasks:
              options: [{imageMagick:true}]
              noProfile: []
              resize: [200]
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadTasks 'tasks'

  grunt.registerTask 'default', ['gm']
