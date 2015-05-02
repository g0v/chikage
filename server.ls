##
# server.ls
##
# original author: @yhsiang
require! <[ express redis ]>

client = redis.create-client!
client.on 'error' -> console.log it

app = express!
PORT = process.env.PORT || 8080


app.get '/:id' (req, res) ->
  if req.params.id
    {id} = req.params
    err, reply <- client.get id
    reply = JSON.parse reply if id.match /json$/
    res.json data: reply
  else res.json 'KAGE API'

app.listen PORT, -> console.log "server listen on #{PORT}"
