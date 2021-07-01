import Vue from "vue";
import { Image } from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import "./app.scss";

import { COMMON_APIS } from "./common/api";

Vue.prototype.$apis = COMMON_APIS;

Vue.component(Image.name, Image);

const App = {
  onShow(options) {},
  render(h) {
    // this.$slots.default 是将要会渲染的页面
    return h("block", this.$slots.default);
  }
};

export default App;
