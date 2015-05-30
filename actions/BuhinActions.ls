require! {
  '../alt'
  'superagent-bluebird-promise': request
}

const server = 'http://chikage.linode.caasih.net'
const fetchTree = (buhin, onSuccess, onFailed) !->
  for let op in buhin.data
    switch op.type
      | 'link' =>
        request.get "#server/#{op.src}.json"
          .then ({ body: buhin }) ~>
            op <<< buhin
            onSuccess buhin
            fetchTree buhin, onSuccess, onFailed
          .catch onFailed

class BuhinActions
  ->
    @generateActions 'willFetch', 'didFetch', 'fetchFailed'
  fetch: (id) ->
    request.get "#server/#id.json"
      .then ({ body: buhin }) ~>
        fetchTree do
          buhin
          # update the top buhin instead of the fetched one
          ~> @actions.didFetch buhin
          @actions.fetchFailed
        @actions.didFetch buhin
      .catch @actions.fetchFailed

module.exports = alt.createActions BuhinActions
