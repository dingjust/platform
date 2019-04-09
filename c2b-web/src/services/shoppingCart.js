import request from '~/utils/request'

export function getCatList({ phone }) {
    return request({ method: 'get', url: `/djc2bwebservices/v2/c2b/users/${phone}/carts` });
}

export function serversSaveQuantity({ phone, entryNumber, number }) {
    return request({ method: 'post', url: `/djc2bwebservices/v2/c2b/users/${phone}/carts?entryNumber=${entryNumber}&qty=${number}` });

}
export function deleteCart({ phone, entries }) {
    return request({ method: 'delete', url: `/djc2bwebservices/v2/c2b/users/${phone}/carts`, data: entries });
}
// 转入收藏夹
export function addColect({ phone, cartCode, entries }) {
    return request({ method: 'post', url: `/djc2bwebservices/v2/c2b/users/${phone}/carts/${cartCode}/favorite`, data: { entries: entries } });

}