module.exports = (grunt) ->

  grunt.loadTasks 'tasks'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.initConfig
    coffee:
      compile:
        options:
          bare: true
        files:
          'tasks/gm.js': 'src/gm.coffee'

  grunt.registerTask 'default', ['coffee']
