import alt from '../alt';
import request from 'superagent-bluebird-promise';
import { assign } from 'lodash';

const server = 'http://chikage.linode.caasih.net';
const fetchTree = function fetchTree(buhin, onSuccess, onFailed) {
  for(let op of buhin.data) {
    switch(op.type) {
      case 'link':
        request.get(`${server}/${op.src}.json`)
          .then(({ body: buhin }) => {
            op = assign(op, buhin);
            onSuccess(buhin);
            fetchTree(buhin, onSuccess, onFailed);
          })
          .catch(onFailed);
        break;
      default:
        break;
    }
  };
};

class BuhinActions {
  constructor() {
    this.generateActions('willFetch', 'didFetch', 'fetchFailed');
  }
  fetch(id) {
    request.get(`${server}/${id}.json`)
      .then(({ body: buhin }) => {
        fetchTree(
          buhin,
          // update the top buhin instead of the fetched one
          () => this.actions.didFetch(buhin),
          this.actions.fetchFailed
        );
        this.actions.didFetch(buhin);
      })
      .catch(this.actions.fetchFailed);
  }
}

export default alt.createActions(BuhinActions);
