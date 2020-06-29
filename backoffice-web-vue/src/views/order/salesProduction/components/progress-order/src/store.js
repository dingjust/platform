//进度组件状态共享
import Vue from 'vue';

export let store = Vue.observable({
  currentProgress: ''
});

export let mutations = {
  setProgress(progress) {
    store.currentProgress = progress;
  },
}
