import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///认证状态
class CertificationStatusHelper {
  bool ignore;

  CertificationState certificationState;

  CertificationStatusHelper({this.ignore = false});

  ///校验认证状态
  void checkCertificationStatus() async {
    if (UserBLoC.instance.currentUser.status != UserStatus.ONLINE ||
        UserBLoC.instance.currentUser.b2bUnit == null) {
      return;
    }

    ///获取认证信息
    if (certificationState == null) {
      certificationState = await ContractRepository().getAuthenticationState();
    }

    if (!_authenticated(certificationState.data) && !ignore) {
      showUncertifiedDialog(true, cancel: () {
        ignore = true;
      }, confirm: () {}, backgroundReturn: () {}, physicalBackButton: () {});
    }
  }

  ///校验资料完善
  void checkProfile(VoidCallback callback) {
    //TODO:校验资料
    showProfileCompleteDialog(true, cancel: () {}, confirm: callback);
  }

  bool _authenticated(AuthenticationModel model) {
    if (model.personalState == AuthenticationState.SUCCESS ||
        model.companyState == AuthenticationState.SUCCESS) {
      return true;
    } else {
      return false;
    }
  }
}
