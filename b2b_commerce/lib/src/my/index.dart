import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/my/company/my_company_certificate.dart';
import 'package:b2b_commerce/src/my/my_brand.dart';
import 'package:b2b_commerce/src/my/my_company_certificate_select.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';

class MyHomePage extends StatelessWidget {
  static const String ROUTE_SETTINGS = '/settings';
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 200.0;

  MyHomePage() : super(key: AppKeys.myHomePage);

  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);
    String companyRoute = '';
    if (bloc.currentUser.type == UserType.BRAND)
      companyRoute = AppRoutes.ROUTE_MY_BRAND;
    if (bloc.currentUser.type == UserType.FACTORY)
      companyRoute = AppRoutes.ROUTE_MY_FACTORY;

    final List<Widget> menus = <Widget>[
      Menu('', <Widget>[
        MenuItem(B2BImage.my_account(width: 23, height: 27), '我的账户',
            AppRoutes.ROUTE_MY_ACCOUNT),
        Container(
          padding: EdgeInsets.fromLTRB(70, 0, 20, 0),
          child: Divider(
            height: 0,
          ),
        ),
        InkWell(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: B2BImage.certicate_info(width: 26, height: 19),
                ),
                Expanded(
                    child: Text(
                      '公司介绍',
                      style: TextStyle(fontSize: 17),
                    )),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          onTap: () {
            //品牌详情
            if (bloc.currentUser.type == UserType.BRAND){
              UserRepositoryImpl().getBrand(UserBLoC.instance.currentUser.companyCode).then((brand){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBrandPage(brand)));
              });
            }
            //工厂详情
            if (bloc.currentUser.type == UserType.FACTORY) {
              UserRepositoryImpl().getFactory(UserBLoC.instance.currentUser.companyCode).then((factory){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyFactoryPage(factory,isCompanyIntroduction: true,)));
              });
            }
          },
        ),
        Container(
          padding: EdgeInsets.fromLTRB(70, 0, 20, 0),
          child: Divider(
            height: 0,
          ),
        ),
        InkWell(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: B2BImage.certicate_info(width: 26, height: 19),
                ),
                Expanded(
                    child: Text(
                  '我要认证',
                  style: TextStyle(fontSize: 17),
                )),
//                Text(
//                  '未认证',
//                  style: TextStyle(
//                    color: Color.fromRGBO(255, 214, 12, 1),
//                  ),
//                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          onTap: () {
            //品牌认证
            if (bloc.currentUser.type == UserType.BRAND){
              UserRepositoryImpl().getBrand(UserBLoC.instance.currentUser.companyCode).then((brand){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyCompanyCertificateSelectPage(brand)));
              });
            }
            //工厂认证
            if (bloc.currentUser.type == UserType.FACTORY) {
              UserRepositoryImpl().getFactory(UserBLoC.instance.currentUser.companyCode).then((factory){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyCompanyCertificateSelectPage(factory)));
              });
            }
          },
        )
      ]),
      Menu('', <Widget>[
        MenuItem(B2BImage.address_manage(width: 24, height: 29), '地址管理',
            AppRoutes.ROUTE_MY_ADDRESSES),
        Container(
          padding: EdgeInsets.fromLTRB(70, 0, 20, 0),
          child: Divider(
            height: 0,
          ),
        ),
        MenuItem(B2BImage.invoice_manage(width: 26, height: 21), '发票管理',
            AppRoutes.ROUTE_MY_INVOICES),
//        MenuItem(Icons.shopping_cart, '购物车', AppRoutes.ROUTE_MY_CART),
      ]),
//      Menu('', <MenuItem>[
//
////        MenuItem(Icons.collections, '我的收藏', AppRoutes.ROUTE_MY_COLLECTIONS),
//      ]),
      Menu('', <Widget>[
        MenuItem(B2BImage.customer_service(width: 25, height: 25), '联系客服',
            AppRoutes.ROUTE_MY_CLIENT_SERVICES),
        Container(
          padding: EdgeInsets.fromLTRB(70, 0, 20, 0),
          child: Divider(
            height: 0,
          ),
        ),
        MenuItem(B2BImage.setting(width: 25, height: 24), '设置',
            AppRoutes.ROUTE_MY_SETTINGS),
      ]),
//      Menu('', <MenuItem>[
//
//      ]),
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
//                IconButton(
//                  icon: const Icon(Icons.menu),
//                  tooltip: 'Edit',
//                  color: Colors.white,
//                  onPressed: () {
//                    // http test
//                    http$.get('/apparel-zh/users/13234', context: context).then((response) {});
////                    _scaffoldKey.currentState.showSnackBar(
////                      const SnackBar(
////                        content: Text('Editing isn\'t supported in this screen.'),
////                      ),
////                    );
//                  },
//                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                key: const Key('__myHomeSpaceBar__'),
                title: StreamBuilder<UserModel>(
                  stream: bloc.stream,
                  initialData: bloc.currentUser,
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel> snapshot) {
                    debugPrint('${snapshot.data.type}');
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${snapshot.data.name}',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    );
                  },
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildTopBackgroud(context,UserBLoC.instance.currentUser),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(menus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBackgroud(BuildContext context,UserModel user) {
    return Container(
//      constraints: BoxConstraints.expand(width: 300.0, height: 300.0,),
      child: Row(
        children: <Widget>[
          _buildPortrait(context,user),
          _buildInfomation(context,user),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 219, 0, 1),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context,UserModel user) {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
      child: Container(
          child: user.profilePicture != null ?
          CircleAvatar(
            backgroundImage: NetworkImage(
              user.profilePicture.url,
            ),
            radius: 40.0,
          ):CircleAvatar(
            child: Icon(B2BIcons.noPicture),
            radius: 40.0,
          ),
          decoration: BoxDecoration(
            border: new Border.all(color: Colors.white, width: 0.5),
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular((50.0)),
          )),
    );
  }

  Widget _buildInfomation(BuildContext context,UserModel user) {
    return Container(
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 210,
            child: Row(
              children: <Widget>[
                Container(
                    child: Text(
                  "${user.name}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(36, 38, 41, 1)),
                )),
//                Container(
//                  padding: EdgeInsets.all(3),
//                  margin: EdgeInsets.only(left: 10),
//                  child: Text(
//                    '采购员',
//                    style: TextStyle(
//                        fontSize: 16,
//                        fontWeight: FontWeight.w500,
//                        color: Color.fromRGBO(255, 214, 12, 1)),
//                  ),
//                  decoration: BoxDecoration(
//                    color: Color.fromRGBO(36, 38, 41, 1),
//                    borderRadius: BorderRadius.circular(12),
//                  ),
//                )
              ],
            ),
          ),
          Container(
            width: 210,
            child: Text(
              '${UserBLoC.instance.currentUser.companyName}',
              style: TextStyle(
                  fontSize: 16, color: Color.fromRGBO(132, 114, 1, 1)),
            ),
          )
        ],
      ),
    );
  }
}
