/* eslint-disable no-return-assign */
import http from '@/common/js/http';
import axios from 'axios';
import Vue from 'vue'
import { Notification } from 'element-ui';

const state = {
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
  polling: true
};

const mutations = {
  keyword: (state, keyword) => state.keyword = keyword,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  page: (state, page) => state.page = page,
  polling: (state, polling) => state.polling = polling
};

const actions = {
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    if (page !== null && page !== undefined) {
      commit('currentPageNumber', page);
    }
    if (page !== null && page !== undefined) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, query, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    } else {
      // 报错设置为空
      commit('page', {
        number: 0, // 当前页，从0开始
        size: 10, // 每页显示条数
        totalPages: 1, // 总页数
        totalElements: 0, // 总数目数
        content: [] // 当前页数据
      });
    }
  },
  pollingSearch ({dispatch, commit, state}) {
    var timeTag;
    getData(timeTag, commit, state);
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page
};

function getData (timeTag, commit, state) {
  if (!state.polling) {
    return;
  }
  clearTimeout(timeTag);
  const currentUserStr = sessionStorage.getItem('currentUser');
  if (currentUserStr) {
    const currentUser = JSON.parse(currentUserStr);
    if (currentUser.type === 'TENANT') {
      axios.defaults.baseURL = '';
      setAuthorization();

      const url = '/b2b/user/points/exchange/search';
      axios.post(url, {
        state: 'SUBMIT'
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
              h('h6', null, '存在积分申请尚未处理！'),
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
              }, '此次登录不再提示')
            ]),
            duration: 0
          })

          vm.$destroy();
        }
      })
    }
  }

  let a;
  a = setTimeout(function () {
    getData(timeTag, commit, state);
    timeTag = a;
  }, (1000 * 60 * 5));
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
