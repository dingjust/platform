import request from '../utils/request'
export function getOrderDetails({ entries, cartCode, phone }) {
    return request({ method: 'post', url: `/djc2bwebservices/v2/c2b/users/${phone}/carts/${cartCode}/checkout`, data: { entries } });
}
export function submitOrder({ phone, data }) {
    return request({ method: 'post', url: `/djc2bwebservices/v2/c2b/users/${phone}/createOrder`, data: data });
}