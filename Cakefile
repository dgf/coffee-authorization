fs = require 'fs'
{print} = require 'util'
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors
bold = '\033[0;1m'
green = '\033[0;32m'
reset = '\033[0m'
red = '\033[0;31m'

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

call = (name, options, callback) ->
  proc = spawn name, options
  proc.stdout.on 'data', (data) -> print data.toString()
  proc.stderr.on 'data', (data) -> log data.toString(), red
  proc.on 'exit', callback

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false
  options = ['-c', '-o', 'build', 'src']
  options.unshift '-w' if watch
  call 'coffee', options, callback

spec = (callback) ->
  options = ['spec', '--coffee']
  call './node_modules/jasmine-node/bin/jasmine-node', options, callback

task 'spec', 'run specifications', ->
  build (buildStatus) ->
    if buildStatus is 0
      spec (testStatus) ->
        log ":)", green if testStatus is 0
