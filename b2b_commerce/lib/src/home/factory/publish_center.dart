import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_form.dart';
import 'package:b2b_commerce/src/business/subcontract/form/subcontract_first_form.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PublishCenterPage extends StatefulWidget {
  @override
  _PublishCenterPageState createState() => _PublishCenterPageState();
}

class _PublishCenterPageState extends State<PublishCenterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLoginStatus());
    //埋点>>>进入发布中心
    UmengPlugin.onEvent(
      "publish_center",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '发布中心',
          actions: <Widget>[],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 85,
                      height: 100,
                      child: ImageNumButton(
                        width: 65,
                        height: 90,
                        image: B2BImage.material(),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ProductionOfflineOrder(),
                          //   ),
                          // );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SubContractFirstForm()));
                        },
                        title: '发布转包/转片',
                      ),
                    ),
                    Container(
                      width: 75,
                      height: 100,
                      child: ImageNumButton(
                        width: 65,
                        height: 90,
                        image: B2BImage.free_capacity2(),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.ROUTE_MY_CAPACITY);
                        },
                        title: '发布空闲产能',
                      ),
                    ),
                    Container(
                        width: 85,
                        height: 100,
                        child: ImageNumButton(
                          image: B2BImage.requirement(),
                          imagePadding: EdgeInsets.all(10),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (_) =>
                                          RequirementOrderFormState(),
                                    ),
                                  ],
                                  child: Consumer(
                                    builder: (context,
                                            RequirementOrderFormState state,
                                            _) =>
                                        RequirementOrderForm(
                                      formState: state,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          title: '发布需求',
                        ))
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 25,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  ///检测用户登录状态
  void checkLoginStatus() {
    if (UserBLoC.instance.currentUser.status == UserStatus.OFFLINE) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => B2BLoginPage()),
          ModalRoute.withName('/'));
    }
  }
}
