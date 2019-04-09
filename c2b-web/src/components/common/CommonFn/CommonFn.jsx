import store from '~/index'
import { routerRedux } from 'dva/router';
const { dispatch } = store;
import queryString from 'query-string';

class CommonFn extends React.Component{
    goUrl=(obj)=>{
        const params = queryString.stringify(obj.params);
        dispatch(routerRedux.push({
            pathname: obj.url,
            search:params
        }));
    }
    getQurey=(hash)=>{
        // console.log(hash)
        let search = hash.split('?');
        return queryString.parse(search[1])
    }   
}
export default CommonFn;
