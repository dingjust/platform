/* eslint-disable no-return-assign */
import http from '@/common/js/http';

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
  deptList: [],
  formData: {
  }
};

const mutations = {
  keyword: (state, keyword) => state.keyword = keyword,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  page: (state, page) => state.page = page,
  formData: (state, formData) => state.formData = formData,
  deptList: (state, deptList) => state.deptList = deptList
};

const actions = {
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
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
  // 专门查询人员列表并进行缓存 TODO: size大小固定为99,待修改
  async searchPersonList ({dispatch, commit, state, rootState}) {
    if (rootState.CacheModule.personListLoading) {
      return;
    }

    commit('CacheModule/personListLoading', true, {root: true});

    const url = '/b2b/b2bCustomers';
    const response = await http.post(url, {
      enabled: false
    }, {
      page: 0,
      size: 99
    })

    if (!response['errors']) {
      dispatch('CacheModule/personList', {options: response.content}, {root: true});
    }

    commit('CacheModule/personListLoading', false, {root: true});
  },
  // 查询部门列表（通用
  async searchDeptList ({dispatch, commit, state, rootState}) {
    if (rootState.CacheModule.deptListLoading) {
      return;
    }
    commit('CacheModule/deptListLoading', true, {root: true});

    const url = '/b2b/dept/tree/list';
    const response = await http.post(url);

    if (!response['errors']) {
      const currentUser = JSON.parse(sessionStorage.getItem('currentUser'));
      commit('deptList', [{
        id: 0,
        name: currentUser.companyName,
        depth: 0,
        children: response.data
      }]);

      // 进行缓存，供员工选择组件使用
      dispatch('CacheModule/deptList', {options: response.data}, {root: true});
    }

    commit('CacheModule/deptListLoading', false, {root: true});
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  formData: state => state.formData,
  deptList: state => state.deptList
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
