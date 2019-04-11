import request from '../utils/request'
export function fetch() {
    return request({ method: 'post', url: `/c2b/c2b/catalogs/getCustomizable` });
}
export function getBanner() {
    return request({ method: "GET", url: "/c2b/c2b/carousel/carousels?active=true" })
}
