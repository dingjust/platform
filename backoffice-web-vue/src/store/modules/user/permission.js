import http from '@/common/js/http';

const state = {
  permissions: [],
  dataPermission: []
};

const mutations = {
  permissions (state, permissions) {
    sessionStorage.setItem('permissions', JSON.stringify(permissions));
    state.permissions = permissions;
  },
  dataPermission (state, data) {
    if (data != null && data.length > 0) {
      let dataPermission = {};
      data.forEach(item => {
        dataPermission[item.code] = item.permission;
      })
      sessionStorage.setItem('dataPermission', JSON.stringify(dataPermission));
      state.dataPermission = dataPermission;
    }
  }
};

const actions = {
  async getPermissions ({
    dispatch,
    commit,
    state
  }, {
    uid
  }) {
    // 获取账号权限
    const response = await http.get('/b2b/b2bCustomers/role/' + uid);
    if (!response['errors']) {
      commit('permissions', response.data.roleList);
      commit('dataPermission', response.data.dataPermissionList);
    }
  }
};

const getters = {
  permissions () {
    if (state.permissions.length <= 0) {
      return JSON.parse(sessionStorage.getItem('permissions'));
    }
    return state.permissions;
  },
  dataPermission () {
    if (state.dataPermission.length <= 0) {
      return JSON.parse(sessionStorage.getItem('dataPermission'));
    }
    return state.dataPermission;
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
