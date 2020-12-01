// 新对账单状态管理
/* eslint-disable no-return-assign */
import http from '@/common/js/http';

const getDefaultState = () => {
  return {
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
    }
  }
}

const state = getDefaultState();

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
  }
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, statuses, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    if (page != null) {
      commit('currentPageNumber', page);
    }

    if (size != null) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      statuses: state.statuses
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('url', url);
    if (page != null) {
      commit('currentPageNumber', page);
    }

    if (size != null) {
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
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
