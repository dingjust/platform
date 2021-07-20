// 引入 axios
import axios from 'axios';
import {
  Loading,
  Message
} from 'element-ui';
import router from '@/router';

axios.defaults.baseURL = '';
setAuthorization();

function setAuthorization () {
  const token = sessionStorage.getItem('token');
  // console.log('token: ' + token);
  if (token) {
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + token;
  }

  const currentUser = sessionStorage.getItem('currentUser');
  if (currentUser) {
    const userJson = JSON.parse(currentUser);
    axios.defaults.headers.common['company'] = userJson['companyCode'];
  }
}

/// 错误处理
function errorHandler (resolve, error, loading) {
  loading === true || loading.close()
  // loading == null || loading.close();
  // //登录token失效
  // if (error.response.status == 401) {
  //   Message.closeAll();
  //   Message.error('登录过期，请重新登陆');
  //   router.push("/login");
  // }

  // 401错误处理
  if (error.response && error.response.status === 401) {
    if (error.response.data && error.response.data['errors'][0].type === 'InvalidTokenError') {
      // token无效
      Message.closeAll();
      Message.error('登陆过期，请重新登陆！');
      router.push('/login');
      // 清除sessionStorage
      sessionStorage.clear();
      return;
    } else if (error.response.data && error.response.data['errors'][0].type === 'AccessDeniedError') {
      // 权限缺失
      Message.closeAll();
      // Message.error('此账号没有权限执行此操作！');
      Message.warning('此账号没有权限执行此操作！');
      return;
    } else {
      Message.closeAll();
      Message.error('账号登陆状态异常，请重新登陆！');
      router.push('/login');
      // 清除sessionStorage
      sessionStorage.clear();
      return;
    }
  }

  if (error.response && error.response.data) {
    return resolve(error.response.data);
  } else {
    return resolve(error.response);
  }
}

axios.interceptors.request.use(
  function (config) {
    return config;
  },
  function (error) {
    return Promise.reject(error);
  }
);

let http = {
  options: {
    text: '正在请求，请稍等',
    background: 'rgba(0, 0, 0, 0.8)',
    spinner: 'el-icon-loading'
  },
  /** get 请求
   * @param  {接口地址} url
   * @param  {请求参数} params
   */
  get: function (url, params, ignoreLoading) {
    let loading = ignoreLoading || Loading.service(this.options);
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.get(url, {
        params: params
      }).then((response) => {
        ignoreLoading || loading.close();
        return resolve(response.data)
      })
        .catch((error) => errorHandler(resolve, error, loading));
    });
  },
  /** post 请求
   * @param  {接口地址} url
   * @param  {请求参数} data
   * @param  {路由参数} params
   */
  post: function (url, data, params, ignoreLoading) {
    let loading = ignoreLoading || Loading.service(this.options);
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.post(url, data, {
        params: params
      }).then((response) => {
        ignoreLoading || loading.close();
        return resolve(response.data);
      })
        .catch((error) => errorHandler(resolve, error, loading));
    });
  },
  /** put 请求
   * @param  {接口地址} url
   * @param  {请求参数} data
   */
  put: function (url, data, params, ignoreLoading) {
    let loading = ignoreLoading || Loading.service(this.options);
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.put(url, data, {
        params: params
      }).then((response) => {
        ignoreLoading || loading.close();
        return resolve(response.data)
      }).catch((error) => errorHandler(resolve, error, loading));
    });
  },
  /** delete 请求
   * @param  {接口地址} url
   * @param  {请求参数} params
   */
  delete: function (url, params, ignoreLoading) {
    let loading = ignoreLoading || Loading.service(this.options);
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.delete(url, {
        params: params
      }).then((response) => {
        ignoreLoading || loading.close();
        return resolve(response.data);
      })
        .catch((error) => errorHandler(resolve, error, loading));
    });
  },
  /** upload
   * @param  {接口地址} url
   * @param  {请求参数} data
   */
  formdataPost: function (url, data) {
    let loading = Loading.service(this.options);
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.post(url, data, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      }).then((response) => {
        loading.close();
        return resolve(response.data);
      })
        .catch((error) => errorHandler(resolve, error, loading));
    });
  },
  /** 并发Post
   * @param  {请求数组{url,data,params}} multipleRequest
   */
  multiplePost: function (multipleRequest, ignoreLoading) {
    let loading = ignoreLoading || Loading.service(this.options);
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.all(multipleRequest.map(element => {
        return axios.post(element.url, element.data, {
          params: element.params
        });
      })).then(axios.spread((res) => {
        ignoreLoading || loading.close();
        return resolve(res.map((response) => response.data));
      })).catch((error) => errorHandler(resolve, error, loading));
    });
  }
};

export default http;
