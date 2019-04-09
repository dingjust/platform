import queryString from 'query-string';
import * as submitOrder from '../services/submitOrder';
import * as address from '../services/address';
import Cookie from '~/utils/cookie';
import { Tost } from "antd-mobile"

export default {
    namespace: 'submitOrder',
    state: {
        data: {},
        order: ``,
        cartCode: ``,
        address: undefined
    },
    reducers: {
        save(state, { payload: { data, order, cartCode } }) {
            return {...state, data, order, cartCode };
        },
        saveAddress(state, { payload: { address } }) {
            return {...state, address };
        }
    },
    effects: {
        * getOrderDetails({ payload: { order, cartCode } }, { call, put, select }) {
            let phone = Cookie.get('phone')
            const { data } = yield call(submitOrder.getOrderDetails, { entries: order, cartCode, phone });
            yield put({
                type: 'save',
                payload: {
                    data: data,
                    order,
                    cartCode
                },
            });
        },
        * submitOrder({ payload: { siteState, pk } }, { call, put, select }) {
            let phone = Cookie.get('phone');
            let order = yield select(state => state.submitOrder.order)

            let json = {
                entries: order,
                inStore: siteState, //是否现场提货
                address: pk //邮寄地址的pk
            }
            return yield call(submitOrder.submitOrder, { phone, data: json });

        },
        * getAddressList({}, { call, put, select }) {
            let phone = Cookie.get('phone');
            const { code, data } = yield call(address.getAddressList, { phone })
            if (code == 200) {
                for (let i in data.addresses) {
                    if (data.addresses[i].defaultAddress) {
                        yield put({
                            type: `saveAddress`,
                            payload: {
                                address: data.addresses[i]
                            }
                        })
                    }
                }

            }
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(({ pathname, search }) => {
                const { order, cartCode } = queryString.parse(search);
                if (pathname === `/submitOrder`) {
                    dispatch({ type: 'getOrderDetails', payload: { order, cartCode } });
                    dispatch({ type: "getAddressList" })
                }
            });
        },
    },
};