/* eslint-disable no-unused-vars */
/* eslint-disable no-return-assign */
import http from '@/common/js/http';
import axios from 'axios';
import Vue from 'vue'
import { Notification } from 'element-ui';
import router from '@/router';

const state = {
  url: '',
  keyword: '',
  currentPageNumber: 0,
  currentPageSize: 10,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  formData: {
  },
  queryFormData: {
    keyword: ''
  },
  polling: true
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  formData: (state, formData) => state.formData = formData,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page
};

const actions = {
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('queryFormData', query);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, query, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    }
  },
  pollingSearch ({dispatch, commit, state}) {
    var timeTag;
    getData(timeTag, commit, state);
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  formData: state => state.formData,
  queryFormData: state => state.queryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page
};

// 获取待审核数据
function getData (timeTag, commit, state) {
  if (!state.polling) {
    return;
  }

  clearTimeout(timeTag);
  const currentUserStr = sessionStorage.getItem('currentUser');

  if (currentUserStr) {
    const currentUser = JSON.parse(currentUserStr);
    if (currentUser.type !== 'TENANT') {
      axios.defaults.baseURL = '';
      setAuthorization();

      const url = '/b2b/audit/order/order/list'
      axios.post(url, {
        depts: [],
        keyword: '',
        searchType: 'AUDITING',
        state: 'AUDITING',
        users: [currentUser.id]
      }, {
        page: 0,
        size: 10
      }).then(response => {
        if (response.data.totalElements > 0) {
          Notification.closeAll();

          const vm = new Vue();
          const h = vm.$createElement;

          Notification.warning({
            title: '提示',
            message: h('div', null, [
              h('h6', null, '存在审批任务尚未处理！'),
              h('div', {style: 'display:flex'}, [
                h('el-button', {
                  attrs: {
                    type: 'text'
                  },
                  on: {
                    click: function () {
                      commit('polling', false);
                      Notification.closeAll();
                    }
                  }
                }, '此次登录不再提示'),
                h('el-button', {
                  attrs: {
                    type: 'text'
                  },
                  on: {
                    click: function () {
                      router.push('/task/approval')
                      Notification.closeAll();
                    }
                  }
                }, '前往处理')
              ])
            ]),
            duration: 0
          })

          vm.$destroy();

          var options = {
            dir: 'auto', // 文字方向
            body: '存在审批任务尚未处理！', // 通知主体
            requireInteraction: false, // 不自动关闭通知
            // 通知图标
            icon: 'static/img/logo3.png'
          };
          notifyMe('钉单', options);
        }
      })
    }
  }

  let a;
  a = setTimeout(function () {
    getData(timeTag, commit, state);
    timeTag = a;
  }, (1000 * 60 * 1));
}

function notifyMe (title, options) {
  // 先检查浏览器是否支持
  if (!window.Notification) {
    console.log('浏览器不支持通知');
  } else {
    // 检查用户曾经是否同意接受通知
    if (window.Notification.permission === 'granted') {
      var notification = new window.Notification(title, options); // 显示通知
    }
  }
}

function setAuthorization () {
  const token = sessionStorage.getItem('token');
  if (token) {
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + token;
  }

  const currentUser = sessionStorage.getItem('currentUser');
  if (currentUser) {
    const userJson = JSON.parse(currentUser);
    axios.defaults.headers.common['company'] = userJson['companyCode'];
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
