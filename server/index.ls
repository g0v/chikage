##
# chikage server
# original author: @yhsiang
require! <[ express redis cors body-parser method-override morgan punycode ./dump ]>
require! {
  'prelude-ls': { id, fold, map, filter, flatten, unique, lists-to-obj }
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

const fetchExploded = (gid) ->
  get gid
    .then ->
      ks = it.split \$
      ps = ks
        |> map ->
          if re = /99:0:0:(\d+):(\d+):(\d+):(\d+):([^:]+)/exec it then
            [, x, y, w, h, part] = re
            fetchExploded part
        |> filter id
      [gid] ++ ps
    .then all
    .then flatten

app = express!
app
  .use cors!
  .use body-parser.json!
  .use body-parser.urlencoded extended: true
  .use method-override!
  .use express.static \public
  .use morgan \dev
  .use (req, res, next) ->
    res.set \Connection \close
    next!
  .get '/exploded' (req, res) ->
    inputs = punycode.ucs2.decode req.query.inputs
    ps = inputs
      |> map -> "u#{it.toString 16}"
      |> map fetchExploded
    ks = all ps
      .then flatten
      .then unique
    vs = ks
      .then map get
      .then all
    all [ks, vs]
      .then ([ks, vs]) -> lists-to-obj ks, vs
      .then  -> res.json it
      .catch ->
        console.error it
        res.status 500 .json it
  .get '/:id' (req, res) ->
    if req.params.id
      { id } = req.params
      id = decodeURI id
      if id.match /(.*)\.json$/ then
        fetchTree RegExp.$1
          .then  -> res.json it
          .catch ->
            console.error it
            res.status 500 .json it
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
