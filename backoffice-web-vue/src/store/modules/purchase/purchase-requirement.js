/* eslint-disable no-return-assign */
import http from '@/common/js/http';

const getDefaultState = () => {
  return {
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
    formData: {}
  }
}

const state = getDefaultState();

const mutations = {
  keyword: (state, keyword) => state.keyword = keyword,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  page: (state, page) => state.page = page,
  formData: (state, formData) => state.formData = formData,
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
  }
};

const actions = {
  async search ({
    dispatch,
    commit,
    state
  }, {
    url,
    keyword,
    page,
    size
  }) {
    commit('keyword', keyword);
    if (page || page === 0) {
      console.log(page);
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword
    }, {
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
  async searchAdvanced ({
    dispatch,
    commit,
    state
  }, {
    url,
    query,
    page,
    size
  }) {
    if (page !== null && page !== undefined) {
      commit('currentPageNumber', page);
    }
    if (size !== null && size !== undefined) {
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
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  formData: state => state.formData
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
