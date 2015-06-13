##
# server.ls
##
# original author: @yhsiang
require! <[ express redis cors ./dump ]>
require! {
  'prelude-ls': { fold }
}

{ REDIS_IP, REDIS_PORT, PORT = 8080 } = process.env
console.log "connect to #REDIS_IP:#REDIS_PORT"

client = redis.create-client +REDIS_PORT, REDIS_IP
client.on 'error' -> console.log it

const fetchTree = (client, id, done) ->
  err, reply <- client.get "#id.json"
  if err then return done err
  to-fetch = []
  count = 0
  buhin = JSON.parse reply
  to-fetch = buhin.data
    |> fold ((acc, op) -> if op.type is 'link' then acc ++ [op] else acc), []
  for op in to-fetch
    err, body <- fetchTree client, op.src
    if err then return done err
    op <<< body
    ++count
    if count is to-fetch.length then done void, buhin

app = express!
app
  .use cors!
  .get '/:id' (req, res) ->
    if req.params.id
      {id} = req.params
      if id.match /(.*)\.json$/ then
        err, reply <- fetchTree client, RegExp.$1
        if err then res.sendStatus 500
        res.json reply
      else
        err, reply <- client.get id
        if err then res.sendStatus 404
        res.send reply
    else res.json 'KAGE API'
  .put '/dump' (req, res) ->
    entry-count <- dump
    res.json entry-updated: entry-count

app.listen PORT, -> console.log "server listen on #{PORT}"
