/* web-chat store */
const now = new Date();

export default {
  namespaced: true,
  state: {
    // 当前用户
    user: {
      name: 'coffce',
      img: 'static/img/avatars/user.jpg'
    },
    // 会话列表
    sessions: [{
      id: 1,
      user: {
        name: '示例介绍',
        img: 'static/img/avatars/user.jpg'
      },
      messages: [{
        content: 'Hello，这是一个基于Vue + Vuex + Webpack构建的简单chat示例',
        date: now
      }]
    },
      {
        id: 2,
        user: {
          name: 'webpack',
          img: 'static/img/avatars/user.jpg'
        },
        messages: []
      }
    ],
    // 当前选中的会话
    currentSessionId: 1,
    // 过滤出只包含这个key的会话
    filterKey: ''
  },

  getters: {
    user({
           user
         }, getters, rootState, rootGetters) {
      return user
    },

    filterKey({
                filterKey
              }) {
      return filterKey
    },

    // 过滤后的会话列表
    sessions({
               sessions,
               filterKey
             }) {
      return sessions.filter(session => session.user.name.includes(filterKey))
    },

    // 查找到的会话
    sessionWho({
                 sessions,
                 currentSessionId
               }) {
      return sessions.find(session => session.id === currentSessionId)
    },

    // 当前会话index
    currentId({
                currentSessionId
              }) {
      return currentSessionId
    }
  },

  mutations: {
    INIT_DATA(state, getters, rootGetters) {
      let data = localStorage.getItem('vue-chat-session')
      if (data) {
        state.sessions = JSON.parse(data)
      }
    },
    // 发送消息
    SEND_MESSAGE({
                   sessions,
                   currentSessionId
                 }, content) {
      let session = sessions.find(item => item.id === currentSessionId)
      session.messages.push({
        content: content,
        date: new Date(),
        self: true
      })
    },
    // 选择会话
    SELECT_SESSION(state, id) {
      state.currentSessionId = id
    },
    // 搜索
    SET_FILTER_KEY(state, value) {
      state.filterKey = value
    }
  },

  actions: {
    initData({
               commit
             }) {
      return commit('INIT_DATA')
    },

    sendMessage({
                  commit
                }, content) {
      return commit('SEND_MESSAGE', content)
    },

    selectSession({
                    commit
                  }, id) {
      return commit('SELECT_SESSION', id)
    },

    search({
             commit
           }, value) {
      return commit('SET_FILTER_KEY', value)
    }
  }
}
