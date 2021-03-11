import Vue from "vue";

import "./app.scss";

import { COMMON_APIS } from "./common/api";

Vue.prototype.$apis = COMMON_APIS;

const App = {
  onShow(options) {},
  render(h) {
    // this.$slots.default 是将要会渲染的页面
    return h("block", this.$slots.default);
  }
};

export default App;
