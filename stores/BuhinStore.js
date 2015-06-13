import alt from '../alt';
import BuhinActions from '../actions/BuhinActions';

class BuhinStore {
  constructor() {
    this.bindActions(BuhinActions);
    this.fetching = false;
    this.data = {};
  }
  willFetch() {
    this.fetching = true;
  }
  didFetch(data) {
    this.fetching = false;
    this.data = data;
  }
  fetchFailed(error) {
    this.fetching = false;
    console.error(error);
  }
}

export default alt.createStore(BuhinStore);
