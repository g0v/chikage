require! {
  'react': React
  './actions/BuhinActions'
  './lib/App'
}

BuhinActions.fetch \u840c

App = React.createFactory App
React.render do
  App!
  document.getElementById \app
