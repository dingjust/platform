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
  formData: {
    id: null,
    uid: '',
    name: '',
    mobileNumber: '',
    password: '',
    confirmPassword: '',
    roles: [],
    b2bRoleList: [],
    b2bDept: {
      id: 0
    },
    b2bRoleGroup: {
      id: 0
    }
  },
  queryFormData: {
    keyword: '',
    roleGroupName: '',
    deptName: ''
  },
  roleForm: {
    id: null,
    name: '',
    roleIds: []
  },
  roleGroupData: {
    id: '',
    name: '',
    roleList: [],
    roleIds: []
  },
  roleList: [],
  deptList: [],
  roleGroupList: [],
  roleCodeList: [],
  trainData: []
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  roleList: (state, roleList) => state.roleList = roleList,
  deptList: (state, deptList) => state.deptList = deptList,
  roleGroupData: (state, roleGroupData) => state.roleGroupData = roleGroupData,
  roleForm: (state, roleForm) => state.roleForm = roleForm,
  formData: (state, formData) => state.formData = formData,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  roleGroupList: (state, roleGroupList) => state.roleGroupList = roleGroupList,
  roleCodeList: (state, roleCodeList) => state.roleCodeList = roleCodeList,
  trainData: (state, trainData) => state.trainData = trainData
};

const actions = {
  async search ({dispatch, commit, state}, {url, page, size}) {
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.queryFormData.keyword,
      roleGroupName: state.queryFormData.roleGroupName,
      deptName: state.queryFormData.deptName
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAside ({dispatch, commit, state}, {url, keyword, deptName, roleName, page, size}) {
    const response = await http.post(url, {
      keyword: keyword,
      roleGroupName: roleName,
      deptName: deptName
    }, {
      page: page,
      size: size
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  refresh ({dispatch, commit, state}, {url}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url, keyword, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  formData: state => state.formData,
  queryFormData: state => state.queryFormData,
  roleForm: state => state.roleForm,
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  roleList: state => state.roleList,
  deptList: state => state.deptList,
  roleGroupData: state => state.roleGroupData,
  roleGroupList: state => state.roleGroupList,
  roleCodeList: state => state.roleCodeList,
  trainData: state => state.trainData
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
