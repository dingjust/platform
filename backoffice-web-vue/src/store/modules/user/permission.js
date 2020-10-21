import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    permissions: []
  }
}

const state = getDefaultState();

const mutations = {
  permissions (state, permissions) {
    sessionStorage.setItem('permissions', JSON.stringify(permissions));
    state.permissions = permissions;
  },
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
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
    if (result.code === 0) {
      this.$message.error(result.msg);
      return;
    }
    console.log(result);
    commit('permissions', result.data);
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
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
