// 全局保存公司部门列表和员工列表
import http from '@/common/js/http';

const state = {
  deptList: {
    refNum: 0,            // 被组件引用次数
    loading: false,       // 数据是否加载中
    options: []           // 具体数据
  },
  personList: {
    refNum: 0,            // 被组件引用次数
    loading: false,       // 数据是否加载中
    options: []           // 具体数据
  }
};

const mutations = {
  deptList ({deptList}, {cmd, val}) {
    switch (cmd) {
      case 'loading':
        deptList.loading = val;
        return;
      case 'options':
        deptList.options = val;
        return;
      case 'minusRef':
        deptList.refNum = Math.max(0, deptList.refNum - 1);
        return;
      case 'plusRef':
        deptList.refNum++;
        return;
      default:
        throw 'deptList 未知命令' + cmd;
    }
  },
  personList ({personList}, {cmd, val}) {
    switch (cmd) {
      case 'loading':
        personList.loading = val;
        return;
      case 'options':
        personList.options = val;
        return;
      case 'minusRef':
        personList.refNum = Math.max(0, deptList.refNum - 1);
        return;
      case 'plusRef':
        personList.refNum++;
        return;
      default:
        throw 'deptList 未知命令' + cmd;
    }
  }
};

const actions = {
  async loadDeptList({commit, state}, vue) {
    // 如果没有被引用，那么不加载数据
    if (state.deptList.refNum <= 0) {
      return;
    }
    if (state.deptList.loading) {
      return;
    }

    commit('deptList', {cmd: 'loading', val: true});
    
    await this.dispatch('OrganizationModule/getDept');
    await this.dispatch('OrganizationModule/getPerson');
    
    commit('deptList', {cmd: 'loading', val: false});
  },
  async getDept ({dispatch, commit, state}, vue) {
    const url = '/b2b/dept/tree/list';
    const response = await http.post(url)

    if (!response['errors'] && response.code === 1) {
      commit('deptList', {cmd: 'options', val: response.data});
    }
  },
  async getPerson ({dispatch, commit, state}, vue) {
    const url = '/b2b/b2bCustomers';
    const response = await http.post(url, {
      enable: false
    }, {
      page: 0,
      size: 99
    })

    if (!response['errors']) {
      commit('personList', {cmd: 'options', val: response.content});
    }
  }
};

const getters = {
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
