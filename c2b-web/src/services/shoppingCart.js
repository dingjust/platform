import request from '~/utils/request'

export function getCatList({ phone }) {
    return request({ method: 'get', url: `/c2b/c2b/users/${phone}/carts` });
}

export function serversSaveQuantity({ phone, entryNumber, number }) {
    return request({ method: 'post', url: `/c2b/c2b/users/${phone}/carts?entryNumber=${entryNumber}&qty=${number}` });

}
export function deleteCart({ phone, entries }) {
    return request({ method: 'delete', url: `/c2b/c2b/users/${phone}/carts`, data: entries });
}
// 转入收藏夹
export function addColect({ phone, cartCode, entries }) {
    return request({ method: 'post', url: `/c2b/c2b/users/${phone}/carts/${cartCode}/favorite`, data: { entries: entries } });

}
