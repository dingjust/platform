import request from '../utils/request'
export function fetch() {
    return request({ method: 'post', url: `/djc2bwebservices/v2/c2b/catalogs/getCustomizable` });
}
export function getBanner() {
    return request({ method: "GET", url: "/djc2bwebservices/v2/c2b/carousel/carousels?active=true" })
}