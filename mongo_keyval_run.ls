keyval = require './mongo_keyval'

#keyval.set 'foo', {a: 3, b: 5}
keyval.get 'foo', (res) ->
  console.log res.a
