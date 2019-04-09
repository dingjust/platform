import queryString from 'query-string';
import * as address from '../services/address';
import Cookie from '~/utils/cookie';
import store from '~/index'
import { routerRedux } from 'dva/router';

const { dispatch } = store;
export default {
    namespace: 'address',
    state: {
        addressList: [],
        details: ''
    },
    reducers: {
        saveAddressList(state, { payload: { addressList } }) {
            return {...state, addressList };
        },
        saveDetails(state, { payload: { details } }) {
            return {...state, details }
        }
    },

    effects: {
        * addAddress({ payload: { saveData, id } }, { call, put, select }) {
            let phone = Cookie.get('phone')
            let method = `post`
            if (id) {
                method = `put`
            }
            const { code, data } = yield call(address.addAddress, { phone, saveData, id, method })
            if (code == 201 || code == 200) {
                return true;
            }
            return false;
        },
        * getAddress({ payload: { id } }, { call, put, select }) {
            let phone = Cookie.get('phone')
            let method = `get`
            const { code, data } = yield call(address.addAddress, { phone, id, method });
            if (code == 200) {
                yield put({
                    type: `saveDetails`,
                    payload: {
                        details: data
                    }
                })
            }
            return false;
        },
        * deleteAddress({ payload: { id } }, { call, put, select }) {
            let phone = Cookie.get('phone')
            let method = `delete`
            const { code, data } = yield call(address.addAddress, { phone, id, method });
            if (code == 200) {
                return true;
            }
            return false;
        },
        * getAddressList({}, { call, put, select }) {

            let phone = Cookie.get('phone');
            const { code, data } = yield call(address.getAddressList, { phone })
            if (code == 200) {
                yield put({
                    type: `saveAddressList`,
                    payload: {
                        addressList: data.addresses
                    }
                })
            }
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(({ pathname, search }) => {
                if (pathname === `/addressList`) {
                    dispatch({ type: 'getAddressList' })
                }
                if (pathname === `/addAddress`) {
                    const { id } = queryString.parse(search);
                    if (id) {
                        dispatch({ type: 'getAddress', payload: { id } })
                    }
                }
            });
        },
    },
};