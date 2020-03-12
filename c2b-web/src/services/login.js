import request from '../utils/request'
export function getCode({ phone }) {
    const key = phone.replace(/\s+/g, "");
    return request({ method: 'get', url: `/c2b/sms/captcha/asm/${key}` });
}
export function login({ code }) {
    return request({ method: 'post', url: `/authorizationserver/oauth/token?client_id=nbyjy&client_secret=password&grant_type=authorization_code&code=${code}` });
}
export function mergeData() {
    return request({ method: 'get', url: `/c2b/c2b/util/checkAnonymous` });
}