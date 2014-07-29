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
            src: ['**/*', '!**/out/*', '!{film,sample}.png']
            options:
              skipExisting: false
              stopOnError: true
            tasks: [
                options: [{imageMagick:true}]
                resize: [200]
                command: ['composite']
                in: ['test/sample.png']
              ,
                gravity: ['Center']
                extent: [400, 360]
              ,
                command: ['composite']
                in: ['test/film.png']
            ]
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadTasks 'tasks'

  grunt.registerTask 'default', ['gm']
