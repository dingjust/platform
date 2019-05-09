import 'package:alipay_me/alipay_me.dart';

import 'alipay_constants.dart';

class AlipayService {
  static void pay() async {
    final String tid = "tid_${DateTime.now().millisecondsSinceEpoch}";
    await AlipayMe.init(
        appId: AlipayConstants.appId,
        pid: AlipayConstants.pid,
        rsa2Private: AlipayConstants.rsa2Private,
        targetId: tid);
    // 发起支付
    var o = await AlipayMe.pay(
      'alipay_sdk=alipay-sdk-java-3.7.26.ALL&app_id=2019042964340308&biz_content=%7B%22body%22%3A%22%E9%92%89%E5%8D%95%E6%94%AF%E4%BB%98%22%2C%22out_trade_no%22%3A%22PRF00001092%22%2C%22product_code%22%3A%22PRF00001092%22%2C%22subject%22%3A%22PRF00001092%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%220.01%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=https%3A%2F%2Ftest.dingjust.cn%2Fb2b%2FconfirmAlipay&sign=QJPVB0hYEvkOtF4NltPiJWjE43FZ%2FS74PHjfPxvlFKrbm20%2F60kxiic8cTYAveZpQeCefNmgAB4rqcd931Whnrdea1KeU0rpKix9M%2FSIG0qcOrnLc6s1tWuZZIiGxte%2BwspKFTCuqjfEQsrgaKFwtTbYONniNa6qIR%2FBmdhL3jwpCydTIhuLrGkMo2StbgiURZOJH2DTlrGyaMxU2UQeeRwmQYGYEWuXt9PMQCdFy6nFyglC88KmzrgbHyca1bamHD3fG88qct6DZnn3ErvWM9eALn8dJ1sDJu44kds9zTWONLL5S57Lv87nthW8fVTr5pGbcDdkZ%2FuxINrF1Qy8vA%3D%3D&sign_type=RSA2&timestamp=2019-05-09+16%3A00%3A01&version=1.0',
      // urlScheme:
      //     "alisdkdemo", // 这里的URL Schemes中输入的alisdkdemo，为测试demo，实际商户的app中要填写独立的scheme
    );
  }
}
