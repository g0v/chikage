require! {
  '../alt'
  'superagent-bluebird-promise': request
}

const server = 'http://chikage.linode.caasih.net'

class BuhinActions
  ->
    @generateActions 'willFetch', 'didFetch', 'fetchFailed'
  fetch: (id) ->
    request.get "#server/#id.json"
      .then (res) ->
        @actions.didFetch res.body
      .catch @actions.fetchFailed

module.exports = alt.createActions BuhinActions
