import http from '@/common/js/http';

const state = {
  keyword: '',
  roleGroupName: '',
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
  roleForm: {
    id: null,
    name: '',
    roleIds: []
  },
  roleList: [],
  deptList: [],
  roleGroupList: [],
  roleCodeList: []
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  roleGroupName: (state, roleGroupName) => state.roleGroupName = roleGroupName,
  page: (state, page) => state.page = page,
  roleList: (state, roleList) => state.roleList = roleList,
  deptList: (state, deptList) => state.deptList = deptList,
  roleForm: (state, roleForm) => state.roleForm = roleForm,
  formData: (state, formData) => state.formData = formData,
  roleGroupList: (state, roleGroupList) => state.roleGroupList = roleGroupList,
  roleCodeList: (state, roleCodeList) => state.roleCodeList = roleCodeList
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, roleGroupName, page, size}) {
    commit('keyword', keyword);
    commit('roleGroupName', roleGroupName);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      roleGroupName: state.roleGroupName
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  refresh ({dispatch, commit, state}, {url}) {
    const keyword = state.keyword;
    // const roleGroupName = state.roleGroupName;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url, keyword, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  formData: state => state.formData,
  roleForm: state => state.roleForm,
  keyword: state => state.keyword,
  roleGroupName: roleGroupName => roleGroupName.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  roleList: state => state.roleList,
  deptList: state => state.deptList,
  roleGroupList: state => state.roleGroupList,
  roleCodeList: state => state.roleCodeList
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
