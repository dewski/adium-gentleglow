exportsObjects = {}
modules = {}

define = (id, module) ->
  module.id = id
  modules[id] = module

require = (id) ->
  if exportsObjects.hasOwnProperty id
    exportsObjects[id]
  else
    if module = modules[id]
      exportsObjects[id] = module(window, module, exports = {}, require) ? exports
    else
      throw Error "module not found: #{id}"

run = (id) ->
  require id
  return

[@define, @require, @run] = [define, require, run]
