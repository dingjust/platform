abstract class WechatService {
  //调起微信支付
  Future pay(String orderCode);

  //微信文字分享
  Future shareText(String content);
}
