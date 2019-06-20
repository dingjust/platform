class GlobalConfigs {
  static const PAGE_SIZE = 20;
  static const DEBUG = true;
  //测试
  // static const CONTEXT_PATH = 'http://sc.nbyjy.net';
  // static const MEDIA_CONTEXT_PATH = 'http://sc.nbyjy.net';

  // static const CONTEXT_PATH = 'https://192.168.1.186:9002/djwebservices/v2';
  // static const MEDIA_CONTEXT_PATH =
  //     'https://192.168.1.233:9002/djwebservices/v2';
  // static const IMAGE_BASIC_URL = 'http://47.106.112.137:9001/djwebservices/v2';
  // static const CONTEXT_PATH = 'https://192.168.1.191:9002';
  // 生产
  static const CONTEXT_PATH = 'http://ht.nbyjy.net';
  static const MEDIA_CONTEXT_PATH = 'http://img.nbyjy.net';
  // static const CONTEXT_PATH = 'http://platform.dingjust.cn';
  // static const IMAGE_BASIC_URL = 'http://120.78.211.86:9001/djwebservices/v2';

  static const BASE_URL = '$CONTEXT_PATH';
  static const ACCESS_TOKEN_KEY = 'access_token';
  static const USER_KEY = 'user';
  static const REFRESH_TOKEN_KEY = 'refresh_token';
  static const BASIC_AUTH_TOKEN_KEY = 'basic_auth_token';
  static const AUTH_SERVER_URL = '$CONTEXT_PATH/authorizationserver';
  // static const AUTH_SERVER_URL =
  //     'https://192.168.1.186:9002/authorizationserver';
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
  static const ORDER_PRODUCT_HISTORY_KEYWORD_KEY =
      'order_product_history_keyword_key';
  static const FACTORY_HISTORY_KEYWORD_KEY = 'factory_history_keyword_key';
  static const BRAND_INDEX_HISTORY_KEYWORD_KEY =
      'brand_index_history_keyword_key';
  static const Requirement_HISTORY_KEYWORD_KEY =
      'requirement_history_keyword_key';

  /// grant types
  static const GRANT_TYPE_PASSWORD = 'password';
  static const GRANT_TYPE_CLIENT_CREDENTIALS = 'client_credentials';
  static const GRANT_TYPE_AUTHORIZATION_CODE = 'authorization_code';
  static const GRANT_TYPE_REFRESH_TOKEN = 'refresh_token';

  /// current context key
  static const CURRENT_CONTEXT_KEY = 'currentContext';

  /// 应用名称（英文），用于获取应用程序目录
  static const APP_NAME = 'dingjust_platform';

  /// 通过nginx代理所有b2b前缀的请求
  static const B2B_API_PREFIX = 'b2b';
  // static const B2B_API_PREFIX = 'b2b-apparel-zh';
  static const B2B_CLIENT_ID = 'nbyjy';
  static const B2B_CLIENT_SECRET = 'password';

  static const String AMAP_TIP_KEY = '16019b7f1babc4b2d81010730bad2504';

  static const String AMAP_LOCATION_KEY_IOS =
      '7ff2f1b6002d0aaa2ef2cb40f76e7c4a';

  static const String ALIPAY_URL_SCHEME = "nbyijiayi";

  static const String LOGO_URL =
      'http://img.nbyjy.net/resource/h01/h57/8797905813534.jpg';
}
