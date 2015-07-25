##
# chikage server
# original author: @yhsiang
require! <[ express redis cors body-parser method-override morgan punycode ./dump ]>
require! {
  'prelude-ls': { id, fold, map, filter, flatten, unique, obj-to-lists, lists-to-obj, is-type }
  'bluebird': { all }:Promise
}

{ REDIS_IP = '127.0.0.1', REDIS_PORT = 6379, PORT = 8080 } = process.env
console.log "connect to #REDIS_IP:#REDIS_PORT"

client = redis.create-client +REDIS_PORT, REDIS_IP
client.on 'error' ->
  message = 'Redis is not running!'
  console.warn message
  client := do
    get: (id, done) ->
      id .= replace /\.json/, ''
      done void, JSON.stringify data: { id, related: id, data: [], message }

const peek = ->
  console.log JSON.stringify it,, 2
  it

const cry = ->
  console.error it
  it

cache = {}
const get = (gid) -> cache[gid] or= new Promise (resolve, reject) ->
  err, reply <- client.get gid
  if err then
    reject err
  else if not reply then
    reject new Error "#gid not found"
  else
    resolve reply

const fetchTree = (gid) ->
  get "#gid.json"
    .then ->
      to-fetch = []
      buhin = JSON.parse it
      to-fetch = buhin.data
        |> fold ((acc, op) -> if op.type is 'link' then acc ++ [op] else acc), []
      if to-fetch.length is 0 then return buhin
      ps = for let op in to-fetch
        fetchTree op.src
          .then -> op <<< it
      all ps .then -> buhin

const every = ->
  | it.then               => it.then every
  | it |> is-type \String => Promise.resolve it
  | it |> is-type \Array  => it |> map every |> all
  | otherwise             =>
    [ks, vs] = obj-to-lists it
    every vs
      .then lists-to-obj ks

const fetchKageTree = (gid) ->
  get gid
    .then ->
      id: gid
      data: it
      children: Promise.resolve it.split \$
        .then map ->
          if re = /99:(-?\d+):(-?\d+):(-?\d+):(-?\d+):(\d+):(\d+):([^:@]+)/exec it then
            [, u, v, x, y, w, h, part] = re
            fetchKageTree part
        .then all
        .then filter id

const flattenTree = (tree) ->
  fold do
    (acc, child) -> acc <<< flattenTree child
    "#{tree.id}": tree.data
    tree.children

const fetchExploded = (gid) ->
  fetchKageTree gid
    .then every
    .then flattenTree

app = express!
app
  .use cors!
  .use body-parser.json!
  .use body-parser.urlencoded extended: true
  .use method-override!
  .use express.static \public
  .use morgan \common
  .use (req, res, next) ->
    res.set \Connection \close
    next!
  .get '/forest' (req, res) ->
    inputs = punycode.ucs2.decode req.query.inputs
    Promise.resolve inputs
      .then map -> "u#{it.toString 16}"
      .then map fetchKageTree
      .then every
      .then  -> res.json it
      .catch -> res.status 500 .json cry it
  .get '/exploded' (req, res) ->
    inputs = punycode.ucs2.decode req.query.inputs
    Promise.resolve inputs
      .then map -> "u#{it.toString 16}"
      .then map fetchExploded
      .then all
      .then fold (<<<), {}
      .then  -> res.json it
      .catch -> res.status 500 .json cry it
  .get '/:id' (req, res) ->
    if req.params.id
      { id } = req.params
      id = decodeURI id
      if id.match /(.*)\.json$/ then
        fetchTree RegExp.$1
          .then  -> res.json it
          .catch -> res.status 500 .json cry it
      else
        get id
          .then  -> res.send it
          .catch -> res.sendStatus 404
    else res.json 'KAGE API'
  .put '/dump' (req, res) ->
    entry-count <- dump
    cache := {}
    res.json entry-updated: entry-count

server = app.listen PORT, -> console.log "server listen on #{PORT}"

process.on \SIGINT ->
  server.close ->
    console.log "\nbye"
    process.exit!
