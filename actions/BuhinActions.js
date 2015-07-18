import alt from '../alt';
import request from 'superagent-bluebird-promise';
import { assign } from 'lodash';

class BuhinActions {
  constructor() {
    this.generateActions('willFetch', 'didFetch', 'fetchFailed');
  }
  fetch(id) {
    request.get(`/${id}.json`)
      .then(({ body: buhin }) => {
        this.actions.didFetch(buhin);
      })
      .catch(this.actions.fetchFailed);
  }
}

export default alt.createActions(BuhinActions);
