import request from '~/utils/request'
import Cooie from '~/utils/cookie'
import { func } from 'prop-types';

export function fetch({ code_, pk }) {
    let productsPk = ``
    if (pk) {
        productsPk = `?select=${pk}`
    }
    return request({ method: 'post', url: `/c2b/c2b/products/${code_}${productsPk}` });
}
export function getImg({ productUserConfig }) {
    // console.log(productUserConfig)
    return request({ method: 'post', url: '/imageserver/api/render/image', data: productUserConfig });
}
export function addCat({ userConfig }) {
    const phone = Cooie.get(`phone`)
    return request({ method: 'put', url: `/c2b/c2b/users/${phone}/carts`, data: userConfig });
}
export function getColor({ productCode, absPartCode }) {
    return request({ method: 'post', url: `/c2b/c2b/products/searchColor?productCode=${productCode}&absPartCode=${absPartCode}` })
}
export function getTexture({ productCode, absPartCode, color }) {
    let colorString = color ? `&color=${color}` : ''

    return request({ method: 'post', url: `/c2b/c2b/products/searchTexture?productCode=${productCode}&absPartCode=${absPartCode}${colorString}` })
}
export function getCustomizationList({ productCode, absPartCode, textureCode, colorCode }) {
    let url = `/c2b/c2b/products/searchParts?productCode=${productCode}&absPartCode=${absPartCode}&page=0&pageSize=100`
    if (colorCode) {
        url = `${url}&colorCode=${colorCode}`
    }
    // console.log(textureCode)
    if (textureCode) {
        url = `${url}&texture=${textureCode}`
    }
    return request({ method: 'post', url: `${ url }` })
}
export function getDetail({ partCode }) {
    return request({ method: "get", url: `/c2b/c2b/products/partDetail?partCode=${partCode}` })
}

export function saveAlter({ productUserConfig, entryNumber }) {
    console.log(entryNumber)
    const phone = Cooie.get(`phone`)
    return request({ method: `post`, url: `/c2b/c2b/users/${phone}/carts?entryNumber=${entryNumber}`, data: productUserConfig })
}

export function shareImgService({ code, shareData }) {
    return request({ method: `Post`, url: `/c2b/c2b/products/${code}/share`, data: shareData })
}