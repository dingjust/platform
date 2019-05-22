import 'dart:async';
import 'dart:ui';

import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
import 'package:b2b_commerce/src/business/supplier/company_purchase_list.dart';
import 'package:b2b_commerce/src/business/supplier/company_quote_list.dart';
import 'package:b2b_commerce/src/common/customize_dialog.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:b2b_commerce/src/my/company/my_company_certificate_widget.dart';
import 'package:b2b_commerce/src/my/company/form/my_company_contact_from.dart';
import 'package:b2b_commerce/src/my/company/my_company_contact_from_widget.dart';
import 'package:b2b_commerce/src/my/company/my_factory_base_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './company/form/my_company_profile_form.dart';
import './company/form/my_factory_base_form.dart';
import '../_shared/widgets/image_factory.dart';
import '../business/orders/requirement_order_from.dart';
import '../business/products/existing_product_item.dart';
import '../home/factory/factory_item.dart';
import 'company/my_company_cash_products_widget.dart';
import 'company/my_company_tabbar.dart';
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

class _MyFactoryPageState extends State<MyFactoryPage> with SingleTickerProviderStateMixin {
  RequirementOrderModel orderModel =
      RequirementOrderModel(details: RequirementInfoModel());
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  bool _becomeTab = false;

  List<EnumModel> _states = [
    EnumModel('a', '资料介绍'),
    EnumModel('b', '联系方式'),
    EnumModel('c', '产品物料'),
    EnumModel('d', '公司认证'),
  ];

  List<ApparelProductModel> products = [];
  var _getFactoryFuture;

  @override
  void initState() {
    _getFactoryFuture = _getFactoryData();
    _tabController = TabController(vsync: this, length: _states.length);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _getProductData());
    _scrollController.addListener((){
      if ((_scrollController.position.pixels > 187 && _scrollController.position.pixels < 189) ||
          _scrollController.position.pixels == _scrollController.position.maxScrollExtent
      ) {
        setState((){
          _becomeTab = true;
        });
      }
    });
    super.initState();
  }
  _getFactoryData(){
    if(UserBLoC.instance.currentUser.type == UserType.FACTORY){
      return UserRepositoryImpl()
          .getFactory(UserBLoC.instance.currentUser.companyCode);
    }else{
      return UserRepositoryImpl()
          .getFactory(widget.factory.uid);
    }
  }

  _getProductData(){
    UserBLoC.instance.currentUser.type == UserType.FACTORY
        ? ProductRepositoryImpl().list({
      'approvalStatuses': ['approved'],
    }, {
      'size': 6
    }).then((value) => products = value.content)
        : ProductRepositoryImpl().getProductsOfFactory({
      'approvalStatuses': ['approved'],
    }, {
      'size': 6
    }, widget.factory.uid).then((value) => products = value.content);
  }

  Widget _buildView(String code){
    switch(code){
      case 'a':
        return _buildBaseInfo();
        break;
      case 'b':
        return _buildContactWay();
        break;
      case 'c':
        return _buildCashProducts();
        break;
      case 'd':
        return _buildCompanyCertificate();
        break;
      default:
        return _buildBaseInfo();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return FutureBuilder(
      future: _getFactoryFuture,
      builder:(context,snapshot){
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return NotificationListener(
          onNotification: (TopNotification notification){
            print(notification.isToTop);
            if(notification.isToTop){
              setState(() {
                _becomeTab = false;
                _tabController.animateTo(notification.index);
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('公司介绍'),
              centerTitle: true,
              elevation: 0.5,
              actions: <Widget>[
                Offstage(
                  offstage: widget.isFactoryDetail,
                  child: IconButton(icon: Text('编辑'), onPressed: (){
                    switch(_tabController.index){
                      case 0:
                        return Navigator.push(context, MaterialPageRoute(builder: (context) => MyFactoryBaseFormPage(widget.factory)));
                        break;
                      case 1:
                        return Navigator.push(context, MaterialPageRoute(builder: (context) => MyCompanyContactFromPage(company:widget.factory,isEditing: true,)));
                        break;
                      case 2:
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return CustomizeDialogPage(
                                dialogType: DialogType.RESULT_DIALOG,
                                failTips: '现款产品不可以编辑',
                                callbackResult: false,
                                confirmAction: (){
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                        );
//                  ShowDialogUtil.showSimapleDialog(context, '现款产品不可以编辑');
                        break;
                      case 3:
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return CustomizeDialogPage(
                                dialogType: DialogType.RESULT_DIALOG,
                                failTips: '认证请移步`我的认证`进行认证',
                                callbackResult: false,
                                confirmAction: (){
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                        );
//                  ShowDialogUtil.showSimapleDialog(context, '认证请移步`我的认证`进行认证');
                        break;
                      default :
                        return Navigator.push(context, MaterialPageRoute(builder: (context) => MyCompanyContactFromPage(company:widget.factory,isEditing: true,)));
                        break;
                    }
                  }),
                ),
              ],
            ),
            body: _becomeTab?MyCompanyTabbar(widget.factory,isFactoryDetail: widget.isFactoryDetail,tabIndex: _tabController.index,products:products):Container(
              color: Colors.white,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Offstage(
                      offstage: widget.isFactoryDetail && !widget.factory.profiles.map((profile) => profile.medias.length > 0).toList().contains(true),
                      child: InkWell(
                        onTap: () {
                          if(!widget.isFactoryDetail){
                            showMenu(
                                context: context,
                                items:[
                                  PopupMenuItem(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyCompanyProfileFormPage(
                                                widget.factory
                                            ),
                                          ),
                                        );
                                      },
                                      child: ListTile(
                                        title: Text('更换轮播图'),
                                      ),
                                    ),
                                  ),
                                ],
                                position: RelativeRect.fromLTRB((MediaQueryData.fromWindow(window).size.width-180)/2, 100, (MediaQueryData.fromWindow(window).size.width)/2, (MediaQueryData.fromWindow(window).size.height-60)/2)
                            );
                          }

                        },
                        child: Container(
                          height: 188,
                          child: _buildCarousel(),
                        ),
                      ),
                    ),
                  ),
                  SliverAppBar(
                    expandedHeight: MediaQueryData.fromWindow(window).size.height,
                    leading: Container(),
                    brightness: Brightness.dark,
                    pinned: true,
                    flexibleSpace: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: TabBar(
                        controller: _tabController,
                        labelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorPadding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 10),
                        tabs: _states.map((status) {
                          return Tab(text: status.name);
                        }).toList(),
                        labelStyle: TextStyle( fontSize: 16, color: Colors.black),
                        isScrollable: false,

                      ),
                      body: TabBarView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _tabController,
                        children: _states.map((state) {
                          return _buildView(state.code);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    RequirementOrderModel orderModel = RequirementOrderModel(details: RequirementInfoModel(),attachments: []);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RequirementOrderFrom(
                      order: orderModel,
                      isCreate: true,
                      factoryUid: widget.factory.uid,
                    )));
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //轮播图
  Widget _buildCarousel() {
    List<CompanyProfileModel> profiles = [];
    widget.factory.profiles.forEach((profile){
      if(profile.medias.isNotEmpty){
        profiles.add(profile);
      }
    });
    return CarouselStackText( profiles,);
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
  Widget _buildBaseInfo() {
    return MyFactoryBaseInfo(widget.factory,);
  }

  Widget _buildContactWay(){
    return Container(color:Colors.white,child: MyCompanyContactFromWidgetPage(company: widget.factory,),);
  }

  //现款产品
  Widget _buildCashProducts() {
    return MyCompanyCashProducts(widget.factory,products);
  }

  Widget _buildCompanyCertificate() {
    return Container(
      color: Colors.white,
      child: MyCompanyCertificateWidget(
        widget.factory,
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

class TopNotification extends Notification {
  TopNotification({
    @required this.isToTop,
    @required this.index,
  });
  final int index;
  final bool isToTop;
}
