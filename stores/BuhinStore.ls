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
    console.log it
  fetchFailed: ->
    @fetching = false
    console.log it

module.exports = alt.createStore BuhinStore
