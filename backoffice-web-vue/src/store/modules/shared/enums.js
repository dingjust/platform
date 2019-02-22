const state = {
  approvalStatuses: [{
    code: 'approved',
    name: '上架'
  }, {
    code: 'unapproved',
    name: '下架'
  }],
  machiningTypes: [{
    code: 'LABOR_AND_MATERIAL',
    name: '包工包料'
  }, {
    code: 'LIGHT_PROCESSING',
    name: '清加工'
  }],
};

const mutations = {};

const actions = {};

const getters = {
  approvalStatuses: state => state.approvalStatuses,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
