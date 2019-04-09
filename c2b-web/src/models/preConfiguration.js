import * as preConfigurationService from "../services/preConfiguration";
import * as customizationService from '../services/customization';
import queryString from 'query-string';

import Cookie from "../utils/cookie"
export default {
    namespace: 'preConfiguration',
    state: {
        preConfigurationList: [],
        page: null,
        productCode: ``,
        filtersList: []
    },
    reducers: {
        savePreConfigurationList(state, { payload: { preConfigurationList, page } }) {
            preConfigurationList = JSON.stringify(preConfigurationList)
            preConfigurationList = JSON.parse(preConfigurationList)
            return {...state, preConfigurationList, page }
        },
        saveCode(state, { payload: { productCode } }) {
            return {...state, productCode }
        },
        saveFilters(state, { payload: { filtersList } }) {
            return {...state, filtersList }
        }
    },
    effects: {
        * preConfigurationList({ payload: { page = 0, pageSize, color, texture, collar, sleeve } }, { call, put, select }) {

            let list = yield select(state => state.preConfiguration.preConfigurationList)
            let page_ = yield select(state => state.preConfiguration.page)
            let productCode = yield select(state => state.preConfiguration.productCode)

            const { code, data } = yield call(preConfigurationService.preConfigurationList, { page, pageSize, productCode, color, texture, collar, sleeve })
            if (code == 200 || code == 304) {
                if (data.data) {
                    yield put({
                        type: `savePreConfigurationList`,
                        payload: {
                            preConfigurationList: page != 0 ? data.data.concat(list) : data.data,
                            page
                        }
                    })
                }
                return true;
            }
        },
        * preConfigurationFilters({ payload: {} }, { call, put, select }) {
            let productCode = yield select(state => state.preConfiguration.productCode)
            const { code, data } = yield call(preConfigurationService.preConfigurationFilters, { productCode })
            if (code == 200 || code == 304) {
                if (data.data) {
                    yield put({
                        type: `saveFilters`,
                        payload: {
                            filtersList: data.data
                        }
                    })
                }
                return true;
            }
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(async({ pathname, search }) => {
                const { code } = queryString.parse(search);
                dispatch({
                    type: `saveCode`,
                    payload: {
                        productCode: code
                    }
                })
                if (pathname === `/preConfiguration`) {
                    dispatch({ type: `preConfigurationList`, payload: {} })
                    dispatch({ type: `preConfigurationFilters`, payload: {} })
                }

            });
        }
    }
}