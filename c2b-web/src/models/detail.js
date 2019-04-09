import queryString from 'query-string';
import * as usersService from '../services/detail';
// import { PREFIX } from '../constants';

export default {
    namespace: 'detail',
    state: {
        data: null,
    },
    reducers: {
        save(state, { payload: { data } }) {
            return {...state, data };
        },
    },
    effects: {
        * fetch({ payload: { id } }, { call, put }) {
            const { data } = yield call(usersService.fetch);
            yield put({
                type: 'save',
                payload: {
                    data,
                },
            });
        },
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(({ pathname, search }) => {
                const query = queryString.parse(search);
                console.log(query);
                if (pathname === `/detail`) {
                    dispatch({ type: 'fetch', payload: query });
                }
            });
        },
    },
};