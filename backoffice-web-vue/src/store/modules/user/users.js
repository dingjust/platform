import axios from 'axios';
import http from '@/common/js/http';
import router from '@/router';
import {
  createNamespacedHelpers
} from 'vuex';

const CLIENT_ID = 'nbyjy';
const CLIENT_SECRET = 'password';
const GRANT_TYPE_PASSWORD = 'password';
const GRANT_TYPE_REFRESH_TOKEN = 'refresh_token';

const state = {
  currentUser: null,
  authorized: false,
  token: '',
  expiresIn: 0,
  refreshToken: '',
  authenticationInfo: {
    companyState: '',
    companyType: '',
    personalState: '',
  }
};
const mutations = {
  authorized(state, authorized) {
    sessionStorage.setItem('authorized', authorized);
    state.authorized = authorized;
  },
  token(state, token) {
    sessionStorage.setItem('token', token);
    state.token = token;
  },
  expiresIn(state, expiredIn) {
    localStorage.setItem('expiresIn', expiredIn);
    state.expiresIn = expiredIn;
  },
  refreshToken(state, refreshToken) {
    localStorage.setItem('refreshToken', refreshToken);
    state.refreshToken = refreshToken;
  },
  currentUser(state, currentUser) {
    sessionStorage.setItem('currentUser', JSON.stringify(currentUser));
    state.currentUser = currentUser;
  },
  authenticationInfo(state, authenticationInfo) {
    state.authenticationInfo = authenticationInfo;
  }
};
const actions = {
  async login({
    dispatch,
    commit,
    state
  }, {
    username,
    password
  }) {
    const response = await http.post('/authorizationserver/oauth/token?' +
      'username=' + username +
      '&password=' + password +
      '&client_id=' + CLIENT_ID +
      '&client_secret=' + CLIENT_SECRET +
      '&grant_type=' + GRANT_TYPE_PASSWORD);
    if (response['errors']) {
      alert(response['errors'][0].message);
      return;
    }
    if (!response['access_token']) {
      alert("账号密码不正确");
      return;
    }
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + response['access_token'];

    commit('token', response['access_token']);
    commit('expiresIn', response['expires_in']);
    commit('refreshToken', response['refresh_token']);
    commit('authorized', true);

    // 获取当前登录用户信息
    const userInfo = await http.get('/b2b/users/' + username + '/profile');
    axios.defaults.headers.common['company'] = userInfo['companyCode'];
    // 'type' : 'TENANT', 'BRAND', 'FACTORY',
    // userInfo['type'];
    // console.log(JSON.stringify(userInfo));
    commit('currentUser', userInfo);

    //获取认证信息
    // const url = this.apis().getAuthenticationState();
    const result = await http.get('/b2b/cert/state');
    if (!result['errors']) {
      commit('authenticationInfo', result.data);
    }

    router.push('/');
  },
  async getProfile({
    dispatch,
    commit,
    state
  }, {
    uid,
  }) {
    console.log(JSON.stringify(state.currentUser));
    // 获取当前登录用户信息
    const userInfo = await http.get('/b2b/users/' + uid + '/profile');
    axios.defaults.headers.common['company'] = userInfo['companyCode'];
    commit('currentUser', userInfo);

    //获取认证信息
    // const url = this.apis().getAuthenticationState();
    const result = await http.get('/b2b/cert/state');
    if (!result['errors']) {
      commit('authenticationInfo', result.data);
    }
    location.reload();
  },
  async refreshToken({
    dispatch,
    commit,
    state
  }) {
    const response = await http.post('/authorizationserver/oauth/token?' +
      '&client_id=' + CLIENT_ID +
      '&client_secret=' + CLIENT_SECRET +
      '&grant_type=' + GRANT_TYPE_REFRESH_TOKEN +
      '&refresh_token=' + state.refreshToken);
    if (response['errors']) {
      alert(response['errors'][0].message);
      return;
    }
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + response['access_token'];
    commit('token', response['access_token']);
    commit('expiresIn', response['expires_in']);
    commit('refreshToken', response['refresh_token']);
  }
};
const getters = {
  currentUser() {
    if (!state.currentUser) {
      return JSON.parse(sessionStorage.getItem('currentUser'));
    }
    return state.currentUser;
  },
  token() {
    return 'Bearer ' + sessionStorage.getItem('token');
  },
  authenticationInfo: state => state.authenticationInfo,
};

export default {
  /*namespaced: true,*/
  state,
  mutations,
  actions,
  getters
}
