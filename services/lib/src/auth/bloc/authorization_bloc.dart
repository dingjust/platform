import 'package:models/models.dart';
import 'package:services/services.dart';

class AuthorizationBLoC extends BLoCBase {
  // 工厂模式
  factory AuthorizationBLoC() => _getInstance();

  static AuthorizationBLoC get instance => _getInstance();
  static AuthorizationBLoC _instance;

  AuthorizationBLoC._internal() {
    // 初始化
  }

  static AuthorizationBLoC _getInstance() {
    if (_instance == null) {
      _instance = AuthorizationBLoC._internal();
    }
    return _instance;
  }

  List<Authorization> _authorizations = [];

  List<Authorization> get authorizations => _authorizations;

  Future<List<Authorization>> getAuthorizations(String id) async {
    // AuthorizationResponse response =
    //     await AuthorizationRespository().getAuthorizations(id);

    // if (response != null && response.code == 1) {
    //   _authorizations = response.data;
    //   // _authorizations.remove(Authorization.REQUIREMENT_ORDER_PUBLISH);
    //   return _authorizations;
    // } else {
    //   return null;
    // }
  }

  @override
  void dispose() {
    _authorizations = [];
  }
}
