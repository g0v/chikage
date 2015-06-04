require! {
  'react': { Component, PropTypes, { div, svg, g, line }:DOM }:React
  'react/addons': { { PureRenderMixin, classSet:cx }:addons }
  'alt/AltContainer'
  '../stores/BuhinStore'
  './Buhin'
  './App.styl': style
}

AltContainer = React.createFactory AltContainer
Buhin = React.createFactory Buhin

class App extends Component implements PureRenderMixin
  (@props) ->
  render: ~>
    { children = [] } = @props
    div do
      style
      AltContainer do
        stores: { BuhinStore }
        transform: ({ BuhinStore }) -> BuhinStore.data
        Buhin!

module.exports = App

