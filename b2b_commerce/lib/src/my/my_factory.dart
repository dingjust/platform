import 'dart:ui';

import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
import 'package:b2b_commerce/src/business/supplier/company_purchase_list.dart';
import 'package:b2b_commerce/src/business/supplier/company_quote_list.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:b2b_commerce/src/my/company/my_company_certificate_widget.dart';
import 'package:b2b_commerce/src/my/company/my_company_contact_from.dart';
import 'package:b2b_commerce/src/my/company/my_company_contact_from_widget.dart';
import 'package:b2b_commerce/src/my/company/my_company_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './company/form/my_company_profile_form.dart';
import './company/form/my_factory_base_form.dart';
import './company/my_company_certificate.dart';
import '../_shared/widgets/image_factory.dart';
import '../business/orders/requirement_order_from.dart';
import '../business/products/existing_product_item.dart';
import '../home/factory/factory_item.dart';

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

  List<EnumModel> _states = [
    EnumModel('a', '资料介绍'),
    EnumModel('b', '联系方式'),
    EnumModel('c', '产品物料'),
    EnumModel('d', '公司认证'),
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: _states.length);
    super.initState();
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
    List<Widget> _widgets = [
      _buildCarousel(),
      _buildBaseInfo(),
    ];
    if (widget.quoteModel != null) {
      _widgets.add(Column(
        children: <Widget>[
          QuoteListItem(
            model: widget.quoteModel,
            showActions: false,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: GestureDetector(
                child: Text(
                  '查看全部>>',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyQuoteListPage(
                                companyUid: widget.factory.uid,
                              )));
                },
              ),
            ),
          )
        ],
      ));
    }
    if (widget.purchaseOrder != null) {
      _widgets.add(
        Column(
          children: <Widget>[
            PurchaseOrderItem(
              order: widget.purchaseOrder,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: GestureDetector(
                  child: Text(
                    '查看全部>>',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyPurchaseListPage(
                                  companyUid: widget.factory.uid,
                                )));
                  },
                ),
              ),
            )
          ],
        ),
      );
    }
    _widgets.add(_buildCashProducts());
    _widgets.add(_buildFactoryWorkPicInfo());
    _widgets.add(_buildCompanyCertificate());
    _widgets.add(_buildRegisterDate());

    return Scaffold(
      appBar: AppBar(
        title: Text('公司介绍'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(icon: Text('编辑'), onPressed: (){
            switch(_tabController.index){
              case 0:
                return Navigator.push(context, MaterialPageRoute(builder: (context) => MyFactoryBaseFormPage(widget.factory)));
                break;
              case 1:
                return Navigator.push(context, MaterialPageRoute(builder: (context) => MyCompanyContactFromPage(company:widget.factory,isEditing: true,)));
                break;
              case 2:
                ShowDialogUtil.showSimapleDialog(context, '现款产品不可以编辑');
                break;
              case 3:
                ShowDialogUtil.showSimapleDialog(context, '认证请移步`我的认证`进行认证');
                break;
              default :
                return Navigator.push(context, MaterialPageRoute(builder: (context) => MyCompanyContactFromPage(company:widget.factory,isEditing: true,)));
                break;
            }
          }),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
//            SliverAppBar(
////              pinned: true,
//              flexibleSpace: FlexibleSpaceBar(
//                background: Container(
//                  height: 188,
//                  child: GestureDetector(
//                    onTap: () {
//                      showMenu(
//                          context: context,
//                          items:[
//                            PopupMenuItem(
//                              child: GestureDetector(
//                                onTap: (){
//                                  Navigator.pop(context);
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                      builder: (context) => MyCompanyProfileFormPage(
//                                          widget.factory
//                                      ),
//                                    ),
//                                  );
//                                },
//                                child: ListTile(
//                                  title: Text('更换轮播图'),
//                                ),
//                              ),
//                            ),
//                          ],
//                          position: RelativeRect.fromLTRB((MediaQueryData.fromWindow(window).size.width-100)/2, (MediaQueryData.fromWindow(window).size.height-60)/2, (MediaQueryData.fromWindow(window).size.width-100)/2, (MediaQueryData.fromWindow(window).size.height-60)/2)
//                      );
//                    },
//                    child: CarouselStackText(widget.factory.profiles),
//                  ),
//                ),
//              ),
//            ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
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
              },
              child: Container(
                height: 188,
                child: CarouselStackText(widget.factory.profiles),
              ),
            ),
          ),
            SliverAppBar(
              expandedHeight: MediaQueryData.fromWindow(window).size.height - 188,
              leading: Container(),
              brightness: Brightness.dark,
              pinned: true,
              flexibleSpace: Scaffold(
                appBar: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
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
    );
  }

  //轮播图
  Widget _buildCarousel() {
    return CarouselStackText(widget.factory.profiles,);
  }

  // 发布需求按钮
  Widget _buildRequestOrderButton(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        '发布需求',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
                  factoryUid: widget.factory.uid,
                ),
          ),
        );
      },
      backgroundColor: Color.fromRGBO(255, 214, 12, 1),
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
                  ),
            ),
          );
        },
      ),
    );
  }

  //基本资料
  Widget _buildBaseInfo() {
    List<Widget> _buildFactoryHeaderRow = [
      widget.factory.approvalStatus == ArticleApprovalStatus.approved
          ? Tag(
              label: '  已认证  ',
              color: Colors.black,
              backgroundColor: Color.fromRGBO(255, 214, 12, 1),
            )
          : Tag(
              label: '  未认证  ',
              color: Colors.black,
              backgroundColor: Colors.grey[300],
            )
    ];
    widget.factory.labels.forEach((label) {
      return _buildFactoryHeaderRow.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Tag(
            label: label.name,
            color: Color.fromRGBO(255, 133, 148, 1),
          ),
        ),
      );
    });
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(top: 5),
//              child: Offstage(
//                offstage: !widget.isCompanyIntroduction,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    GestureDetector(
//                      child: Container(
//                        padding: const EdgeInsets.symmetric(
//                            horizontal: 15, vertical: 5),
//                        decoration: BoxDecoration(
//                          color: const Color.fromRGBO(255, 214, 12, 1),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        child: const Text('编辑'),
//                      ),
//                      onTap: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  MyFactoryBaseFormPage(widget.factory)),
//                        );
//                      },
//                    )
//                  ],
//                ),
//              ),
//            ),
          Row(
            children: <Widget>[
              ImageFactory.buildThumbnailImage(widget.factory.profilePicture),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.factory.name,
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Stars(
                        starLevel: widget.factory.starLevel ?? 0,
                      ),
                      Container(
                        height: 20,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _buildFactoryHeaderRow,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                const Text('历史接单'),
                Text(
                  '${widget.factory.historyOrdersCount ?? 0}',
                  style: const TextStyle(color: Colors.red),
                ),
                const Text('单')
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '月均产能',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                MonthlyCapacityRangesLocalizedMap[
                        widget.factory.monthlyCapacityRange] ??
                    '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '产值规模',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                "${ScaleRangesLocalizedMap[widget.factory.scaleRange] ?? ''}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '工厂规模',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                PopulationScaleLocalizedMap[widget.factory.populationScale] ??
                    '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '合作方式',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                formatCooperationModesSelectText(
                    widget.factory.cooperationModes),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '生产大类',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                formatCategoriesSelectText(widget.factory.categories, 5),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '优势品类',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: (context),
                      builder: (context) {
                        return SimpleDialog(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 5,
                              ),
                              child: Text(
                                formatCategoriesSelectText(
                                    widget.factory.adeptAtCategories,
                                    widget.factory.adeptAtCategories.length),
                                style: const TextStyle(fontSize: 16),
                              ),
                            )
                          ],
                        );
                      });
                },
                child: Text(
                  formatCategoriesSelectText(
                      widget.factory.adeptAtCategories, 2),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '合作品牌商',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                widget.factory.cooperativeBrand ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContactWay(){
    return Container(color:Colors.white,child: MyCompanyContactFromWidgetPage(company: widget.factory,),);
  }

  //现款产品
  Widget _buildCashProducts() {
    return FutureBuilder(
        future: UserBLoC.instance.currentUser.type == UserType.FACTORY
            ? ProductRepositoryImpl().list({
          'approvalStatuses': ['approved'],
        }, {'size': 3})
            : ProductRepositoryImpl()
                .getProductsOfFactory({
          'approvalStatuses': ['approved'],
        }, {'size': 3}, widget.factory.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    // 加载条
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ProgressIndicatorFactory.buildDefaultProgressIndicator(),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductsPage(
                              factoryUid: widget.factory.uid,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Text(
                            '现款产品',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: const Icon(Icons.chevron_right),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: GridView.count(
                    controller: ScrollController(),
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.5 / 5,
                    children: List.generate(
                      snapshot.data.content.length,
                      (index) {
                        return ExistingProductItem(
                          snapshot.data.content[index],
                          isFactoryDetail: true,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  //图文详情
  Widget _buildFactoryWorkPicInfo() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '图文详情',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Offstage(
                    offstage: !widget.isCompanyIntroduction,
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 214, 12, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text('编辑'),
                      ),
                      onTap: () {
                        if (widget.factory.profiles == null)
                          widget.factory.profiles = [];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyCompanyProfileFormPage(widget.factory),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.factory.profiles.map((profile) {
                    return Column(
                      children: <Widget>[
                        profile.medias != null && profile.medias.length > 0
                            ? Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: CachedNetworkImage(
                                    imageUrl:
                                        '${profile.medias[0].detailUrl()}',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => SpinKitRing(
                                          color: Colors.black12,
                                          lineWidth: 2,
                                          size: 30,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        SpinKitRing(
                                          color: Colors.black12,
                                          lineWidth: 2,
                                          size: 30,
                                        )),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black38, width: 1)),
                              )
                            : Container(),
                        Offstage(
                          offstage: profile.description == null,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${profile.description}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
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

  Card _buildRegisterDate() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text('注册时间'),
        trailing:
            Text(DateFormatUtil.formatYMD(widget.factory.creationTime) ?? ''),
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
