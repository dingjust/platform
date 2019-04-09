import request from '~/utils/request'
import { func } from 'prop-types';
export function addCollect({ collectData }) {
    return request({ method: 'post', url: `/djc2bwebservices/v2/c2b/favorite/favorites`, data: collectData })
}
export function collectList({ page, pageSize, phone }) {
    if (!page) {
        page = 0
    }
    if (!pageSize) {
        pageSize = 20
    }
    return request({ method: 'get', url: `/djc2bwebservices/v2/c2b/favorite/favorites?customerId=${phone}&page=${page}&pageSize=${pageSize}` })
}
export function deteteCollect({ checkCollect }) {
    return request({ method: 'delete', url: `/djc2bwebservices/v2/c2b/favorite/favorites`, data: checkCollect })
}
export function alterCollect({ productUserConfig }) {
    return request({ method: 'PUT', url: `/djc2bwebservices/v2/c2b/favorite/favorites`, data: productUserConfig })
}