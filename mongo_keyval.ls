require! {
  mongodb
}

{MongoClient, Grid} = mongodb

mongohq = process.env.MONGOHQ_URL
mongolab = process.env.MONGOLAB_URI
mongosoup = process.env.MONGOSOUP_URL

getmongourl = ->
  if module.exports.mongourl?
    return module.exports.mongourl
  return mongohq ? mongolab ? mongosoup ? 'mongodb://localhost:27017/default'

get-mongo-db = (callback) ->
  #MongoClient.connect mongourl, {
  #  auto_reconnect: true
  #  poolSize: 20
  #  socketOtions: {keepAlive: 1}
  #}, (err, db) ->
  MongoClient.connect getmongourl(), (err, db) ->
    if err
      console.log 'error getting mongodb'
    else
      callback db

get-vars-collection = (callback) ->
  get-mongo-db (db) ->
    collection = module.exports.collection ? 'vars'
    callback db.collection(collection), db

get = (varname, callback) ->
  # cannot have $ or . in key names
  # http://docs.mongodb.org/manual/reference/limits/#Restrictions-on-Field-Names
  if varname.indexOf('$') != -1
    varname = varname.split('$').join('＄')
  if varname.indexOf('.') != -1
    varname = varname.split('.').join('．')
  get-vars-collection (vars-collection, db) ->
    vars-collection.findOne {_id: varname}, (err, result) ->
      if not result? or not result.val?
        callback null
        db.close()
        return
      callback JSON.parse result.val
      db.close()

set = (varname, val, callback) ->
  if varname.indexOf('$') != -1
    varname = varname.split('$').join('＄')
  if varname.indexOf('.') != -1
    varname = varname.split('.').join('．')
  get-vars-collection (vars-collection, db) ->
    vars-collection.save {_id: varname, name: varname, val: JSON.stringify(val)}, (err, result) ->
      if callback?
        callback val
      db.close()

module.exports = {get, set}
