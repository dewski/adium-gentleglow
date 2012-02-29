Console = require 'console'
resources = require 'resources'

storage = global.localStorage
namespace = 'preferences'

specs = resources.get 'data/preferences'

types =
  boolean: (val) -> if val then true else false
  number: (val) -> +val
  string: (val) -> "#{val}"

exports.get = (key) ->
  if spec = specs[key]
    if value = storage.getItem "#{namespace}:#{key}"
      JSON.parse value
    else
      spec.default
  else
    Console.warn "invalid preference key #{key}"
    return

exports.set = (key, value) ->
  if spec = specs[key]
    if value?
      storage.setItem "#{namespace}:#{key}", JSON.stringify(value)
    else
      storage.removeItem "#{namespace}:#{key}"
  else
    Console.warn "invalid preference key #{key}"
    return

exports.label = (key) -> specs[key]?.label
  
exports.each = (options, fn) ->
  [options, fn] = [null, options] if arguments.length < 2
  for key, spec of specs
    if options?.values
      fn key, spec, this.get(key)
    else
      fn key, spec
