##
# server.ls
##
# original author: @yhsiang
require! <[ express redis ]>

{ REDIS_IP, REDIS_PORT, PORT = 8080 } = process.env
console.log "connect to #REDIS_IP:#REDIS_PORT"

client = redis.create-client +REDIS_PORT, REDIS_IP
client.on 'error' -> console.log it

app = express!


app.get '/:id' (req, res) ->
  if req.params.id
    {id} = req.params
    err, reply <- client.get id
    reply = JSON.parse reply if id.match /json$/
    res.json data: reply
  else res.json 'KAGE API'

app.listen PORT, -> console.log "server listen on #{PORT}"
