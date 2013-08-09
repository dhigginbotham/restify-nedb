CoffeeScript = require 'coffee-script'
{exec} = require 'child_process'
flour = require "flour"

task "build:coffee", ->
  compile './src/config.coffee', './lib/config.js'
  compile './src/crudify.coffee', './lib/crudify.js'
  compile './src/extended.coffee', './lib/extended.js'
  compile './src/index.coffee', './lib/index.js'
  compile './src/mount.coffee', './lib/mount.js'

task "build:docs", "make documentation", ->
  execOut "docco -o docs src/crudify.coffee", 
  execOut "docco -o docs src/extended.coffee", 
  execOut "docco -o docs src/config.coffee", 
  execOut "docco -o docs src/index.coffee", 
  execOut "docco -o docs src/mount.coffee", 

execOut = (commandLine) ->
  exec(commandLine, (err, stdout, stderr) ->
    console.log("> #{commandLine}")
    console.log(stdout)
    console.log(stderr)
  )