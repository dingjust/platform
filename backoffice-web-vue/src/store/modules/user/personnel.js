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
  },
  deptListLoading: false, // 是否处于加载状态中
  personListLoading: false, // 是否处于加载状态中
  cacheDeptList: {
    loaded: false, // 是否已加载过
    options: []
  },
  cachePersonList: {
    loaded: false, // 是否已加载过
    options: []
  }
};

const mutations = {
  keyword: (state, keyword) => state.keyword = keyword,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  page: (state, page) => state.page = page,
  formData: (state, formData) => state.formData = formData,
  deptList: (state, deptList) => state.deptList = deptList,
  deptListLoading: (state, deptListLoading) => state.deptListLoading = deptListLoading,
  personListLoading: (state, personListLoading) => state.personListLoading = personListLoading,
  cacheDeptList: (state, cacheDeptList) => state.cacheDeptList = cacheDeptList,
  cachePersonList: (state, cachePersonList) => state.cachePersonList = cachePersonList
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
    if (state.personListLoading) {
      return;
    }

    commit('personListLoading', true);

    const url = '/b2b/b2bCustomers';
    const response = await http.post(url, {
      enabled: false
    }, {
      page: 0,
      size: 99
    })

    if (!response['errors']) {
      commit('cachePersonList', {
        loaded: true,
        options: response.content
      });
    }

    commit('personListLoading', false);
  },
  // 查询部门列表（通用
  async searchDeptList ({dispatch, commit, state, rootState}) {
    if (state.deptListLoading) {
      return;
    }
    commit('deptListLoading', true);

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
      commit('cacheDeptList', {
        loaded: true,
        options: response.data
      });
    }

    commit('deptListLoading', false);
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  formData: state => state.formData,
  deptList: state => state.deptList,
  deptListLoaded: (state) => state.deptListLoading || state.cacheDeptList.loaded,
  personListLoaded: (state) => state.personListLoading || state.cachePersonList.loaded,
  cacheDeptList: state => state.cacheDeptList,
  cachePersonList: state => state.cachePersonList
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
