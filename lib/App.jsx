import React from 'react';
import AltContainer from 'alt/AltContainer';
import BuhinStore from '../stores/BuhinStore';
import Buhin from './Buhin';
import style from './App.css';

var { Component, PropTypes, DOM: { div, svg, g, line } } = React;

class App extends Component {
  render() {
    var { children = [] } = this.props;
    return (
      <div {...style}>
        <AltContainer
          stores={{ BuhinStore }}
          transform={({ BuhinStore }) => BuhinStore.data }
        >
          <Buhin />
        </AltContainer>
      </div>
    );
  }
}

export default App;

