import * as collectService from "../services/collect";
import * as customizationService from '../services/customization';

import Cookie from "../utils/cookie"
export default {
    namespace: 'collect',
    state: {
        collectList: [],
        checkCollect: [],
        // deleteIndex: [],
        page: null,
        shareImgURL: ``
    },
    reducers: {
        saveCollectList(state, { payload: { collectList } }) {
            collectList = JSON.stringify(collectList)
            collectList = JSON.parse(collectList)
            return {...state, collectList }
        },
        savePage(state, { payload: { page } }) {

            return {...state, page }
        },
        saveCheckCollect(state, { payload: { checkCollect } }) {
            return {...state, checkCollect }
        },
        // saveDeleteIndex(state, { payload: { deleteIndex } }) {
        //     return {...state, deleteIndex }
        // },
        saveShareImgURL(state, { payload: { shareImgURL } }) {
            return {...state, shareImgURL }
        }
    },
    effects: {
        * collectList({ payload: { page, pageSize } }, { call, put, select }) {
            let list = yield select(state => state.collect.collectList)
            const phone = Cookie.get('phone')
            const { code, data } = yield call(collectService.collectList, { page, pageSize, phone })
            if (code == 200 || code == 304) {
                if (data.length > 0) {
                    yield put({
                        type: `saveCollectList`,
                        payload: {
                            collectList: list ? data.concat(list) : data
                        }
                    })
                    yield put({
                        type: `savePage`,
                        payload: {
                            page
                        }
                    })

                }
                return true;
            }
        },
        * getChecked({ payload: { state, index } }, { call, put, select }) {
            let data = yield select(state => state.collect.collectList)
                // let deleteIndex = yield select(state => state.collect.deleteIndex)
            data[index].checked = state
            let checkCollect = yield select(state => state.collect.checkCollect)
            if (state) {
                checkCollect.push({ favoriteId: data[index].favoriteId, productUserConfig: { id: data[index].productUserConfig.id } })
                    // deleteIndex.push(index)
            } else {
                checkCollect.splice(checkCollect.findIndex(item => item.favoriteId === data[index].favoriteId), 1)
                    // deleteIndex.splice(deleteIndex.findIndex(item => item == index), 1)
            }
            yield put({
                type: 'saveCheckCollect',
                payload: {
                    checkCollect
                },
            });
            yield put({
                type: 'saveCollectList',
                payload: {
                    collectList: data
                },
            });
            // yield put({
            //     type: 'saveDeleteIndex',
            //     payload: {
            //         deleteIndex
            //     },
            // });
        },
        *
        allCheck({ payload: { state, index } }, { call, put, select }) {
            let collectList = yield select(state => state.collect.collectList)
                // let deleteIndex = []

            let checkArray = []

            for (const [index_, item] of collectList.entries()) {
                if (state) {
                    checkArray.push({ favoriteId: item.favoriteId, productUserConfig: { id: item.productUserConfig.id } })
                    collectList[index].checked = true;
                    // deleteIndex.push(index_)
                } else {
                    collectList[index_].checked = false;
                }
            }
            yield put({
                type: 'saveCheckCollect',
                payload: {
                    checkCollect: checkArray
                }
            })
            yield put({
                type: 'saveCollectList',
                payload: {
                    collectList
                },
            });
            // yield put({
            //     type: 'saveDeleteIndex',
            //     payload: {
            //         deleteIndex
            //     },
            // });
        },
        *
        deleteCollect({}, { call, put, select }) {
            let checkCollect = yield select(state => state.collect.checkCollect)
            let collectList = yield select(state => state.collect.collectList)
            const { code, data } = yield call(collectService.deteteCollect, { checkCollect })
            if (code == 200) {
                checkCollect.forEach((obj, index) => {
                    for (let i in collectList) {
                        if (collectList[i].favoriteId == obj.favoriteId) {
                            collectList.splice(i, 1)
                        }
                    }
                })
            }
            yield put({
                type: 'saveCheckCollect',
                payload: {
                    checkCollect: []
                }
            })
            yield put({
                type: 'saveCollectList',
                payload: {
                    collectList
                },
            });

        },
        // 获取分享图片
        *
        shareImg({ payload: { routerUrl, productCode, productUserConfig, url } }, { call, put, select }) {
            let shareData = {
                image: url,
                url: routerUrl,
                productUserConfig: JSON.stringify(productUserConfig)
            }
            const { code, data } = yield call(customizationService.shareImgService, { code: productCode, shareData });
            if (code == 200) {
                yield put({
                    type: `saveShareImgURL`,
                    payload: {
                        shareImgURL: data.url
                    }
                })
            }
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(async({ pathname, search }) => {
                // const { code, pk, entryNumber } = queryString.parse(search);
                if (pathname === `/collect`) {
                    dispatch({
                        type: `saveCollectList`,
                        payload: {
                            collectList: []
                        }
                    })
                    dispatch({
                        type: `savePage`,
                        payload: {
                            page: 0
                        }
                    })
                    dispatch({ type: `collectList`, payload: { page: 0 } })
                }
            });
        }
    }
}