# grunt-gm v0.1.1

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


### The Task
See [basic usages][4].
```javascript
grunt.initConfig({
  gm: {
    test: {
      files: [
        {
          cwd: 'test',
          dest: 'test/out',
          expand: true,
          filter: 'isFile',
          src: ['**/*', '!**/out/*'],
          tasks: {
            options: [{imageMagick: true}],
            noProfile: [],
            resize: [200]
          }
        }
      ]
    }
  }
});
```
Task will traverse the file list and execute `gm` tasks one by one, top down.

Grunt with `--verbose` flag to print the corresponding commands:
`node -e 'require("gm")("test/gruntjs.png").options({"imageMagick":true}).noProfile().resize(200).write("test/out/gruntjs.png"...`



## Release History

 * 2014-07-27   v0.1.1   Fix log dump and `mkdir -p dest` if not exists
 * 2014-07-27   v0.1.0   Initial release



[1]: http://aheckmann.github.io/gm
[2]: http://www.graphicsmagick.org
[3]: http://www.imagemagick.org
[4]: https://github.com/aheckmann/gm#basic-usage

