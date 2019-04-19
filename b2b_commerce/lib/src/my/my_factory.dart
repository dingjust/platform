import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
import 'package:b2b_commerce/src/business/supplier/company_purchase_list.dart';
import 'package:b2b_commerce/src/business/supplier/company_quote_list.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './company/form/my_company_profile_form.dart';
import './company/form/my_factory_base_form.dart';
import './company/my_company_certificate.dart';
import './company/my_company_contact_way.dart';
import '../_shared/widgets/image_factory.dart';
import '../business/orders/requirement_order_from.dart';
import '../business/products/existing_product.dart';
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

class _MyFactoryPageState extends State<MyFactoryPage> {
  RequirementOrderModel orderModel =
      RequirementOrderModel(details: RequirementInfoModel());
  Map<PurchaseOrderStatus, MaterialColor> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.IN_PRODUCTION: Colors.yellow,
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [
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
        centerTitle: true,
        title: const Text('公司介绍'),
        elevation: 0.5,
        actions: <Widget>[
          buildContactWay(context),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: _widgets,
        ),
      ),
      floatingActionButton: Offstage(
        child: _buildRequestOrderButton(context),
        offstage: !widget.isFactoryDetail,
      ),
    );
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
              builder: (context) => MyCompanyContactWayPage(
                    widget.factory,
                    isCompanyIntroduction: widget.isCompanyIntroduction,
                  ),
            ),
          );
        },
      ),
    );
  }

  //基本资料
  Card _buildBaseInfo() {
    List<Widget> _buildFactoryHeaderRow = [
      widget.factory.approvalStatus == ArticleApprovalStatus.approved
          ? Tag(
              label: '  已认证  ',
              backgroundColor: Color.fromRGBO(254, 252, 235, 1),
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
            color: Colors.grey,
          ),
        ),
      );
    });

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Offstage(
                offstage: !widget.isCompanyIntroduction,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyFactoryBaseFormPage(widget.factory)),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
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
      ),
    );
  }

  //生产订单
  Widget _buildOrderHeader() {
    return Container(
        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                (widget.purchaseOrder.salesApplication ==
                                SalesApplication.ONLINE &&
                            widget.purchaseOrder.depositPaid == false &&
                            widget.purchaseOrder.status ==
                                PurchaseOrderStatus.PENDING_PAYMENT) ||
                        (widget.purchaseOrder.salesApplication ==
                                SalesApplication.ONLINE &&
                            widget.purchaseOrder.balancePaid == false &&
                            widget.purchaseOrder.status ==
                                PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '￥',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${widget.purchaseOrder.salesApplication == SalesApplication.ONLINE && widget.purchaseOrder.depositPaid == false && widget.purchaseOrder.status == PurchaseOrderStatus.PENDING_PAYMENT ? widget.purchaseOrder.deposit : widget.purchaseOrder.balance}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      )
                    : Container(
                        child: widget.purchaseOrder.delayed
                            ? const Text('已延期',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ))
                            : Container()),
                Expanded(
                  child: Container(
                    child: _buildHeaderText(),
                  ),
                ),
                widget.purchaseOrder.status == null
                    ? Container()
                    : Text(
                        '${PurchaseOrderStatusLocalizedMap[widget.purchaseOrder.status]}',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18,
                          color: _statusColors[widget.purchaseOrder.status],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      '${widget.purchaseOrder.belongTo == null ? widget.purchaseOrder.companyOfSeller : widget.purchaseOrder.belongTo.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Text(
                  '${widget.purchaseOrder.salesApplication == null ? '' : SalesApplicationLocalizedMap[widget.purchaseOrder.salesApplication]}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 16),
                )
              ],
            )
          ],
        ));
  }

  Widget _buildContent() {
    //计算总数
    int sum = 0;
    widget.purchaseOrder.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImage(
              widget.purchaseOrder?.product?.thumbnail),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: widget.purchaseOrder.product == null ||
                            widget.purchaseOrder.product.name == null
                        ? Container()
                        : Text(
                            '${widget.purchaseOrder.product.name}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        '货号：${widget.purchaseOrder.product == null ? '' : widget.purchaseOrder.product.skuID}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                  widget.purchaseOrder.product == null ||
                          widget.purchaseOrder.product.category == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 243, 243, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${widget.purchaseOrder.product.category.name}  $sum件",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 133, 148, 1)),
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
    if (widget.purchaseOrder.salesApplication == SalesApplication.ONLINE &&
        widget.purchaseOrder.depositPaid == false &&
        widget.purchaseOrder.status == PurchaseOrderStatus.PENDING_PAYMENT) {
      return Text(
        '（待付定金）',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (widget.purchaseOrder.salesApplication ==
            SalesApplication.ONLINE &&
        widget.purchaseOrder.balancePaid == false &&
        widget.purchaseOrder.status ==
            PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      return Text(
        '（待付尾款）',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return Container();
    }
  }

  //现款产品
  Card _buildCashProducts() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Column(
            children: <Widget>[
              Container(
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
              Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 2.5 / 5,
                  children: List.generate(
                    widget.products.length,
                    (index) {
                      return ExistingProductItem(
                        widget.products[index],
                        isFactoryDetail: true,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onTap: () async {
          ProductsResponse productsResponse;
          if (UserBLoC.instance.currentUser.type != UserType.BRAND) {
            productsResponse = await ProductRepositoryImpl().list({}, {});
          } else {
            productsResponse = await ProductRepositoryImpl()
                .getProductsOfFactory({}, {}, widget.factory.uid);
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExistingProductsPage(
                    productsResponse.content,
                    isFactoryDetail: true,
                  ),
            ),
          );
        },
      ),
    );
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
                  children: widget.factory.profiles.map((profile) {
                    return Column(
                      children: <Widget>[
                        profile.medias != null && profile.medias.length > 0
                            ? Container(
                                margin: const EdgeInsets.all(5),
                                child: Image.network(
                                  '${profile.medias[0].detailUrl()}',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Container(),
                        Offstage(
                          offstage: profile.description == null,
                          child: Container(
                            margin: EdgeInsets.all(5),
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

  Card _buildCompanyCertificate() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text('公司认证信息'),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyCompanyCertificatePage(
                    widget.factory,
                    onlyRead: true,
                  ),
            ),
          );
        },
      ),
    );
  }

  Card _buildRegisterDate() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text('注册时间'),
        trailing: Text(
            DateFormatUtil.formatYMD(widget.factory.registrationDate) ?? ''),
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
