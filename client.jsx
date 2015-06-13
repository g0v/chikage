import React from 'react';
import BuhinActions from './actions/BuhinActions';
import App from './lib/App';
import 'normalize.css';

/\/#\/(.*)$/.test(location.href);
var id = RegExp.$1 || 'u840c';

BuhinActions.fetch(id);

React.render(
  <App />,
  document.getElementById('app')
);
