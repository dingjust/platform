import queryString from 'query-string';
import * as login from '../services/login';
import Cookie from '~/utils/cookie';
import store from '~/index'
import { routerRedux } from 'dva/router';

const { dispatch } = store;
export default {
    namespace: 'login',
    state: {
        code: '',
        phone: '',
        access_token: '',
        token_type: ''
    },
    reducers: {
        save(state, { payload: { code } }) {
            return {...state, code };
        },
        setPhone(state, { payload: { phone } }) {
            // console.log(phone)
            return {...state, phone }
        },
        setCode(state, { payload: { code } }) {
            // console.log(code)
            return {...state, code }
        },
        setToken(state, { payload: { token } }) {
            // console.log(code)
            return {...state, token }
        }
    },

    effects: {
        * fetch({ payload: phone }, { call, put }) {
            const { code } = yield call(login.getCode, { phone });
            if (code == 200) {
                Cookie.set('phone', phone.replace(/\s+/g, ""))
                return true;
            }
        },
        * login({ payload: code_ }, { call, put }) {
            const { code, data } = yield call(login.login, { code: code_ });
            if (code == 200) {
                let time = data.expires_in / 3600
                Cookie.set('access_token', data.access_token, time)
                Cookie.set('token_type', data.token_type, time)

                yield put({
                    type: 'setToken',
                    payload: {
                        access_token: data.access_token,
                        token_type: data.token_type
                    },
                });
                if (Cookie.get(`hash`) == `/login`) {
                    Cookie.set('hash', '')
                    dispatch(routerRedux.push({
                        pathname: `/`
                    }));
                } else {
                    history.go(-1);
                }
                // 合并匿名用户数据
                yield call(login.mergeData)
            }

        },
        * getPhone({ payload: phone }, { call, put }) {
            yield put({
                type: "setPhone",
                payload: {
                    phone
                }
            })
        },
        * getCode({ payload: code }, { call, put }) {
            yield put({
                type: "setCode",
                payload: {
                    code
                }
            })
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(({ pathname, search }) => {
                // const query = queryString.parse(search);
                if (pathname === `/login`) {
                    // dispatch({ type: 'fetch', payload: state => state.login.phone });
                }
            });
        },
    },
};