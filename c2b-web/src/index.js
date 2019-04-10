import dva from 'dva';
// import createHistory from 'history/createBrowserHistory';
import createLoading from 'dva-loading';
import { Toast } from 'antd-mobile';
import './index.less';
import Cookie from "~/utils/cookie";

const ERROR_MSG_DURATION = 3; // 3 秒

// 1. Initialize
const app = dva({
    // history: createHistory(),
    onError(e) {
        Toast.fail(e.message, ERROR_MSG_DURATION);
    },
});

// 2. Plugins
app.use(createLoading());

// 3. Model
// Moved to router.js

// 4. Router
app.router(require('./router'));

// 5. Start
app.start('#root');

// 保存进入网站第一个页面hash
let hash = document.location.hash
hash = hash.replace(/#+/g, "")
Cookie.set('hash', hash)

// 初始化匿名用户
let phone = Cookie.get('phone');
if (!phone) {
    Cookie.set('phone', 'anonymous')
}
export default app._store;