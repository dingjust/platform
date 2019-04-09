import queryString from 'query-string';
import * as customizationService from '../services/customization';
import * as collectService from "../services/collect"
// import { PREFIX } from '../constants';
import { Toast } from "antd-mobile"
import Cookie from '~/utils/cookie';

import { durationTime } from "~/parameterConfig.js"

export default {
    namespace: 'customization',
    state: {
        price: 0,
        customizationComponent: [],
        productUserConfig: {},
        abstractParts: [], //保存获取数据后部件带已选标记
        abstractPartsKey: '', //已选部件key值
        data: {},
        colorArray: [], //颜色获取
        colorCode: ``,
        textureArray: [], //纹路获取
        textureCode: ``,
        textureArray: [],
        filtrate: [], //暂时用做物料筛选数据后续
        productCode: ``,
        url: '',
        detail: ``,
        entryNumber: ``,
        shareImgURL: '', //分享图片url
        historyJson: [], //历史纪录
        // historyImg: []
    },
    reducers: {
        save(state, { payload: { data } }) {
            return {...state, data };
        },
        filtrationData(state, { payload: { data } }) {
            let price = data.price;
            const customizationComponent = [];
            const productUserConfig = JSON.parse(data.productUserConfig);
            const abstractParts = data.abstractParts

            abstractParts.map((obj) => {
                    let list_index = ''
                    obj.parts.map((list, index) => {
                        if (list.code == productUserConfig.parts[obj.code].code) {
                            list_index = index
                            price = price * 1 + list.price * 1
                            return false;
                        }
                    })
                    obj.list_index = list_index
                })
                // console.log(productUserConfig)
            return {...state, productUserConfig, price, customizationComponent, abstractParts };
        },
        putImg(state, { payload: { url } }) {
            return {...state, url };
        },
        setAbstractPartsKey(state, { payload: { abstractPartsKey } }) {
            return {...state, abstractPartsKey }
        },
        setColor(state, { payload: { colorArray } }) {
            // console.log(colorArray)
            return {...state, colorArray }
        },
        setTexture(state, { payload: { textureArray } }) {
            // console.log(textureArray)
            return {...state, textureArray }
        },
        saveProductCode(state, { payload: { productCode } }) {
            return {...state, productCode }
        },
        setColorCode(state, { payload: { colorCode } }) {
            // console.log(colorCode)
            return {...state, colorCode }
        },
        setTextureCode(state, { payload: { textureCode } }) {
            // console.log(textureCode)
            return {...state, textureCode }
        },
        setfiltrate(state, { payload: { filtrate } }) {
            return {...state, filtrate }
        },
        setDetail(state, { payload: { detail } }) {
            return {...state, detail }
        },
        saveCustomizationEntryNumber(state, { payload: { entryNumber } }) {
            return {...state, entryNumber }
        },
        setShareImgURL(state, { payload: { shareImgURL } }) {
            // console.log(shareImgURL)
            return {...state, shareImgURL }
        },
        setHistoryJson(state, { payload: { historyJson } }) {
            // let data = JSON.stringify(historyJson.historyJson)

            return {...state, historyJson }
        },
        // setHistoryImg(state, { payload: { historyImg } }) {
        //     return {...state, historyImg }
        // }
    },
    effects: {
        * fetch({ payload: { code_, pk } }, { call, put }) {
            const { code, data } = yield call(customizationService.fetch, { code_, pk });
            if (code == 200) {
                yield put({
                    type: 'save',
                    payload: {
                        data: data.data
                    },
                });
                yield put({
                    type: 'filtrationData',
                    payload: {
                        data: data.data
                    },
                });
                if (!data.data.historyJson) {
                    // 无历史纪录制空
                    yield put({
                        type: 'setHistoryJson',
                        payload: {
                            historyJson: []
                        }
                    })
                } else {
                    // 有历史纪录赋值
                    // console.log(data.data.historyJson.split('_#'))
                    yield put({
                        type: 'setHistoryJson',
                        payload: {
                            historyJson: data.data.historyJson.split('_#')
                        }
                    })
                }

            }
        },
        *
        getImg({}, { call, put, select }) {
            const productUserConfig = yield select(state => state.customization.productUserConfig);
            const { code, data } = yield call(customizationService.getImg, { productUserConfig });
            // 存储历史纪录
            let historyJson = yield select(state => state.customization.historyJson) //历史数据

            if (code == 200) {
                productUserConfig.url = data.url
                if (historyJson.length < 9) {
                    historyJson.push(JSON.stringify(productUserConfig))
                } else {
                    historyJson.splice(9, 1) //删除最后一个
                    historyJson.push(JSON.stringify(productUserConfig))
                }
                yield put({
                        type: 'setHistoryJson',
                        payload: {
                            historyJson
                        }
                    })
                    // console.log(historyJson) //打印历史纪录
                yield put({
                    type: 'putImg',
                    payload: {
                        url: data.url
                    }
                })
            }
        },
        *
        alterComponents({ payload: { component, code } }, { call, put, select }) {
            let baseData = yield select(state => state.customization.data)
            let data = JSON.stringify(baseData)
            data = JSON.parse(data)
            let abstractPartsKey = yield select(state => state.customization.abstractPartsKey)
            let productUserConfig = yield select(state => state.customization.productUserConfig)
            let customizationComponent = data.abstractParts

            let index = customizationComponent[abstractPartsKey].parts.findIndex(item => item.code === code, 1)
                // 标记已选标记
            customizationComponent[abstractPartsKey].parts[index].mark = true
                // console.log(customizationComponent)

            let json = { code: customizationComponent[abstractPartsKey].parts[index].code, sort: customizationComponent[abstractPartsKey].sort }
            productUserConfig.view = customizationComponent[abstractPartsKey].view
            productUserConfig.parts[customizationComponent[abstractPartsKey].code] = json

            data.productUserConfig = JSON.stringify(productUserConfig)

            // 获取图片保存
            yield put({
                    type: 'getImg',
                    payload: {
                        productUserConfig
                    }
                })
                // 重组数据结构
            yield put({
                type: 'filtrationData',
                payload: {
                    data
                },
            });
            // 更改基础数据
            yield put({
                type: 'save',
                payload: {
                    data
                },
            });
        },
        *
        getAbstractPartsKey({ payload: abstractPartsKey }, { call, put, select }) {
            yield put({
                type: 'setAbstractPartsKey',
                payload: {
                    abstractPartsKey
                }
            })
        },
        *
        getFiltrationData({ payload: data }, { call, put, select }) {
            yield put({
                type: 'filtrationData',
                payload: {
                    data
                },
            });
        },
        *
        addCat({ payload: { qty } }, { call, put, select }) {
            let productUserConfig = yield select(state => state.customization.productUserConfig)
            let historyJson = yield select(state => state.customization.historyJson)
            let url = yield select(state => state.customization.url)
            productUserConfig.url = url
            let userConfig = {
                code: productUserConfig.code,
                qty: JSON.stringify(qty),
                userConfig: JSON.stringify(productUserConfig),
                historyJson: historyJson.join("_#")
            }
            const { code, data } = yield call(customizationService.addCat, { userConfig });
            if (code == 200) {
                Toast.success('添加购物袋成功！', durationTime)
            }

        },
        *
        getColor({}, { call, put, select }) {
            let abstractPartsKey = yield select(state => state.customization.abstractPartsKey)
            let productCode = yield select(state => state.customization.productCode)
            let abstractParts = yield select(state => state.customization.abstractParts)

            const { data } = yield call(customizationService.getColor, { productCode, absPartCode: abstractParts[abstractPartsKey].code });
            if (data.code == 200) {
                yield put({
                    type: 'setColor',
                    payload: {
                        colorArray: data.data
                    }
                })
            }
        },
        *
        getTexture({}, { call, put, select }) {
            let abstractPartsKey = yield select(state => state.customization.abstractPartsKey)
            let productCode = yield select(state => state.customization.productCode)
            let abstractParts = yield select(state => state.customization.abstractParts)
            let colorCode = yield select(state => state.customization.colorCode)
            const { data } = yield call(customizationService.getTexture, { productCode, absPartCode: abstractParts[abstractPartsKey].code, color: colorCode });
            if (data.code == 200) {
                yield put({
                    type: 'setTexture',
                    payload: {
                        textureArray: data.data || []
                    }
                })
            }
        },
        *
        getProductCode({ payload: code }, { call, put, select }) {
            yield put({
                type: 'saveProductCode',
                payload: {
                    productCode: code.code
                }
            })
        },
        *
        selectColor({ payload: { index } }, { call, put, select }) {
            let color = yield select(state => state.customization.colorArray)
            let colorArray = JSON.stringify(color)
            colorArray = JSON.parse(colorArray)
            colorArray.forEach((obj, key) => {
                colorArray[key].checked = false
            })
            colorArray[index].checked = true
            yield put({
                type: `setColorCode`,
                payload: {
                    colorCode: colorArray[index].code
                }
            })
            yield put({
                type: 'setColor',
                payload: {
                    colorArray
                }
            })
            yield put({
                type: `setTextureCode`,
                payload: {
                    textureCode: ``
                }
            })
        },
        *
        selectTexture({ payload: { index } }, { call, put, select }) {
            let texture = yield select(state => state.customization.textureArray)
            let textureArray = JSON.stringify(texture)
            textureArray = JSON.parse(textureArray)
            textureArray.forEach((obj, key) => {
                textureArray[key].checked = false
            })
            textureArray[index].checked = true
            yield put({
                type: `setTextureCode`,
                payload: {
                    textureCode: textureArray[index].code
                }
            })
            yield put({
                type: 'setTexture',
                payload: {
                    textureArray
                }
            })
        },
        *
        getDetail({ payload: { partCode } }, { call, put, select }) {
            const { code, data } = yield call(customizationService.getDetail, { partCode });
            if (code == 200) {
                yield put({
                    type: `setDetail`,
                    payload: {
                        detail: data.description
                    }
                })
            }
        },
        *
        getCustomizationList({}, { call, put, select }) {
            let textureCode = yield select(state => state.customization.textureCode)
            let colorCode = yield select(state => state.customization.colorCode)
            let productCode = yield select(state => state.customization.productCode)
            let abstractParts = yield select(state => state.customization.abstractParts)
            let abstractPartsKey = yield select(state => state.customization.abstractPartsKey)
            const { code, data } = yield call(customizationService.getCustomizationList, { productCode, absPartCode: abstractParts[abstractPartsKey].code, textureCode, colorCode });
            if (code == 200) {
                yield put({
                    type: 'setfiltrate',
                    payload: {
                        filtrate: data.data
                    }
                })
            }
        },
        * getCustomizationEntryNumber({ payload: entryNumber }, { call, put, select }) {
            yield put({
                type: `saveCustomizationEntryNumber`,
                payload: {
                    entryNumber
                }
            })
        },
        *
        saveAlter({}, { call, put, select }) {
            const productUserConfig = yield select(state => state.customization.productUserConfig);
            let historyJson = yield select(state => state.customization.historyJson)
            let url = yield select(state => state.customization.url)
            productUserConfig.url = url
            const entryNumber = yield select(state => state.customization.entryNumber);

            let json = {
                userConfig: JSON.stringify(productUserConfig),
                historyJson: historyJson.join('_#')
            }
            const { code, data } = yield call(customizationService.saveAlter, { productUserConfig: json, entryNumber });
            if (code == 200) {
                return true;
            }
        },
        // 获取分享图片
        *
        shareImg({ payload: routerUrl }, { call, put, select }) {
            const productCode = yield select(state => state.customization.productCode);
            const productUserConfig = yield select(state => state.customization.productUserConfig);
            const url = yield select(state => state.customization.url);
            let shareData = {
                image: url,
                url: routerUrl,
                productUserConfig: JSON.stringify(productUserConfig)
            }
            const { code, data } = yield call(customizationService.shareImgService, { code: productCode, shareData });
            if (code == 200) {

                yield put({
                    type: `setShareImgURL`,
                    payload: {
                        shareImgURL: data.url
                    }
                })
            }
        },
        *
        backCustomization({}, { call, put, select }) {
            // 返回设置
            let historyJson = yield select(state => state.customization.historyJson) //历史数据
            let baseData = yield select(state => state.customization.data)
            let data = JSON.stringify(baseData)
            data = JSON.parse(data)

            historyJson.splice(historyJson.length - 1, 1) //删除一步部件数据
            if (historyJson.length > 0) {
                data.productUserConfig = historyJson[historyJson.length - 1]
                yield put({
                    type: 'setHistoryJson',
                    payload: {
                        historyJson
                    }
                })

                yield put({
                    type: 'filtrationData',
                    payload: {
                        data
                    }
                })
                yield put({
                        type: 'putImg',
                        payload: {
                            url: JSON.parse(data.productUserConfig).url
                        }
                    })
                    // 保存大图地址
                    // console.log(historyJson)
                return true;
            } else {
                return false;
            }
        },
        * addCollect({}, { call, put, select }) {
            let productCode = yield select(state => state.customization.productCode)
            let collectData = {
                productUserConfig: {
                    productCode: productCode
                }
            }
            const productUserConfig = yield select(state => state.customization.productUserConfig);
            const historyJson = yield select(state => state.customization.historyJson);

            collectData.productUserConfig.selectJson = JSON.stringify(productUserConfig)
            collectData.productUserConfig.historyJson = historyJson.join("_#")
            const { code, data } = yield call(collectService.addCollect, { collectData });
            if (code == 200) {
                return true;
            }
            return false;
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(async({ pathname, search }) => {
                const { code, pk, entryNumber } = queryString.parse(search);
                if (pathname === `/customization`) {
                    dispatch({ type: 'getProductCode', payload: { code } })
                    if ({ entryNumber }) {
                        dispatch({ type: `getCustomizationEntryNumber`, payload: { entryNumber } })
                    }
                    await dispatch({ type: 'fetch', payload: { code_: code, pk } });
                    dispatch({ type: 'getImg' })
                }
            });
        },
    }
};