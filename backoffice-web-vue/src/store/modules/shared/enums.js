const state = {
  approvalStatuses: [{
    code: "approved",
    name: "上架"
  }, {
    code: "unapproved",
    name: "下架"
  }]
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
