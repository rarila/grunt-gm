# grunt-gm v0.0.0

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


### The Task
See [basic usages][2].
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
`gm("test/gruntjs.png").options({"imageMagick":true}).noProfile().resize(200).write("test/out/gruntjs.png",console.log)`



## Release History



[1]: http://aheckmann.github.io/gm
[2]: https://github.com/aheckmann/gm#basic-usage

