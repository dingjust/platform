import request from '~/utils/request'
export function preConfigurationList({ productCode, page = 0, pageSize = 30, color, texture, collar, sleeve }) {
    let url = `/c2b/c2b/preConfig/${productCode}?page=${page}&pageSize=${pageSize}`
    if (color)(
        url = url + `&color=${color}`
    )
    if (texture)(
        url = url + `&texture=${texture}`
    )
    if (collar)(
        url = url + `&collar=${collar}`
    )
    if (sleeve)(
        url = url + `&sleeve=${sleeve}`
    )
    return request({ method: 'get', url: url })
}
export function preConfigurationFilters({ productCode }) {
    return request({ method: 'get', url: `/c2b/c2b/preConfig/${productCode}/filters` })
}
