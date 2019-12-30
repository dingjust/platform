import 'package:b2b_commerce/src/my/company/form/my_brand_base_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_form.dart';
import 'package:b2b_commerce/src/my/my_authentication.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///认证状态
class CertificationStatusHelper {
  bool certificationIgnore;

  CertificationState certificationState;

  CertificationStatusHelper({this.certificationIgnore = false});

  ///校验认证状态
  void checkCertificationStatus(BuildContext context) async {
    if (UserBLoC.instance.currentUser.status != UserStatus.ONLINE ||
        UserBLoC.instance.currentUser.b2bUnit == null) {
      return;
    }

    ///获取认证信息
    if (certificationState == null) {
      certificationState = await ContractRepository().getAuthenticationState();
    }

    if (!_authenticated(certificationState.data) && !certificationIgnore) {
      showUncertifiedDialog(true,
          cancel: () {
            certificationIgnore = true;
          },
          confirm: () => jumpToAuthentication(context),
          backgroundReturn: () {},
          physicalBackButton: () {});
    } else {
      //校验资料完善
      oncheckProfile(context: context, onJump: () {});
    }
  }

  ///校验资料弹窗
  void checkProfile(VoidCallback onJump, VoidCallback onProfile) {
    //校验资料
    if (UserBLoC.instance.currentUser.b2bUnit == null) {
      onJump();
      return;
    }
    bool profileCompleted =
        UserBLoC.instance.currentUser.b2bUnit.profileCompleted;
    if (profileCompleted != null && profileCompleted) {
      onJump();
    } else {
      showProfileCompleteDialog(true, cancel: () {}, confirm: onProfile);
    }
  }

  ///校验资料
  void oncheckProfile({BuildContext context, VoidCallback onJump}) {
    checkProfile(onJump, () => jumpToCompanyIntroduction(context));
  }

  ///跳转到公司资料表单
  void jumpToCompanyIntroduction(BuildContext context) {
    UserBLoC bloc = UserBLoC.instance;
    // 品牌详情
    if (bloc.currentUser.type == UserType.BRAND) {
      UserRepositoryImpl().getBrand(bloc.currentUser.companyCode).then((brand) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBrandBaseFormPage(brand)));
      });
    }
    // 工厂详情
    if (bloc.currentUser.type == UserType.FACTORY) {
      UserRepositoryImpl()
          .getFactory(bloc.currentUser.companyCode)
          .then((factory) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyFactoryFormPage(
                  factory: factory,
                ),
          ),
        );
      });
    }
  }

  ///跳转到认证页面
  void jumpToAuthentication(BuildContext context) {
    UserBLoC bloc = UserBLoC.instance;
    // 品牌认证
    if (bloc.currentUser.type == UserType.BRAND) {
      UserRepositoryImpl().getBrand(bloc.currentUser.companyCode).then((brand) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyAuthentication(company: brand),
          ),
        );
      });
    }
    // 工厂认证
    if (bloc.currentUser.type == UserType.FACTORY) {
      UserRepositoryImpl()
          .getFactory(bloc.currentUser.companyCode)
          .then((factory) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyAuthentication(company: factory),
          ),
        );
      });
    }
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
