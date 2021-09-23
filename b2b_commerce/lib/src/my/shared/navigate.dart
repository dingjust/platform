import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/company/form/my_brand_base_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_base_form.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../my_authentication.dart';

class InviteNavigateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (UserBLoC.instance.currentUser.status == UserStatus.ONLINE) {
          Navigator.of(context).pushNamed(AppRoutes.ROUTE_MY_CARD);
        }
      },
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'img/icons/b2b-v2/my/bg_code@3x.png',
                package: 'assets',
              ),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '我的推广码',
              style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              B2BIconsV2.qrcode,
              color: Color(0xFF231815),
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}

///公司介绍
class IntroductionNavigateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        children: [
          _InfoRow(
            title: '工厂介绍',
            info: '让客户快速了解自己',
            onTap: () => onIntroduciton(context),
          ),
          Divider(
            height: 1,
            color: Color(0xFFE7E7E7),
          ),
          _InfoRow(
              title: '平台认证',
              info: '通过认证将获得更多客户关注',
              onTap: () => onAuthentication(context)),
        ],
      ),
    );
  }

  ///介绍
  void onIntroduciton(BuildContext context) {
    UserBLoC bloc = UserBLoC.instance;
    BotToast.showLoading(clickClose: true, crossPage: false);
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
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyFactoryBaseFormPage(
                      value,
                    )));
      });
    }
  }

  ///认证
  void onAuthentication(BuildContext context) {
    UserBLoC bloc = UserBLoC.instance;
    BotToast.showLoading(clickClose: true, crossPage: false);
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
}

class _InfoRow extends StatelessWidget {
  final String title;

  final String info;

  final VoidCallback onTap;

  const _InfoRow({Key key, this.title, this.info, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 56,
              margin: EdgeInsets.only(right: 24),
              child: Text(
                '$title',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
                child: Text(
              '$info',
              style: TextStyle(color: Color(0xFF999999), fontSize: 14),
              overflow: TextOverflow.ellipsis,
            )),
            Icon(
              B2BIconsV2.arrow,
              color: Color(0xFF999999),
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}

class NavigateCard1 extends StatelessWidget {
  final List<_NavigateEnry> entries = [
    _NavigateEnry(
        title: '服务申请',
        route: AppRoutes.ROUTE_SERVICE_APPLY,
        imagePath: 'img/icons/b2b-v2/my/service@3x.png'),
    _NavigateEnry(
        title: '我的收藏',
        route: AppRoutes.ROUTE_MY_FAVORITES,
        imagePath: 'img/icons/b2b-v2/my/collect@3x.png'),
    _NavigateEnry(
        title: '地址管理',
        route: AppRoutes.ROUTE_MY_ADDRESSES,
        imagePath: 'img/icons/b2b-v2/my/add@3x.png'),
    _NavigateEnry(
        title: '我的消息',
        route: AppRoutes.ROUTE_MESSAGE,
        imagePath: 'img/icons/b2b-v2/my/notice@3x.png'),
    _NavigateEnry(
        title: '银行卡',
        route: AppRoutes.ROUTE_BANK_CARD,
        imagePath: 'img/icons/b2b-v2/my/card@3x.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverGroupBuilder(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SliverPadding(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
            crossAxisSpacing: 0,
            childAspectRatio: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _NavigateItem(
                entry: entries[index],
              );
            },
            childCount: entries.length,
          ),
        ),
      ),
    );
  }
}

class NavigateCard2 extends StatelessWidget {
  final List<_NavigateEnry> entries = [
    _NavigateEnry(
        title: '意见反馈',
        route: AppRoutes.ROUTE_FEEDBACK,
        imagePath: 'img/icons/b2b-v2/my/feedback@3x.png'),
    _NavigateEnry(
        title: '帮助中心',
        route: AppRoutes.ROUTE_MY_HELP,
        imagePath: 'img/icons/b2b-v2/my/help@3x.png'),
    _NavigateEnry(
        title: '联系客服',
        route: AppRoutes.ROUTE_MY_CLIENT_SERVICES,
        imagePath: 'img/icons/b2b-v2/my/kefu@3x.png'),
    _NavigateEnry(
        title: '设置',
        route: AppRoutes.ROUTE_MY_SETTINGS,
        imagePath: 'img/icons/b2b-v2/my/set@3x.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverGroupBuilder(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SliverPadding(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
            crossAxisSpacing: 0,
            childAspectRatio: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _NavigateItem(
                entry: entries[index],
              );
            },
            childCount: entries.length,
          ),
        ),
      ),
    );
  }
}

class _NavigateItem extends StatelessWidget {
  final _NavigateEnry entry;

  const _NavigateItem({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (entry.route != null && entry.route != '') {
          Navigator.of(context).pushNamed(entry.route);
        }
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Image.asset(
                entry.imagePath,
                package: entry.package,
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  '${entry.title}',
                  style: TextStyle(fontSize: 12),
                ))
          ],
        ),
      ),
    );
  }
}

class _NavigateEnry {
  final String title;

  final String route;

  final String imagePath;

  final String package;

  _NavigateEnry(
      {this.title, this.route, this.imagePath, this.package = 'assets'});
}
