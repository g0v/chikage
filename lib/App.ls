require! {
  'react': { Component, PropTypes, { svg, g, line }:DOM }:React
  'react/addons': { { PureRenderMixin, classSet:cx }:addons }
  'alt/AltContainer'
  '../stores/BuhinStore'
  './Buhin'
}

AltContainer = React.createFactory AltContainer
Buhin = React.createFactory Buhin

class App extends Component implements PureRenderMixin
  (@props) ->
  render: ~>
    { className = '', children = [] } = @props
    AltContainer do
      stores: { BuhinStore }
      transform: ({ BuhinStore }) -> BuhinStore.data
      Buhin!

module.exports = App

