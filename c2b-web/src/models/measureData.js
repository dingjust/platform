import queryString from 'query-string';
import * as measureData from '../services/measureData';
import Cookie from '~/utils/cookie';
import store from '~/index'
import { routerRedux } from 'dva/router';
import { Toast } from "antd-mobile"

const { dispatch } = store;
let Interval = ''

const measureDataStatic = {
    height: 170.8,
    weight: 53.6,
    frontlength: 69.8,
    backlength: 68.1,
    shoulderwidth: 49.6,
    bust: 99.9,
    downbust: 108.2,
    abdominal: 108.3,
    waistline: 109.1,
    hipline: 100.8,
    sleevelength: 57.6,
    wristline: 22.9,
    pantslength: 99.4,
    crotch: 19.8,
    uparmline: 22.8,
    kneeline: 16.2
}
export default {
    namespace: 'measureData',
    state: {
        measureData: {

        },
        stateData: true,
        stateText: 1
    },
    reducers: {
        save(state, { payload: { measureData } }) {
            return {...state, measureData };
        },
        setState(state, { payload: { stateData } }) {
            return {...state, stateData };
        },
        setStateText(state, { payload: { stateText } }) {
            return {...state, stateText };
        }
    },

    effects: {
        * getFacility({ payload: phone }, { call, put, select }) {
            // let state = yield select(state => state.measureData.state)
            yield put({
                type: 'setStateText',
                payload: {
                    stateText: 0
                }
            })
            let data = {
                machineCode: "",
                sex: "男",
                userName: Cookie.get('phone'),
                toKen: Cookie.get('access_token')
            }
            const { code } = yield call(measureData.getFacility, data);

            if (code == 200) {
                yield put({
                    type: 'setStateText',
                    payload: {
                        stateText: 1
                    }
                })
                return true;
            }
        },
        * getMeasureData({}, { call, put }) {

            let phone = Cookie.get('phone')
            const { code, data } = yield call(measureData.getMeasureData, phone);
            if (code == 200) {
                if (data.status != 0 && data.status != undefined) {
                    yield put({
                        type: "setState",
                        payload: {
                            stateData: false
                        }
                    })
                }
                if (data.status == 0) {
                    yield put({
                        type: "setState",
                        payload: {
                            stateData: true
                        }
                    })
                }
                if (data.status == 1) {
                    yield put({
                        type: "save",
                        payload: {
                            measureData: data
                        }
                    })
                    clearInterval(Interval)
                }
                // return data.status
                if (data.status == -1) {
                    clearInterval(Interval)
                    history.go(-1);
                    Toast.fail('测量失败，请重新测量！');
                }
            }

        },
        * setData({}, { call, put }) {
            clearInterval(Interval)
            yield put({
                type: "setState",
                payload: {
                    stateData: false
                }
            })
            let data = JSON.stringify(measureDataStatic)
            yield put({
                type: "save",
                payload: {
                    measureData: JSON.parse(data)
                }
            })
        },
        * setKey({}, { call, put }) {
            let state = yield select(state => state.measureData.state)
        },
        * saveMeasureData({ payload: measureData_ }, { call, put }) {

            let _measureData = JSON.stringify(measureData_)
            _measureData = JSON.parse(_measureData)
            _measureData.userId = Cookie.get('phone')
            console.log(_measureData)

            const { code, data } = yield call(measureData.saveMeasureData, _measureData);
            if (code == 200) {
                return true;
            }
        },
        * clearInterval() {
            clearInterval(Interval)
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(async({ pathname, search }) => {
                // const query = queryString.parse(search);
                // if (pathname === `/measureState`) {
                //     const state = await dispatch({ type: 'getFacility' });

                // }
                if (pathname === `/measureData`) {
                    Interval = setInterval(() => {
                        dispatch({ type: 'getMeasureData' })
                    }, 1000)
                }
            });
        },
    },
};