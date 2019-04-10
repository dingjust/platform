import request from '../utils/request'
export function getCode({ phone }) {
    const key = phone.replace(/\s+/g, "");
    return request({ method: 'get', url: `/djc2bwebservices/v2/c2b/sms/asm/${key}` });
}
export function login({ code }) {
    return request({ method: 'post', url: `/authorizationserver/oauth/token?client_id=asm&client_secret=password&grant_type=authorization_code&code=${code}` });
}
export function mergeData() {
    return request({ method: 'get', url: `/djc2bwebservices/v2/c2b/util/checkAnonymous` });
}