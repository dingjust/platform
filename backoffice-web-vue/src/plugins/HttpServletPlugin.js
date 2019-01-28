function HttpServletPlugin(Vue, options) {
  // 1. 添加全局方法或属性
  Vue.errorResponse = function (response) {
    if (response.data.code && response.data.message) {
      return response.data.code + "： " + response.data.message;
    }

    return response.data;
  };

  // 2. 添加全局资源
  /*  Vue.directive('my-directive', {
      bind (el, binding, vnode, oldVnode) {
        // 逻辑...
      }
    });*/

  // 3. 注入组件
  /*  Vue.mixin({
      methods: {

      }
    });*/

  // 4. 添加实例方法
  /*Vue.prototype.$myMethod = function (methodOptions) {
    // 逻辑...
  }*/
}

export default HttpServletPlugin;

