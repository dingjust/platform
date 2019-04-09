import React from 'react';
import {Route, Router,Switch } from 'dva/router';

import dynamic from 'dva/dynamic';
// import SlideRouter from "components/common/SlideRouter/index";

// import AnimatedRouter from 'react-animated-router'; //导入我们的的AnimatedRouter组件
import AnimatedRouter from 'components/common/AnimatedRouter/AnimatedRouter'
import 'components/common/AnimatedRouter/AnimatedRouter.css'; //导

// 引入页面
// import _Index from "./routes/index/Index"
// import _IndexPage from "./routes/IndexPage"
// import _Users from "./routes/users/Users"
// import _Login from "./routes/login/Login"
// import _Customization from "./routes/customization/Customization"
// import _ShoppingCart from "./routes/shoppingCart/ShoppingCart"
// import _SubmitOrder from "./routes/submitOrder/SubmitOrder"
// import _PaymentState from "./routes/paymentState/PaymentState"

function RouterConfig({ history, app }) {

  const Index_ = dynamic({
    app,
    models:()=>[
      import('./models/index'),
    ],
    component: () => import('./routes/index/Index'),
    // component:_Index
  })
  const IndexPage = dynamic({
    app,
    models:()=>[
      import('./models/shoppingCart'),
      import('./models/index')
    ],
    component: () => import('./routes/IndexPage'),
    // component:_IndexPage
  })
  const Users = dynamic({
    app,
    models:()=>[
      // import('./models/index'),
    ],
    component: () => import('./routes/users/Users'),
    // component:_Users
  })

  // const Detail = dynamic({
  //   app,
  //   models: () => [
  //     import('./models/detail'),
  //   ],
  //   component: () => import('./routes/detail/Detail'),
  // });
  const Login = dynamic({
    app,
    models: () => [
      import('./models/login'),
    ],
    component: () => import('./routes/login/Login'),
    // component:_Login
  });

  const Customization = dynamic({
    app,
    models: () => [
      import('./models/customization'),
    ],
    component: () => import('./routes/customization/Customization'),
    // component:_Customization
  });

  const ShoppingCart = dynamic({
    app,
    models: () => [
      import('./models/shoppingCart'),
    ],
    component: () => import('./routes/shoppingCart/ShoppingCart'),
    // component: _ShoppingCart,
  });
  const SubmitOrder = dynamic({
    app,
    models: () => [
      import('./models/submitOrder'),
    ],
    component: () => import('./routes/submitOrder/SubmitOrder'),
    // component:_SubmitOrder
  });
  const PaymentState = dynamic({
    app,
    models: () => [
      import('./models/paymentState'),
    ],
    component: () => import('./routes/paymentState/PaymentState'),
    // component:_PaymentState
  });

  // 新增地址
  const AddAddress = dynamic({
    app,
    models: () => [
      import('./models/address'),
    ],
    component: () => import('./routes/address/AddAddress'),
    // component:_PaymentState
  });

  // 地址列表
  const AddressList = dynamic({
    app,
    models: () => [
      import('./models/address'),
    ],
    component: () => import('./routes/address/AddressList'),
    // component:_PaymentState
  });
  const MeasureSelect = dynamic({
    app,
    models: () => [
    ],
    component: () => import('./routes/measureData/MeasureSelect'),
    // component:_PaymentState
  });
  
  const MeasureData = dynamic({
    app,
    models: () => [
      import('./models/measureData'),
    ],
    component: () => import('./routes/measureData/MeasureData'),
    // component:_PaymentState
  });

  // 量体设备
  
  const MeasureState = dynamic({
    app,
    models: () => [
      import('./models/measureData'),
    ],
    component: () => import('./routes/measureData/MeasureState'),
    // component:_PaymentState
  });

// 支付方式
const PaymentCode = dynamic({
  app,
  models: () => [
    import('./models/paymentState'),
  ],
  component: () => import('./routes/paymentState/PaymentCode'),
  // component:_PaymentState
});

// 收藏
const Collect = dynamic({
  app,
  models:()=>[
    import('./models/collect')
  ],
  component:()=>import('./routes/collect/Collect')
})
// 预配置
const PreConfiguration = dynamic({
  app,
  models:()=>[
    import('./models/preConfiguration')
  ],
  component:()=>import('./routes/preConfiguration/PreConfiguration')
})

// 基础信息

const UsersData = dynamic({
  app,
  models:()=>[
    // import('./models/preConfiguration')
  ],
  component:()=>import('./routes/users/UsersData')
})
  return (
  <Router history={history}>
    {/* <AnimatedRouter timeout={500} > */}
    <Switch>
      <Route path='/users' component={Users}/>
      <Route path='/customization' component={Customization}/>
      <Route path='/shoppingCart' component={ShoppingCart} />
      <Route path='/index' component={Index_}/>
      <Route path="/login" component={Login}/>
      <Route path="/submitOrder" component={SubmitOrder}/>
      <Route path="/submitOrder" component={SubmitOrder}/>
      <Route path="/paymentState" component={PaymentState}/>
      <Route path="/addAddress" component={AddAddress}/>
      <Route path="/addressList" component={AddressList}/>
      {/* 量体选择 */}
      <Route path="/measureSelect" component={MeasureSelect}/>
      {/* 量体数据 */}
      <Route path="/measureData" component={MeasureData}/>
      <Route path="/paymentCode" component={PaymentCode}/>
      {/* 量体设备/       */}
      <Route path="/measureState" component={MeasureState}></Route>
      {/* 收藏 */}
      <Route path="/collect" component={Collect}></Route>
      {/* 预配置 */}
      <Route path="/preConfiguration" component={PreConfiguration}></Route>

      <Route exact path='/' component={IndexPage}/>
      <Route exact path='/usersData' component={UsersData}/>


      
    </Switch>
    {/* </AnimatedRouter> */}
  </Router>
  );
}

export default RouterConfig;
