import request from '../utils/request'
export function getFacility(data) {
    return request({ method: 'post', url: `/djc2bwebservices/v2/c2b/c2m/machine`, data: data });
}
export function getMeasureData(phone) {
    return request({ method: "GET", url: `/djc2bwebservices/v2/c2b/c2m/measuringBody/${phone}` })
}
export function saveMeasureData(data) {

    return request({ method: "put", url: `/djc2bwebservices/v2/c2b/c2m/measuringBody`, data: data })
}