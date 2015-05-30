require! {
  '../alt'
  '../actions/BuhinActions'
}


class BuhinStore
  ->
    @bindActions BuhinActions
    @fetching = false
    @data = {}
  willFetch: ->
    @fetching = true
  didFetch: ->
    @fetching = false
    @data = it
  fetchFailed: ->
    @fetching = false
    console.error it

module.exports = alt.createStore BuhinStore
