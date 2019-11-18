import 'dart:async';
import 'dart:ui';

import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/my/company/my_company_certificate_widget.dart';
import 'package:b2b_commerce/src/my/company/my_company_contact_from_widget.dart';
import 'package:b2b_commerce/src/my/company/my_factory_base_info.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import './company/form/my_company_profile_form.dart';
import '../business/orders/requirement_order_from.dart';
import 'company/_shared/cash_products.dart';
import 'company/form/my_factory_contact_form.dart';
import 'company/form/my_factory_form.dart';
import 'company/info/my_company_certificate_info.dart';
import 'company/info/my_company_contact_info.dart';
import 'company/my_company_cash_products_widget.dart';

/// 认证信息
class MyFactoryPage extends StatefulWidget {
  String factoryUid;
  List<ApparelProductModel> products;
  bool isSupplier;
  bool isFactoryDetail;

  MyFactoryPage({
    this.factoryUid,
    this.products,
    this.isSupplier = false,
    this.isFactoryDetail = false,
  });

  _MyFactoryPageState createState() => _MyFactoryPageState();
}

class _MyFactoryPageState extends State<MyFactoryPage>
    with SingleTickerProviderStateMixin {
  RequirementOrderModel orderModel =
      RequirementOrderModel(details: RequirementInfoModel());
  TabController _tabController;

  List<EnumModel> _states = [
    EnumModel('a', '资料介绍'),
    EnumModel('b', '公司认证'),
    EnumModel('c', '上架产品'),
    EnumModel('d', '联系方式'),
  ];

  FactoryModel _factory;
  Future<FactoryModel> _getFactoryFuture;
  List<CompanyProfileModel> _profiles = [];
  StreamController<bool> _showEidtIconStreamController = StreamController();

  @override
  void dispose() {
    super.dispose();
    _showEidtIconStreamController.close();
  }

  @override
  void initState() {
    _getFactoryFuture = _getFactoryData();
    _tabController = TabController(vsync: this, length: _states.length);
    super.initState();
  }

  //获取工厂数据
  _getFactoryData() {
    return UserRepositoryImpl().getFactory(widget.factoryUid).then((v) {
      _showEidtIconStreamController.sink.add(true);
      return _factory = v;
    });
  }

  //获取工厂现款产品数据
  _getProductData() {
    return UserBLoC.instance.currentUser.type == UserType.FACTORY
        ? ProductRepositoryImpl().list({
            'approvalStatuses': ['approved'],
          }, {
            'size': 6
          })
        : ProductRepositoryImpl().getProductsOfFactory({
            'approvalStatuses': ['approved'],
          }, {
            'size': 6
          }, widget.factoryUid);
  }

  Widget _buildView(String code, FactoryModel factory) {
    switch (code) {
      case 'a':
        return _buildBaseInfo(factory);
        break;
      case 'b':
        return _buildCompanyCertificate(factory);
        break;
      case 'c':
        return _buildCashProducts(factory);
        break;
      case 'd':
        return _buildContactWay(factory);
        break;
      default:
        return _buildBaseInfo(factory);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            builder: (_) => MyFactoryState(factoryUid: widget.factoryUid)),
        ChangeNotifierProvider(
            builder: (_) => CashProductsState(factoryUid: widget.factoryUid)),
        ChangeNotifierProvider(builder: (_) => MyFactoryCapacityState()),
      ],
      child: Consumer<MyFactoryState>(
        builder: (context, MyFactoryState factoryState, _) {
          _factory = factoryState.model;
          return Scaffold(
            appBar: AppBar(
              title: Text('公司介绍'),
              centerTitle: true,
              elevation: 0.5,
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: (v) => onMenuSelect(v, factoryState),
                  padding: EdgeInsets.only(right: 10),
                  icon: Icon(
                    B2BIcons.more,
                    size: 5,
                  ),
                  offset: Offset(0, 50),
                  itemBuilder: (BuildContext context) => widget.isFactoryDetail
                      ? <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'share',
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Icon(Icons.share),
                                ),
                                Text('分享')
                              ],
                            ),
                          ),
                        ]
                      : <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Icon(Icons.edit),
                                ),
                                Text('编辑')
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'share',
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Icon(Icons.share),
                                ),
                                Text('分享')
                              ],
                            ),
                          ),
                        ],
                ),
              ],
            ),
            body: factoryState.model != null
                ? _buildBody(factoryState.model)
                : Center(
                    child: CircularProgressIndicator(),
                  ),
//          FutureBuilder<FactoryModel>(
//              future: _getFactoryFuture,
//              builder: (context, snapshot) {
//                if (!snapshot.hasData) {
//                  return Padding(
//                    padding: EdgeInsets.symmetric(vertical: 200),
//                    child: Center(child: CircularProgressIndicator()),
//                  );
//                } else {
//                  _profiles = _factory.profiles.where((profile) {
//                    return profile.medias.isNotEmpty;
//                  }).toList();
//                  return Container(
//                    color: Colors.grey[100],
//                    child: NestedScrollView(
//                      headerSliverBuilder: _sliverBuilder,
//                      body: TabBarView(
//                        controller: _tabController,
//                        children: _states.map((state) {
//                          return _buildView(state.code, snapshot.data);
//                        }).toList(),
//                      ),
//                    ),
//                  );
//                }
//              }),
            bottomNavigationBar: Offstage(
              offstage: !widget.isFactoryDetail,
              child: _buildBottomButtons(factoryState.model),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(FactoryModel model) {
    _profiles = model.profiles.where((profile) {
      return profile.medias.isNotEmpty;
    }).toList();
    return Container(
      color: Colors.grey[100],
      child: NestedScrollView(
        headerSliverBuilder: _sliverBuilder,
        body: TabBarView(
          controller: _tabController,
          children: _states.map((state) {
            return _buildView(state.code, model);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(FactoryModel model) {
    return Container(
      height: 65,
      child: Column(
        children: <Widget>[
          Divider(
            height: 0,
          ),
          Container(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.all(2),
                            ),
                            Text(model?.contactPerson ?? ''),
                          ],
                        ),
                        onPressed: () {
                          _selectActionButton(model.contactPhone);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: double.infinity,
                            child: Theme(
                                data: ThemeData(
                                  canvasColor: Colors.transparent,
                                  primaryColor: Colors.white,
                                  accentColor: Color.fromRGBO(255, 214, 12, 1),
                                  bottomAppBarColor: Colors.grey,
                                ),
                                child: Builder(
                                  builder: (BuildContext buttonContext) =>
                                      FlatButton(
                                    color: Color.fromRGBO(255, 245, 157, 1),
                                    onPressed: () {},
                                    disabledColor: Colors.grey[300],
                                    child: Text(
                                      '下单',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: double.infinity,
                            child: Builder(
                              builder: (BuildContext buttonContext) =>
                                  FlatButton(
                                color: Color.fromRGBO(255, 214, 12, 1),
                                onPressed: () {
                                  _publishRequirement();
                                },
                                disabledColor: Colors.grey[300],
                                child: Text(
                                  '发需求',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _publishRequirement() {
    RequirementOrderModel orderModel =
        RequirementOrderModel(details: RequirementInfoModel(), attachments: []);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
                  order: orderModel,
                  isCreate: true,
                  factoryUid: widget.factoryUid,
                )));
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        backgroundColor: Color.fromRGBO(232, 232, 232, 1),
        expandedHeight:
            widget.isFactoryDetail && _profiles.length <= 0 ? 0 : 188,
        leading: Container(),
        brightness: Brightness.dark,
        pinned: false,
        flexibleSpace: InkWell(
          onTap: () {
            if (!widget.isFactoryDetail) {
              showMenu(
                  context: context,
                  items: [
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyCompanyProfileFormPage(_factory),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text('更换轮播图'),
                        ),
                      ),
                    ),
                  ],
                  position: RelativeRect.fromLTRB(
                      (MediaQueryData.fromWindow(window).size.width - 180) / 2,
                      100,
                      (MediaQueryData.fromWindow(window).size.width) / 2,
                      (MediaQueryData.fromWindow(window).size.height - 60) /
                          2));
            }
          },
          child: Container(
            height: 188,
            child: _profiles.isEmpty
                ? Center(
                    child: Stack(
                      children: <Widget>[
                        Text(
                          widget.isFactoryDetail ? '该工厂无轮播图' : '点击此处，添加或更换轮播图',
                          style:
                              TextStyle(fontSize: 17, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  )
                : _buildCarousel(),
          ),
        ),
      ),
      SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding:
                  EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
              tabs: _states.map((status) {
                return Tab(text: status.name);
              }).toList(),
              labelStyle: TextStyle(fontSize: 16, color: Colors.black),
              isScrollable: false,
            ),
          )),
    ];
  }

  //轮播图
  Widget _buildCarousel() {
    return CarouselStackText(
      _profiles,
    );
  }

  //联系方式
  Container buildContactWay(BuildContext context) {
    return Container(
      width: 80,
      child: IconButton(
        icon: Text(
          '联系方式',
          style: TextStyle(),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyFactoryContactFormPage(
                company: _factory,
                isEditing: true,
              ),
            ),
          );
        },
      ),
    );
  }

  //基本资料
  Widget _buildBaseInfo(FactoryModel factory) {
    return MyFactoryBaseInfo(factory, isSupplier: widget.isSupplier);
  }

  Widget _buildContactWay(FactoryModel factory) {
    return Container(
      child: MyCompanyContactInfo(factory),
    );
  }

  //现款产品
  Widget _buildCashProducts(FactoryModel factory) {
    return CashProducts();
  }

  Widget _buildCompanyCertificate(FactoryModel factory) {
    return MyCompanyCertificateInfo(
      factory,
      onlyRead: true,
    );
  }

  onMenuSelect(String value, MyFactoryState state) async {
    switch (value) {
      case 'edit':
        onEdit(state);
        break;
      case 'share':
        onShare(state);
        break;
      default:
    }
  }

  void onEdit(MyFactoryState state) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyFactoryFormPage(
                  factory: state.model,
                ))).then((v) {
      state.refresh();
    });
  }

  ///TODO分享
  void onShare(MyFactoryState state) {
    String description = "";
    int i = 0;

    state.model.adeptAtCategories.forEach((v) {
      if (i < 4) {
        description = "${description} ${v.name}";
        i++;
      }
    });

    ShareDialog.showShareDialog(context,
        title: '${state.model.name}',
        description: '$description ...',
        imageUrl: state.model.profilePicture == null
            ? '${GlobalConfigs.LOGO_URL}'
            : '${state.model.profilePicture.previewUrl()}',
        url: Apis.shareFactory(widget.factoryUid));
  }

  //拨打电话或发短信
  void _selectActionButton(String tel) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
                    leading: Icon(Icons.message),
                    title: Text('发送短信'),
                    onTap: () async {
                      var url = 'sms:' + tel;
                      await launch(url);
                    },
                  ),
          ],
        );
      },
    );
  }
}

//到顶的回调监听
class TopNotification extends Notification {
  TopNotification({
    @required this.isToTop,
    @required this.index,
  });

  final int index;
  final bool isToTop;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 10;

  @override
  double get maxExtent => _tabBar.preferredSize.height + 10;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: _tabBar,
        ),
        SizedBox(
          height: 10,
          child: Container(
            color: Colors.grey[Constants.SIZEDBOX_COLOR],
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class RefreshNotification extends ScrollNotification {
  bool refresh;

  RefreshNotification(this.refresh);
}
