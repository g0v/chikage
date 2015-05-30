require! {
  'react': React
  './lib/App'
}

App = React.createFactory App
React.render do
  App!
  document.getElementById \app
