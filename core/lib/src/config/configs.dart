class GlobalConfigs {
  static const PAGE_SIZE = 20;

  // static const DEBUG = false;

  static const DEBUG = true;

  //测试
  // static const CONTEXT_PATH = 'http://sc.nbyjy.net';
  // static const MEDIA_CONTEXT_PATH = 'http://sc.nbyjy.net';

  //本地
  // static const CONTEXT_PATH = 'https://192.168.31.177:9002/djwebservices/v2';
  // static const MEDIA_CONTEXT_PATH = 'http://192.168.31.177';

  // 生产
  static const CONTEXT_PATH = 'https://ht.nbyjy.net';

  // //全站加速
  static const MEDIA_CONTEXT_PATH = 'https://ht.nbyjy.net';

  //   // static const MEDIA_CONTEXT_PATH = 'http://img.nbyjy.net';

  //分享域名
  static const SHARE_CONTEXT_PATH = 'https://share.sc.nbyjy.net'; //测试
  // static const SHARE_CONTEXT_PATH = 'https://share.ht.nbyjy.net'; //生产

  //APP Taro端
  // static const APP_TARO_CONTEXT_PATH = 'http://192.168.31.218'; //
  static const APP_TARO_CONTEXT_PATH = 'https://app.nbyjy.net'; //测试

  /// 通过nginx代理所有b2b前缀的请求
  static const B2B_API_PREFIX = 'b2b'; //测试&生产
  // static const B2B_API_PREFIX = 'b2b-apparel-zh'; //本地

  ///验证
  static const AUTH_SERVER_URL = '$CONTEXT_PATH/authorizationserver';

  // static const AUTH_SERVER_URL =
  //     'https://192.168.31.177:9002/authorizationserver';

  ///websocket 连接
  // static get WEBSOCKET_URL => (String token, String uid) {
  //       return 'ws://47.106.112.137:8088/message?token=$token&userId=$uid';
  //       //  return 'ws://192.168.1.138:8088/message?token=$token&userId=$uid';
  //       // return 'ws://echo.websocket.org';
  //     };

  static const BASE_URL = '$CONTEXT_PATH';
  static const ACCESS_TOKEN_KEY = 'access_token';
  static const USER_KEY = 'user';
  static const REFRESH_TOKEN_KEY = 'refresh_token';
  static const BASIC_AUTH_TOKEN_KEY = 'basic_auth_token';

  static const AUTH_TOKEN_URL = '$AUTH_SERVER_URL/oauth/token';
  static const AUTH_CHECK_TOKEN_URL = '$AUTH_SERVER_URL/oauth/check_token';
  static const AUTH_CLIENT_ID_KEY = 'client_id';
  static const AUTH_CLIENT_SECRET = 'client_secret';
  static const AUTH_USERNAME_KEY = 'username';
  static const AUTH_PASSWORD_KEY = 'password';
  static const AUTH_TOKEN_KEY = 'token';
  static const PRODUCTION_HISTORY_KEYWORD_KEY =
      'production_history_keyword_key';
  static const PRODUCT_HISTORY_KEYWORD_KEY = 'product_history_keyword_key';
  static const PRODUCT_SELECT_HISTORY_KEYWORD_KEY =
      'product_select_history_keyword_key';
  static const ORDER_PRODUCT_HISTORY_KEYWORD_KEY =
      'order_product_history_keyword_key';
  static const FACTORY_HISTORY_KEYWORD_KEY = 'factory_history_keyword_key';
  static const BRAND_INDEX_HISTORY_KEYWORD_KEY =
      'brand_index_history_keyword_key';
  static const Requirement_HISTORY_KEYWORD_KEY =
      'requirement_history_keyword_key';
  static const SALE_HISTORY_KEYWORD_KEY = 'sale_history_keyword_key';
  static const CAPACITY_HISTORY_KEYWORD_KEY = 'capacity_history_keyword_key';

  static const CONTRACT_HISTORY_KEYWORD_KEY = 'contract_history_keyword_key';
  //转包池搜索
  static const SUBCONTRACT_POOL_HISTORY_KEYWORD_KEY =
      'subcontract_pool_history_keyword_key';
  //我的转包搜索
  static const SUBCONTRACT_MINE_HISTORY_KEYWORD_KEY =
      'subcontract_mine_history_keyword_key';

  //合作商选择页搜索
  static const COOPERATOR_SELECT_HISTORY_KEYWORD_KEY =
      'cooperator_select_history_keyword_key';
  //需求选择页搜索
  static const REQURIEMEN_ORDER_SELECT_HISTORY_KEYWORD_KEY =
      'requriemen_order_select_history_keyword_key';

  //生产订单选择页搜索
  static const PURCHASE_ORDER_SELECT_HISTORY_KEYWORD_KEY =
      'purchase_order_select_history_keyword_key';

  /// grant types
  static const GRANT_TYPE_PASSWORD = 'password';
  static const GRANT_TYPE_CLIENT_CREDENTIALS = 'client_credentials';
  static const GRANT_TYPE_AUTHORIZATION_CODE = 'authorization_code';
  static const GRANT_TYPE_REFRESH_TOKEN = 'refresh_token';

  /// current context key
  static const CURRENT_CONTEXT_KEY = 'currentContext';

  /// 应用名称（英文），用于获取应用程序目录
  static const APP_NAME = 'dingjust_platform';

  static const B2B_CLIENT_ID = 'nbyjy_app';
  static const B2B_CLIENT_SECRET = 'password';

  static const String AMAP_TIP_KEY = '16019b7f1babc4b2d81010730bad2504';

  static const String AMAP_LOCATION_KEY_IOS =
      '7ff2f1b6002d0aaa2ef2cb40f76e7c4a';

  static const String ALIPAY_URL_SCHEME = "nbyijiayi";

  static const String LOGO_URL = 'https://cdn-oss.nbyjy.net/logo.jpg';

  static const JPUSH_APPKEY = '824c12a64440fbf70e767a3e';

  ///Websocket心跳事件间隔
  static const HEARTBEAT_DURATION = 30;

  ///友盟APP Key-android
  static const UMENG_APP_KEY_ANDROID = "5e61b75d0cafb2aa19000058";

  ///友盟APP Key-ios
  static const UMENG_APP_KEY_IOS = "5e82e0a00cafb27dda0003ce";

  ///钉钉APPID
  static const DINGDING_APPID = "dingoaee4mq7tb6luuyugg";

  ///IOS BundleId
  static const IOS_BUNDLE_ID = "com.yjy.yijiayi";

  ///CDN-OSS-DOMAIN
  static const CDN_OSS_DOMAIN = "https://cdn-oss.nbyjy.net";
}
