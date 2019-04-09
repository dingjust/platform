import queryString from 'query-string';
import * as shoppingCart from '~/services/shoppingCart';
import * as customizationService from '~/services/customization';

import Cookie from '~/utils/cookie';

export default {
    namespace: 'shoppingCart',
    state: {
        entries: [],
        checkEntries: [],
        cartCode: ``,
        price: 0,
        filtrate: [],
        colorArray: [],
        colorCode: ``,
        textureCode: ``,
        textureArray: [],
        absPartCode: '',
        productCode: '',
        detail: ``
    },
    reducers: {
        save(state, { payload: { entries, cartCode } }) {
            // console.log({ entries, cartCode })
            return {...state, entries, cartCode };
        },
        saveEntries(state, { payload: { data } }) {

            let entries = JSON.stringify(data)
            entries = JSON.parse(entries)
            return {
                ...state,
                entries
            }
        },
        setfiltrate(state, { payload: { filtrate } }) {
            return {...state, filtrate }
        },
        saveCheckEntries(state, { payload: { checkEntries } }) {
            // console.log(checkEntries)
            return {
                ...state,
                checkEntries
            }
        },
        saveTotalMoney(state, { payload: { price } }) {
            return {
                ...state,
                price
            }
        },
        setColor(state, { payload: { colorArray } }) {
            // console.log(colorArray)
            return {...state, colorArray }
        },
        setTexture(state, { payload: { textureArray } }) {
            // console.log(textureArray)
            return {...state, textureArray }
        },
        setProductCode(state, { payload: { productCode } }) {
            return {...state, productCode }
        },
        setAbsPartCode(state, { payload: { absPartCode } }) {
            return {...state, absPartCode }
        },
        setColorCode(state, { payload: { colorCode } }) {
            // console.log(colorCode)
            return {...state, colorCode }
        },
        setTextureCode(state, { payload: { textureCode } }) {
            // console.log(textureCode)
            return {...state, textureCode }
        },
        setDetail(state, { payload: { detail } }) {
            return {...state, detail }
        }
    },
    effects: {
        * getCatList({}, { call, put }) {
            yield put({
                type: 'saveTotalMoney',
                payload: {
                    price: 0
                },
            });
            yield put({
                type: 'saveCheckEntries',
                payload: {
                    checkEntries: []
                }
            })
            let phone = Cookie.get(`phone`)
            const { data, code } = yield call(shoppingCart.getCatList, { phone });

            if (code == 200) {
                let { entries } = data.data
                let cartCode = data && data.data.code
                yield put({
                    type: 'save',
                    payload: {
                        entries: entries || [],
                        cartCode
                    },
                });
                yield put({
                    type: 'saveCheckEntries',
                    payload: {
                        checkEntries: []
                    },
                })
            }
        },
        * editQuantity({ payload: { number, index } }, { call, put, select }) {
            let data = yield select(state => state.shoppingCart.entries)
            data[index].quantity = number
            data[index].tolPrice = (number * data[index].basPrice).toFixed(2)
            yield put({
                type: 'saveEntries',
                payload: {
                    data
                },
            });
        },
        * serversSaveQuantity({ payload: { number, index, entryNumber } }, { call, put, select }) {
            let phone = Cookie.get(`phone`)
            const { code } = yield call(shoppingCart.serversSaveQuantity, { phone, entryNumber, number });
            let data = yield select(state => state.shoppingCart.entries)
            if (number == 0) {
                data.splice(index, 1);
            }
            yield put({
                type: 'saveEntries',
                payload: {
                    data
                },
            });
        },
        * getChecked({ payload: { state, index } }, { call, put, select }) {
            let data = yield select(state => state.shoppingCart.entries)
            data[index].checked = state
            let checkEntries = yield select(state => state.shoppingCart.checkEntries)
            if (state) {
                checkEntries.push(data[index].entryNumber)
            } else {
                checkEntries.splice(checkEntries.findIndex(item => item.entryNumber === data[index].entryNumber), 1)
            }
            yield put({
                type: 'saveCheckEntries',
                payload: {
                    checkEntries
                },
            });
            yield put({
                type: 'saveEntries',
                payload: {
                    data
                },
            });
        },
        * deleteCart({ payload: { deleteId = null } }, { call, put, select }) {
            // data.splice(index, 1);
            let data = yield select(state => state.shoppingCart.entries)
            let phone = Cookie.get(`phone`);
            let entriesArray = yield select(state => state.shoppingCart.checkEntries)

            if (deleteId) {
                //侧滑删除
                entriesArray.push(deleteId)
            }
            let entries = { entries: entriesArray.join(",") }
            const { code } = yield call(shoppingCart.deleteCart, { phone, entries });
            // console.log(entriesArray)
            if (code == 200) {
                for (const [index, item] of entriesArray.entries()) {
                    console.log(entriesArray)
                    if (data.findIndex(obj => obj.entryNumber === item) != -1) {
                        data.splice(data.findIndex(obj => obj.entryNumber === item), 1)
                    }
                }
                yield put({
                    type: 'saveCheckEntries',
                    payload: {
                        checkEntries: []
                    }
                })
                yield put({
                    type: 'saveTotalMoney',
                    payload: {
                        price: 0
                    },
                });
                yield put({
                    type: 'saveEntries',
                    payload: {
                        data
                    },
                });
            }
        },
        * allCheck({ payload: state }, { call, put, select }) {
            let entries = yield select(state => state.shoppingCart.entries)

            let checkArray = []
            for (const [index, item] of entries.entries()) {
                if (state.state) {
                    checkArray.push(item.entryNumber)
                    entries[index].checked = true;
                } else {
                    entries[index].checked = false;
                }
            }

            yield put({
                    type: 'saveCheckEntries',
                    payload: {
                        checkEntries: checkArray
                    }
                }),
                yield put({
                    type: 'saveEntries',
                    payload: {
                        data: entries
                    },
                });
        },
        * totalMoney({}, { call, put, select }) {
            let price = 0
            let entries = yield select(state => state.shoppingCart.entries)

            entries.map((obj) => {
                    if (obj.checked) {
                        price = (price * 1 + obj.basPrice * obj.quantity).toFixed(2)
                    }
                })
                // console.log(price)
            yield put({
                type: `saveTotalMoney`,
                payload: {
                    price
                }
            })

        },
        * getCustomizationList({ payload: { productCode, absPartCode, textureCode, colorCode } }, { call, put, select }) {

            if (productCode == ``) {
                productCode = yield select(state => state.shoppingCart.productCode)
                absPartCode = yield select(state => state.shoppingCart.absPartCode)
            }
            if (textureCode != ``) {
                textureCode = yield select(state => state.shoppingCart.textureCode)
                colorCode = yield select(state => state.shoppingCart.colorCode)
            }

            yield put({
                type: `setProductCode`,
                payload: {
                    productCode
                }
            })
            yield put({
                type: `setAbsPartCode`,
                payload: {
                    absPartCode
                }
            })
            const { code, data } = yield call(customizationService.getCustomizationList, { productCode, absPartCode, textureCode, colorCode });

            if (code == 200) {
                yield put({
                    type: 'setfiltrate',
                    payload: {
                        filtrate: data.data
                    }
                })
            }
        },
        * getColor({ payload: {} }, { call, put, select }) {
            let productCode = yield select(state => state.shoppingCart.productCode)
            let absPartCode = yield select(state => state.shoppingCart.absPartCode)

            const { data } = yield call(customizationService.getColor, { productCode, absPartCode });
            if (data.code == 200) {
                yield put({
                    type: 'setColor',
                    payload: {
                        colorArray: data.data
                    }
                })
            }
        },
        * getTexture({}, { call, put, select }) {

            let colorCode = yield select(state => state.shoppingCart.colorCode)
            let productCode = yield select(state => state.shoppingCart.productCode)
            let absPartCode = yield select(state => state.shoppingCart.absPartCode)


            const { data } = yield call(customizationService.getTexture, { productCode, absPartCode, color: colorCode });
            if (data.code == 200) {
                yield put({
                    type: 'setTexture',
                    payload: {
                        textureArray: data.data || []
                    }
                })
            }
        },
        * selectColor({ payload: { index } }, { call, put, select }) {
            let color = yield select(state => state.shoppingCart.colorArray)
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
        * selectTexture({ payload: { index } }, { call, put, select }) {
            let texture = yield select(state => state.shoppingCart.textureArray)
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
        * getDetail({ payload: { partCode } }, { call, put, select }) {
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
        // 购物车修改部件
        * alterComponents({ payload: { component, index, listIndex, entryNumber } }, { call, put, select }) {
            let listData = yield select(state => state.shoppingCart.entries)
            let description = listData[listIndex].userConfig.description
            description = JSON.parse(description)
            let selectJson = listData[listIndex].userConfig.selectJson
            selectJson = JSON.parse(selectJson)
                // 修改部件信息
            selectJson.parts[description.parts[index].absPart].code = component.code

            // 获取大图
            const { code, data } = yield call(customizationService.getImg, { productUserConfig: selectJson });
            if (code == 200) {
                selectJson.url = data.url
                listData[listIndex].product.image = data.url
            }
            let productUserConfig = { userConfig: JSON.stringify(selectJson) }

            // 修改部件
            const alterState = yield call(customizationService.saveAlter, { productUserConfig, entryNumber });
            if (alterState.code == 200) {
                description.parts[index].value = component.name
                description.parts[index].image = component.thumbnail
                description.parts[index].part = component.code
                listData[listIndex].userConfig.description = JSON.stringify(description)
                listData[listIndex].userConfig.selectJson = JSON.stringify(selectJson)
                yield put({
                    type: 'saveEntries',
                    payload: {
                        data: listData
                    },
                });
                return true;
            }
            return false;
        },
        // 转入收藏夹
        * addCollect({ payload: { entries, index_ } }, { call, put, select }) {
            const phone = Cookie.get('phone'),
                baseData = yield select(state => state.shoppingCart.entries),
                cartCode = yield select(state => state.shoppingCart.cartCode),
                { code, data } = yield call(shoppingCart.addColect, { phone, cartCode, entries });

            if (code == 200) {
                baseData.splice(index_, 1)
                yield put({
                    type: 'saveEntries',
                    payload: {
                        data: baseData
                    },
                });
                return true;
            }
            return false;
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(({ pathname, search }) => {
                if (pathname === `/shoppingCart`) {
                    dispatch({ type: 'getCatList' });
                    // dispatch({ type: 'getCatList' });

                }
            });
        },
    },
};