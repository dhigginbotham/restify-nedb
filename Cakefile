CoffeeScript = require 'coffee-script'
{exec} = require 'child_process'
fs = require 'fs'
path = require 'path'
flour = require "flour"

appFiles  = [
  'crudify',
  'extended',
  'config',
  'index',
  'mount'
]

task "build:coffee", ->
  compile './src/config.coffee', './lib/config.js'
  compile './src/crudify.coffee', './lib/crudify.js'
  compile './src/extended.coffee', './lib/extended.js'
  compile './src/index.coffee', './lib/index.js'
  compile './src/mount.coffee', './lib/mount.js'

task 'build', 'Build single application file from source files', ->
  
  _p = path.join __dirname, "lib"
  _output = path.join __dirname, "js"

  appContents = new Array remaining = appFiles.length
  
  for file, index in appFiles then do (file, index) ->
    fs.readFile "#{_p}/#{file}.coffee", "utf8", (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0

    process = ->
      fs.writeFile "#{_p}/app.coffee", appContents.join("\n\n"), "utf8", (err) ->
        throw err if err
        exec "coffee --compile -o #{_p}/../ #{_p}/app.coffee", (err, stdout, stderr) ->
          throw err if err
          console.log stdout + stderr
          fs.unlink "#{_p}/app.coffee", (err) ->
            throw err if err
            console.log "Done."

task "docs", "make documentation", ->
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