import http from '@/common/js/http';

const state = {
  permissions: []
};

const mutations = {
  permissions (state, permissions) {
    sessionStorage.setItem('permissions', JSON.stringify(permissions));
    state.permissions = permissions;
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
    const result = await http.get('/b2b/b2bCustomers/role/' + uid);
    if (result['errors']) {
      this.$message.error(result['errors'][0].message);
      return;
    }
    console.log(result);
    commit('permissions', result.data);
  }
};

const getters = {
  permissions () {
    if (state.permissions.length <= 0) {
      return JSON.parse(sessionStorage.getItem('permissions'));
    }
    return state.permissions;
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
