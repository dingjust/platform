import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/image_factory.dart';
import '../common/app_keys.dart';
import '../common/app_routes.dart';
import 'account/profile.dart';
import 'shared/navigate.dart';

/// 我的
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

  MyHomePage() : super(key: AppKeys.myHomePage);
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    ///极光初始化
    jpush$.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          color: Color(0xffF7F7F7),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: CustomScrollView(
            slivers: [
              _buildHeader(),
              SliverToBoxAdapter(
                child: InviteNavigateCard(),
              ),
              SliverToBoxAdapter(
                child: IntroductionNavigateCard(),
              ),
              NavigateCard1(),
              NavigateCard2()
            ],
          )),
    );
  }

  ///头部
  Widget _buildHeader() {
    UserModel user = UserBLoC.instance.currentUser;
    return SliverAppBar(
      expandedHeight: 124,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        key: AppKeys.myHomeSpaceBar,
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (user.status != UserStatus.ONLINE) {
                  Navigator.of(context).push((MaterialPageRoute(
                      builder: (context) => B2BLoginPage())));
                } else {
                  Navigator.of(context)
                      .push((MaterialPageRoute(
                      builder: (context) => ProfilePage())))
                      .then((val) {
                    //修改资料后刷新
                    setState(() {});
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 60),
                child: Row(
                  children: <Widget>[
                    _buildPortrait(user),
                    Expanded(
                      child: _buildInformation(context, user),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'img/icons/b2b-v2/my/bg@3x.png',
                        package: 'assets',
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///头像
  Widget _buildPortrait(UserModel user) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 16, 0),
        height: 64,
        child:
        ImageFactory.buildDefaultAvatar(user.profilePicture, radius: 32));
  }

  ///昵称
  Widget _buildInformation(BuildContext context, UserModel user) {
    if (user.status == UserStatus.ONLINE) {
      return Container(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${user.name}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildSwitchBtn(context),
              ],
            ),
            Row(
              children: [
                Text(
                  '编辑个人信息',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Icon(
                  B2BIconsV2.arrow,
                  color: Color(0xFF231815),
                  size: 18,
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

  ///切换账号
  Widget _buildSwitchBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.ROUTE_SWITCH_ACCOUNT);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Color(0xFFFED800), borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 4),
              child: Icon(
                B2BIconsV2.user_switch,
                size: 14,
              ),
            ),
            Text(
              '切换账号',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}