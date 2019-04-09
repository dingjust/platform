import queryString from 'query-string';

export default {
    namespace: 'paymentState',
    state: {},
    reducers: {

    },

    effects: {

    },
    subscriptions: {
        setup({ dispatch, history }) {
            return history.listen(({ pathname, search }) => {
                // const query = queryString.parse(search);
                if (pathname === `/login`) {
                    // dispatch({ type: 'fetch', payload: state => state.login.phone });
                }
            });
        },
    },
};