class GlobalConfigs {
  static const PAGE_SIZE = 20;
  static const DEBUG = true;

 static const CONTEXT_PATH = 'https://47.106.112.137:9002';
  // static const CONTEXT_PATH = 'https://192.168.1.103:9002';
  static const BASE_URL = '$CONTEXT_PATH/djwebservices/v2';
  static const ACCESS_TOKEN_KEY = 'access_token';
  static const BASIC_AUTH_TOKEN_KEY = 'basic_auth_token';
  static const AUTH_SERVER_URL = '$CONTEXT_PATH/authorizationserver';
  static const AUTH_TOKEN_URL = '$AUTH_SERVER_URL/oauth/token';
  static const AUTH_CHECK_TOKEN_URL = '$AUTH_SERVER_URL/oauth/check_token';
  static const AUTH_CLIENT_ID_KEY = 'client_id';
  static const AUTH_CLIENT_SECRET = 'client_secret';
  static const AUTH_USERNAME_KEY = 'username';
  static const AUTH_PASSWORD_KEY = 'password';
  static const AUTH_TOKEN_KEY = 'token';

  /// grant types
  static const GRANT_TYPE_PASSWORD = 'password';
  static const GRANT_TYPE_CLIENT_CREDENTIALS = 'client_credentials';
  static const GRANT_TYPE_AUTHORIZATION_CODE = 'authorization_code';
  static const GRANT_TYPE_REFRESH_TOKEN = 'refresh_token';

  /// current context key
  static const CURRENT_CONTEXT_KEY = 'currentContext';

  /// 应用名称（英文），用于获取应用程序目录
  static const APP_NAME = 'dingjust_platform';

  /// 衣加衣base site id
  static const APP_BASE_SITE_ID = 'apparel-zh';
}
