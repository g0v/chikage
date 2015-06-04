require! {
  'react': React
  './actions/BuhinActions'
  './lib/App'
  'normalize.css'
}

/\/#\/(.*)$/.test location.href
id = RegExp.$1 || \u840c

BuhinActions.fetch id

App = React.createFactory App
React.render do
  App!
  document.getElementById \app
