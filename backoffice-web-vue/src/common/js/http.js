// 引入 axios
import axios from 'axios';

axios.defaults.baseURL = '';
setAuthorization();

function setAuthorization() {
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

axios.interceptors.request.use(
  function (config) {
    return config;
  },
  function (error) {
    return Promise.reject(error);
  }
);

let http = {
  /** get 请求
   * @param  {接口地址} url
   * @param  {请求参数} params
   */
  get: function (url, params) {
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.get(url, {
        params: params
      }).then((response) => resolve(response.data))
        .catch((error) => resolve(error.response.data));
    });
  },
  /** post 请求
   * @param  {接口地址} url
   * @param  {请求参数} data
   * @param  {headers参数} params
   */
  post: function (url, data, params) {
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.post(url, data, {
        params: params
      }).then((response) => resolve(response.data))
        .catch((error) => resolve(error.response.data));
    });
  },
  /** post 请求
   * @param  {接口地址} url
   * @param  {请求参数} data
   */
  put: function (url, data, params) {
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.put(url, data, {
        params: params
      }).then((response) => resolve(response.data))
        .catch((error) => resolve(error.response.data));
    });
  },
  /** post 请求
   * @param  {接口地址} url
   * @param  {请求参数} params
   */
  delete: function (url, params) {
    setAuthorization();
    return new Promise((resolve, reject) => {
      axios.delete(url, {
        params: params
      }).then((response) => resolve(response.data))
        .catch((error) => resolve(error.response.data));
    });
  }
};

export default http;
