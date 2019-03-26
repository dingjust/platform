// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import ElementUI from 'element-ui';
import {TENANT_APIS, NONE_TENANT_APIS} from '@/common';
import router from '@/router';
import store from '@/store';
import {formatDate, enumTranslate, timestampToTime, postponedDays} from '@/common/js/filters';
import HttpServletPlugin from '@/plugins/HttpServletPlugin.js';
import http from '@/common/js/http';
import autoHeight from '@/mixins/autoHeight';

import App from './App';

//时间过滤器
Vue.filter('formatDate', time => {
  if (time === null) {
    return '';
  }
  let date = new Date(time);
  return formatDate(date, 'yyyy-MM-dd hh:mm');
});
Vue.filter('enumTranslate', (enumVal, enumType) => {
  return enumTranslate(enumVal, enumType);
});
//时间戳转成日期字符串格式
Vue.filter('timestampToTime', function (timestamp) {
  if (timestamp == null) {
    return '';
  }
  return timestampToTime(timestamp);
});
// 计算延期天数
Vue.filter('postponedDays', function (timestamp) {
  return postponedDays(timestamp);
});
Vue.use(BootstrapVue);
Vue.use(HttpServletPlugin);
Vue.use(ElementUI, {size: 'small'});
Vue.prototype.fn = {};
Vue.prototype.$http = http;
//根据命令设置导航数据
import _nav from '@/_nav.js';
import _nav_brand from '@/_nav_brand.js';
import _nav_factory from '@/_nav_factory.js';

Vue.prototype.CONFIG = {
  nav(type = process.env.NAV) {
    return type === 'FACTORY' ? _nav_factory : (type === 'BRAND' ? _nav_brand : _nav);
  },
};

Vue.mixin({
  props: ['viewMode'],
  mixins: [autoHeight],
  data() {
    return {
      defaultDateValueFormat: 'yyyy-MM-dd"T"HH:mm:ssZ',
      mediaUploadUrl: '/djwebservices/media/file/upload',
      VIEW_MODE_LIST: 'LIST',
      VIEW_MODE_TABS: 'TABS',
    }
  },
  computed: {
  },
  methods: {
    apis() {
      if (this.$store.getters.currentUser.type === 'TENANT') {
        return TENANT_APIS;
      }

      return NONE_TENANT_APIS;
    },
    isBrand() {
      return this.$store.getters.currentUser.type === 'BRAND';
    },
    isFactory() {
      return this.$store.getters.currentUser.type === 'FACTORY';
    },
    isTenant() {
      return this.$store.getters.currentUser.type === 'TENANT';
    },
    compareDate(date1, date2) {
      let result = false;
      if (date1.getFullYear() > date2.getFullYear()) {
        result = true;
      } else if (date1.getFullYear() === date2.getFullYear()) {
        if (date1.getMonth() > date2.getMonth()) {
          result = true;
        } else if (date1.getMonth() === date2.getMonth()) {
          if (date1.getDate() > date2.getDate()) {
            result = true;
          }
        }
      }

      return result;
    },
    // 枚举类型
    getEnum(enumsName, code) {
      const result = this.$store.state.EnumsModule[enumsName].find(e => e.code === code);
      return result ? result['name'] : 'UNKNOWN';
    },
  }
});
/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: {
    App
  }
});
