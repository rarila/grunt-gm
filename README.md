# grunt-gm v0.2.1

> Batch process your images with [gm][1].



## Getting Started
This plugin requires Grunt `~0.4.0`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-gm --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-gm');
```

### Overview
At the moment the task is pretty much just a simple `grunt` wrapper to [gm][1].

Before start, please verify your [GraphicsMagick][2] or [ImageMagick][3] installation by running `convert -vsersion`.

If the task ran into error `Fatal error: Maximum call stack size exceeded`, it's probably because the files array is too long. <br>To resolve this, try:
* Run `grunt` with custom stack size `node --stack-size=9999 node_modules/grunt-cli/bin/grunt gm`
* Check default by `node --v8-options | grep -B0 -A1 stack_size`

If your are on OSX, and the task ended with:
```bash
dyld: Library not loaded: /usr/local/lib/libfreetype.6.dylib
  Referenced from: /usr/local/bin/gm
  Reason: image not found
```
try `brew unlink freetype && brew link freetype`


### The Task
See [basic usages][4].
```javascript
grunt.initConfig({
  gm: {
    test: {
      options: {
        // default: false, check if dest file exists and size > 0
        skipExisting: false,
        // default: false
        stopOnError: false
      },
      files: [
        {
          cwd: 'test',
          dest: 'test/out',
          expand: true,
          filter: 'isFile',
          src: ['**/*', '!**/out/*'],
          options: {
            skipExisting: true,
            stopOnError: true
          }
          // image is passed as stream beteen tasks
          tasks: [
            {
              // resize and watermark
              options: [{imageMagick: true}],
              resize: [200],
              command: ['composite'],
              in: ['test/sample.png']
            }, {
              // extent and center the image with padding arund it
              gravity: ['Center'],
              extent: [400, 360]
            }, {
              // frame it
              options: [{imageMagick: true}],
              command: ['composite'],
              in: ['test/film.png']
            }
          ]
        }
      ]
    }
  }
});
```

Original|After Task #1|After Task #2|After Task #3
:------:|:-----------:|:-----------:|:-----------:
![gruntjs](/test/gruntjs.png?raw=true)|![gruntjs](/test/out/gruntjs-1.png?raw=true)|![gruntjs](/test/out/gruntjs-2.png?raw=true)|![gruntjs](/test/out/gruntjs-3.png?raw=true)
![gruntjs](/test/nodejs.png?raw=true)|![nodejs](/test/out/nodejs-1.png?raw=true)|![nodejs](/test/out/nodejs-2.png?raw=true)|![nodejs](/test/out/nodejs-3.png?raw=true)

* Options precedence:
  1. CLI, eg. `--skipExising`
  * File, eg. `files:[{options:{skipExising:true}}]`
  * Task, eg. `gm:{task1:{options:{skipExising:true}}`
* Task will traverse the file list and execute `gm` tasks one by one, top down.
* Grunt with `--verbose` flag to print the corresponding commands:
`node -e 'require("gm")("test/gruntjs.png").options({"imageMagick":true}).noProfile().resize(200).write("test/out/gruntjs.png"...`


## TODO
 1. ~~How to require properly? `cmd = "require(\"#{__dirname}/../node_modules/gm\")(\"#{file.src}\")"`~~ Fixed `v0.2.1`



## Release History

 * 2014-07-29   v0.2.1   Reimplement the task
 * 2014-07-28   v0.2.0   Add options `skipExisting` and `stopOnError`
 * 2014-07-27   v0.1.2   Temp fix require
 * 2014-07-27   v0.1.1   Fix log dump and `mkdir -p dest` if not exists
 * 2014-07-27   v0.1.0   Initial release



[1]: http://aheckmann.github.io/gm
[2]: http://www.graphicsmagick.org
[3]: http://www.imagemagick.org
[4]: https://github.com/aheckmann/gm#basic-usage

