import 'dart:ui';

import 'package:b2b_commerce/src/my/company/form/my_company_contact_from.dart';
import 'package:b2b_commerce/src/my/company/my_company_certificate_widget.dart';
import 'package:b2b_commerce/src/my/company/my_company_contact_from_widget.dart';
import 'package:b2b_commerce/src/my/company/my_factory_base_info.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './company/form/my_company_profile_form.dart';
import './company/form/my_factory_base_form.dart';
import '../business/orders/requirement_order_from.dart';
import 'company/form/my_factory_form.dart';
import 'company/my_company_cash_products_widget.dart';
import 'company/my_company_tabbar_widget.dart';

/// 认证信息
class MyFactoryPage extends StatefulWidget {
  FactoryModel factory;
  List<ApparelProductModel> products;
  PurchaseOrderModel purchaseOrder;
  QuoteModel quoteModel;
  bool isCompanyIntroduction;
  bool isFactoryDetail;

  MyFactoryPage(
    this.factory, {
    this.products,
    this.purchaseOrder,
    this.quoteModel,
    this.isCompanyIntroduction = false,
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
    EnumModel('b', '联系方式'),
    EnumModel('c', '产品物料'),
    EnumModel('d', '公司认证'),
  ];

  GlobalKey _factoryKey = GlobalKey();
  var _getFactoryFuture;
  List<CompanyProfileModel> _profiles = [];


  @override
  void initState() {
    _getFactoryFuture = _getFactoryData();
    _tabController = TabController(vsync: this, length: _states.length);
    super.initState();
  }

  //获取工厂数据
  _getFactoryData() {
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return UserRepositoryImpl()
          .getFactory(UserBLoC.instance.currentUser.companyCode);
    } else {
      return UserRepositoryImpl().getFactory(widget.factory.uid);
    }
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
          }, widget.factory.uid);
  }

  Widget _buildView(String code,FactoryModel factory) {
    switch (code) {
      case 'a':
        return _buildBaseInfo(factory);
        break;
      case 'b':
        return _buildContactWay(factory);
        break;
      case 'c':
        return _buildCashProducts(factory);
        break;
      case 'd':
        return _buildCompanyCertificate(factory);
        break;
      default:
        return _buildBaseInfo(factory);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _profiles = widget.factory.profiles.where((profile) {
      return profile.medias.isNotEmpty;
    }).toList();
//    List<Widget> _widgets = [
//      _buildCarousel(),
//      _buildBaseInfo(),
//    ];
//    if (widget.quoteModel != null) {
//      _widgets.add(Column(
//        children: <Widget>[
//          QuoteListItem(
//            model: widget.quoteModel,
//            showActions: false,
//          ),
//          Container(
//            color: Colors.white,
//            padding: const EdgeInsets.only(bottom: 10),
//            child: Center(
//              child: GestureDetector(
//                child: Text(
//                  '查看全部>>',
//                  style: TextStyle(
//                    color: Colors.red,
//                    fontSize: 18,
//                  ),
//                ),
//                onTap: () async {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => CompanyQuoteListPage(
//                                companyUid: widget.factory.uid,
//                              )));
//                },
//              ),
//            ),
//          )
//        ],
//      ));
//    }
//    if (widget.purchaseOrder != null) {
//      _widgets.add(
//        Column(
//          children: <Widget>[
//            PurchaseOrderItem(
//              order: widget.purchaseOrder,
//            ),
//            Container(
//              color: Colors.white,
//              padding: const EdgeInsets.only(bottom: 10),
//              child: Center(
//                child: GestureDetector(
//                  child: Text(
//                    '查看全部>>',
//                    style: TextStyle(
//                      color: Colors.red,
//                      fontSize: 18,
//                    ),
//                  ),
//                  onTap: () async {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => CompanyPurchaseListPage(
//                                  companyUid: widget.factory.uid,
//                                )));
//                  },
//                ),
//              ),
//            )
//          ],
//        ),
//      );
//    }
//    _widgets.add(_buildCashProducts());
//    _widgets.add(_buildFactoryWorkPicInfo());
//    _widgets.add(_buildCompanyCertificate());
//    _widgets.add(_buildRegisterDate());

    return Scaffold(
      appBar: AppBar(
        title: Text('公司介绍'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          Offstage(
            offstage: widget.isFactoryDetail,
            child: IconButton(
                icon: Text('编辑'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyFactoryFormPage(factory: widget.factory,))).then((v){
                    setState(() {
                      _getFactoryFuture = _getFactoryData();
                    });
                  });
//                  switch (_tabController.index) {
//                    case 0:
//                      return Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  MyFactoryBaseFormPage(widget.factory)));
//                      break;
//                    case 1:
//                      return Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => MyCompanyContactFromPage(
//                                    company: widget.factory,
//                                    isEditing: true,
//                                  )));
//                      break;
//                    case 2:
//                      showDialog(
//                          context: context,
//                          barrierDismissible: false,
//                          builder: (_) {
//                            return CustomizeDialog(
//                              dialogType: DialogType.RESULT_DIALOG,
//                              failTips: '现款产品不可以编辑',
//                              callbackResult: false,
//                              confirmAction: () {
//                                Navigator.of(context).pop();
//                              },
//                            );
//                          });
////                  ShowDialogUtil.showSimapleDialog(context, '现款产品不可以编辑');
//                      break;
//                    case 3:
//                      showDialog(
//                          context: context,
//                          barrierDismissible: false,
//                          builder: (_) {
//                            return CustomizeDialog(
//                              dialogType: DialogType.RESULT_DIALOG,
//                              failTips: '认证请移步`我要认证`进行认证',
//                              callbackResult: false,
//                              confirmAction: () {
//                                Navigator.of(context).pop();
//                              },
//                            );
//                          });
////                  ShowDialogUtil.showSimapleDialog(context, '认证请移步`我的认证`进行认证');
//                      break;
//                    default:
//                      return Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => MyCompanyContactFromPage(
//                                    company: widget.factory,
//                                    isEditing: true,
//                                  )));
//                      break;
//                  }
                }),
          ),
        ],
      ),
      body: FutureBuilder<FactoryModel>(
          future: _getFactoryFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 200),
                child: Center(child: CircularProgressIndicator()),
              );
            }else{
              return Container(
                color: Colors.white,
                child: NestedScrollView(
                  headerSliverBuilder: _sliverBuilder,
                  body: TabBarView(
                    controller: _tabController,
                    children: _states.map((state) {
                      return _buildView(state.code,snapshot.data);
                    }).toList(),
                  ),
                ),
              );
            }
          }),
      bottomNavigationBar: Offstage(
        offstage: !widget.isFactoryDetail,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '发需求',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () {
              RequirementOrderModel orderModel = RequirementOrderModel(
                  details: RequirementInfoModel(), attachments: []);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequirementOrderFrom(
                            order: orderModel,
                            isCreate: true,
                            factoryUid: widget.factory.uid,
                          )));
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        backgroundColor: Color.fromRGBO(232, 232, 232, 1),
        expandedHeight: widget.isFactoryDetail && _profiles.length <= 0 ? 0 :188,
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
                                  MyCompanyProfileFormPage(widget.factory),
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
                      (MediaQueryData.fromWindow(window).size.width - 180) /
                          2,
                      100,
                      (MediaQueryData.fromWindow(window).size.width) / 2,
                      (MediaQueryData.fromWindow(window).size.height - 60) /
                          2));
            }
          },
          child: Container(
            height: 188,
            child: _profiles.isEmpty ? Center(child: Stack(
              children: <Widget>[
                Text(widget.isFactoryDetail ? '该工厂无轮播图' : '点击此处，添加或更换轮播图',style: TextStyle(fontSize: 17,color: Colors.grey[700]),),
              ],
            ),) : _buildCarousel(),
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
              builder: (context) => MyCompanyContactFromPage(
                    company: widget.factory,
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
    return MyFactoryBaseInfo(
      factory,
    );
  }

  Widget _buildContactWay(FactoryModel factory) {
    return Container(
      color: Colors.white,
      child: MyCompanyContactFromWidgetPage(
        company: factory,
      ),
    );
  }

  //现款产品
  Widget _buildCashProducts(FactoryModel factory) {
    return MyCompanyCashProducts(factory,getProductsFuture: _getProductData(),);
  }

  Widget _buildCompanyCertificate(FactoryModel factory) {
    return Container(
      color: Colors.white,
      child: MyCompanyCertificateWidget(
        factory,
        onlyRead: true,
      ),
    );
  }

  //格式化类别
  String formatCategoriesSelectText(List<CategoryModel> categories, int count) {
    String text = '';

    if (categories != null) {
      text = '';
      for (int i = 0; i < categories.length; i++) {
        if (i > count - 1) {
          text += '...';
          break;
        }

        if (i == categories.length - 1) {
          text += categories[i].name;
        } else {
          text += categories[i].name + '、';
        }
      }
    }

    return text;
  }

  //格式化标签
  String formatLabelsSelectText(List<LabelModel> labels) {
    String text = '';

    if (labels != null) {
      text = '';
      for (int i = 0; i < labels.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == labels.length - 1) {
          text += labels[i].name;
        } else {
          text += labels[i].name + '、';
        }
      }
    }

    return text;
  }

  //格式化合作方式
  String formatCooperationModesSelectText(
      List<CooperationModes> cooperationModes) {
    String text = '';

    if (cooperationModes != null) {
      text = '';
      for (int i = 0; i < cooperationModes.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == cooperationModes.length - 1) {
          text += CooperationModesLocalizedMap[cooperationModes[i]];
        } else {
          text += CooperationModesLocalizedMap[cooperationModes[i]] + '、';
        }
      }
    }

    return text;
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

class RefreshNotification extends ScrollNotification{
  bool refresh;
  RefreshNotification(this.refresh);
}
