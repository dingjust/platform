import request from '~/utils/request'

export function addAddress({ phone, saveData, id, method }) {
    let url = ``;
    if (id) {
        url = `/c2b/c2b/addresses/${phone}/addresses/${id}`
    } else {
        url = `/c2b/c2b/addresses/${phone}/addresses`
    }

    return request({ method: method, url: url, data: saveData });
}
export function getAddressList({ phone }) {
    return request({ method: 'get', url: `/c2b/c2b/addresses/${phone}/addresses` });
}