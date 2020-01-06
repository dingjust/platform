import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './my_brand.dart';
import './my_factory.dart';
import '../_shared/widgets/image_factory.dart';
import '../common/app_image.dart';
import '../common/app_keys.dart';
import '../common/app_routes.dart';
import 'account/profile.dart';
import 'my_authentication.dart';

var menuSeparator = Container(
  padding: const EdgeInsets.fromLTRB(70, 0, 20, 0),
  child: const Divider(height: 0),
);

/// 我的
class MyHomePage extends StatefulWidget {
  final VoidCallback turnToHome;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  MyHomePage({this.turnToHome}) : super(key: AppKeys.myHomePage);
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  final double _appBarHeight = 160.0;

  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    ///极光初始化
    jpush$.setContext(context);

    final List<Widget> menus = <Widget>[
      Menu('', <Widget>[
        // MenuItem(B2BImage.myAccount(width: 23, height: 27), '我的账户',
        //     AppRoutes.ROUTE_MY_ACCOUNT),
        menuSeparator,
        CompanyIntroductionMenuItem(),
        menuSeparator,
        CompanyCertificationMenuItem()
      ]),
      Menu('', <Widget>[
        MenuItem(B2BImage.addressManage(width: 24, height: 29), '地址管理',
            AppRoutes.ROUTE_MY_ADDRESSES),
        menuSeparator,
        MenuItem(B2BImage.invoiceManage(width: 26, height: 21), '发票管理',
            AppRoutes.ROUTE_MY_INVOICES),
        menuSeparator,
      ]),
      Menu('', <Widget>[
        MenuItem(B2BImage.customerService(width: 25, height: 25), '联系客服',
            AppRoutes.ROUTE_MY_CLIENT_SERVICES),
        menuSeparator,
        MenuItem(B2BImage.help(width: 25, height: 24), '问题与帮助',
            AppRoutes.ROUTE_MY_HELP),
        menuSeparator,
        MenuItem(B2BImage.setting(width: 25, height: 24), '设置',
            AppRoutes.ROUTE_MY_SETTINGS),
      ]),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              actions: <Widget>[
                // Container(
                //   margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                //   child: NotificationsIcon(),
                // ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                key: AppKeys.myHomeSpaceBar,
                title: StreamBuilder<UserModel>(
                  stream: bloc.stream,
                  initialData: bloc.currentUser,
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel> snapshot) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${snapshot.data.name}',
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildTopBackground(context, bloc.currentUser),
                    _buildSwitchBtn(context),
                  ],
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(menus)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBackground(BuildContext context, UserModel user) {
    return GestureDetector(
      onTap: () {
        if (user.status != UserStatus.ONLINE) {
          Navigator.of(context)
              .push((MaterialPageRoute(builder: (context) => B2BLoginPage())));
        } else {
          Navigator.of(context)
              .push((MaterialPageRoute(builder: (context) => ProfilePage())))
              .then((val) {
            //修改资料后刷新
            setState(() {});
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Row(
          children: <Widget>[
            _buildPortrait(context, user),
            Expanded(
              flex: 1,
              child: _buildInformation(context, user),
            )
          ],
        ),
        decoration: const BoxDecoration(
          color: const Color.fromRGBO(255, 219, 0, 1),
        ),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context, UserModel user) {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
      child: Container(
        child: ImageFactory.buildDefaultAvatar(user.profilePicture),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.5),
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular((50.0)),
        ),
      ),
    );
  }

  Widget _buildInformation(BuildContext context, UserModel user) {
    if (user.status == UserStatus.ONLINE) {
      return Container(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "${user.name}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(36, 38, 41, 1),
                        ),
                      ),
                    ))
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    '${UserBLoC.instance.currentUser.companyName}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: const Color.fromRGBO(132, 114, 1, 1),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        child: Text(
          '登录/注册',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }

  Widget _buildSwitchBtn(BuildContext context) {
    return Positioned(
      top: 25,
      right: 0,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        color: Color.fromRGBO(253, 246, 67, 0.5),
        child: Container(
          child: Row(
            children: <Widget>[
              Icon(B2BIcons.switch_identity),
              Text(
                  '切换至${UserBLoC.instance.currentUser.type == UserType.BRAND
                      ? '工厂'
                      : '品牌'}')
            ],
          ),
        ),
        onPressed: () {
          if (UserBLoC.instance.currentUser.status == UserStatus.OFFLINE) {
            UserBLoC.instance.changeUserType(
                UserBLoC.instance.currentUser.type == UserType.BRAND
                    ? UserType.FACTORY
                    : UserType.BRAND);
            widget.turnToHome?.call();
            return;
          }
          showConfirmDialog(true, message: '切换身份将会退出登录状态，是否确认？', confirm: () {
            UserBLoC.instance.logout().then((val) {
              UserBLoC.instance.changeUserType(
                  UserBLoC.instance.currentUser.type == UserType.BRAND
                      ? UserType.FACTORY
                      : UserType.BRAND);
              widget.turnToHome?.call();
            });
          });
        },
      ),
    );
  }
}

/// 公司认证菜单
class CompanyCertificationMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: B2BImage.certificateInfo(width: 26, height: 19),
            ),
            Expanded(
              child: const Text(
                '我要认证',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: () {
        // 品牌认证
        if (bloc.currentUser.type == UserType.BRAND) {
          UserRepositoryImpl()
              .getBrand(bloc.currentUser.companyCode)
              .then((brand) {
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
      },
    );
  }
}

/// 公司介绍菜单
class CompanyIntroductionMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: B2BImage.companyIntroduce(height: 27, width: 23),
            ),
            Expanded(
              child: const Text(
                '公司介绍',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: () {
        // 品牌详情
        if (bloc.currentUser.type == UserType.BRAND) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyBrandPage(bloc.currentUser.companyCode)));
        }
        // 工厂详情
        if (bloc.currentUser.type == UserType.FACTORY) {
//          UserRepositoryImpl()
//              .getFactory(bloc.currentUser.companyCode)
//              .then((factory) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MyFactoryPage(
                    factoryUid: UserBLoC.instance.currentUser.companyCode,
                  ),
            ),
          );
//          });
        }
      },
    );
  }
}
