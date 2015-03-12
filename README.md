# mongo_keyval

simple key-value store api on top of mongodb

## Install

    npm install mongo_keyval

## Using

Setting a value. Value can be anything that is JSON-serializable: string, array, object

```javascript
var keyval = require('mongo_keyval')
keyval.set('somekey', 'someval')
keyval.set('otherkey', {some_object: 'yay json'})
```

Can optionally provide a callback to be called when setting is complete:

```javascript
keyval.set('somekey', 'someval', function(val) {
  console.log('finished setting somekey to ' + val)
})
```

Use get to get values:

```javascript
keyval.get('somekey', function(val) {
  console('value for somekey is ' + val)
})
```

## Mongo details

If using Heroku, your mongo url will automatically be used, from the following sources:

* process.env.MONGOHQ_URL
* process.env.MONGOLAB_URI
* process.env.MONGOSOUP_URL

Otherwise, the default url will be the local mongo instance:

* mongodb://localhost:27017/default

You can manually specify the mongo URL by setting mongo_keyval.mongourl

Keys are values are stored in the collection 'vars'
