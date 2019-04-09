import queryString from 'query-string';
import * as usersService from '../services/index';
// import { PREFIX } from '../constants';

export default {
    namespace: 'index',
    state: {
        data: []
    },
    reducers: {
        save(state, { payload: { data } }) {
            return {...state, data };
        },
    },
    effects: {
        * fetch({}, { call, put }) {
            const { data } = yield call(usersService.fetch);
            // const banner = yield call(usersService.getBanner);


            yield put({
                type: 'save',
                payload: {
                    data: data.data
                },
            });
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(({ pathname, search }) => {
                const query = queryString.parse(search);
                if (pathname === `/`) {
                    dispatch({ type: 'fetch', payload: query });
                }
            });
        },
    },
};