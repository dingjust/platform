const COMMON_APIS = {
  /// 发送短信验证码
  sendCaptcha(phone) {
    return "/b2b/sms/captcha/" + phone;
  },
  /// 获取推荐码对应用户信息
  recommendCodeInfo(code) {
    return "/b2b/user/recommend/code/detail/" + code;
  },
  /// 注册
  fastRegister(type) {
    return "/b2b/companies/register/fast/" + type;
  }
};

export { COMMON_APIS };
