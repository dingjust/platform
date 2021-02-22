/* eslint-disable no-return-assign */
const state = {
  deptListLoading: false, // 是否处于加载状态中
  personListLoading: false, // 是否处于加载状态中
  deptList: {
    loaded: false, // 是否已加载过
    options: []
  },
  personList: {
    loaded: false, // 是否已加载过
    options: []
  }
};

const mutations = {
  deptListLoading: (state, deptListLoading) => state.deptListLoading = deptListLoading,
  personListLoading: (state, personListLoading) => state.personListLoading = personListLoading,
  deptList: (state, deptList) => state.deptList = deptList,
  personList: (state, personList) => state.personList = personList
};

const actions = {
  deptList ({dispatch, commit, state}, {options}) {
    commit('deptList', {
      loaded: true,
      options: options
    });
  },
  personList ({dispatch, commit, state}, {options}) {
    commit('personList', {
      loaded: true,
      options: options
    });
  }
};

const getters = {
  deptListLoaded: (state) => state.deptListLoading || state.deptList.loaded,
  personListLoaded: (state) => state.personListLoading || state.personList.loaded,
  deptList: state => state.deptList,
  personList: state => state.personList
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
};
