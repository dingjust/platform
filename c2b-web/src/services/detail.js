import request from '../utils/request-fetch';

export function fetch({ id }) {
    return request(`https://cnodejs.org/api/v1/topic/${id}`);
}