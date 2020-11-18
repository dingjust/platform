import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:b2b_commerce/src/business/purchase_orders.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/logistics_input_page.dart';
import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:b2b_commerce/src/production/production_generate_unique_code.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import 'form/purchase/purchase_deliver_order_view.dart';
import 'form/purchase/purchase_detail_btn_group.dart';
import 'form/purchase/purchase_reconciliation_order_view.dart';
import 'form/purchase/purchase_shipping_order_view.dart';

final List<OrderStatusModel> _statusList = [
  OrderStatusModel.fromJson({
    'code': 'PENDING_PAYMENT',
    'name': '待付款',
    'sort': 1,
  }),
  OrderStatusModel.fromJson({
    'code': 'IN_PRODUCTION',
    'name': '生产中',
    'sort': 2,
  }),
  OrderStatusModel.fromJson({
    'code': 'WAIT_FOR_OUT_OF_STORE',
    'name': '待出库',
    'sort': 3,
  }),
  OrderStatusModel.fromJson({
    'code': 'OUT_OF_STORE',
    'name': '已出库',
    'sort': 4,
  }),
  OrderStatusModel.fromJson({
    'code': 'COMPLETED',
    'name': '已完成',
    'sort': 5,
  }),
  OrderStatusModel.fromJson({
    'code': 'CANCELLED',
    'name': '已取消',
    'sort': 6,
  }),
];

class PurchaseOrderDetailPage extends StatefulWidget {
  final PurchaseOrderModel model;

  final String code;

  final bool isProduction;

  PurchaseOrderDetailPage({
    Key key,
    @required this.code,
    this.isProduction = false,
    this.model,
  }) : super(key: key);

  _PurchaseDetailPageState createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<PurchaseOrderDetailPage> {
  TextEditingController dialogText;
  FocusNode _dialogFocusNode;
  List<ApparelSizeVariantProductEntry> mockData = new List();
  DateTime _blDate;
  bool isShowButton = false;
  String userType;
  String _blNumber;
  String remarks;
  bool isHide = true;
  int totalQuantity = 0;
  SalesApplication salesApplication;
  var _futureBuilderFuture;

  PurchaseOrderModel order;
  _PurchaseDetailPageState({this.order});

  B2BFloatingActionButtonLocation fabLocation =
  B2BFloatingActionButtonLocation(0.125);

  @override
  void initState() {
    _futureBuilderFuture = _getData();
    super.initState();
  }

  static Map<PurchaseOrderStatus, Color> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.IN_PRODUCTION: Color(0xFFFFD600),
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    final bloc = BLoCProvider.of<UserBLoC>(context);
    return FutureBuilder<PurchaseOrderModel>(
      builder:
          (BuildContext context, AsyncSnapshot<PurchaseOrderModel> snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            body: Container(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    pinned: true,
                    elevation: 0.5,
                    centerTitle: true,
                    title: Text('生产订单明细'),
                    actions: <Widget>[
//                      IconButton(
//                        iconSize: 4,
//                        icon: Icon(B2BIcons.more),
//                        onPressed: () {},
//                      )
                    ],
                    brightness: Brightness.dark,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 100, 20, 10),
                            decoration: const BoxDecoration(
                              color: const Color.fromRGBO(255, 219, 0, 1),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 2000,
                              height: 60,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            child: _buildEntries(context),
                            padding: EdgeInsets.fromLTRB(20, 100, 20, 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          _buildProductInfo(context),
                          (order.status ==
                              PurchaseOrderStatus.PENDING_PAYMENT &&
                              order.depositPaid == false) ||
                              order.status == PurchaseOrderStatus.CANCELLED
                              ? _buildTipsPayment(context)
                              : _buildPurchaseProductionProgresse(context),
                          _buildDeliveryAddress(context),
                          bloc.isBrandUser
                              ? _buildFactoryInfo(context)
                              : _buildBrandInfo(context),
                          _buildDocutment(context),
                          _buildRemarks(context),
                          _buildContracts(context),
                          _buildFinance(context),
//                          _buildLog(context),
                          _buildBottom(context),
                          _buildCommitButton(context),
                        ],
                      )),
                ],
              ),
            ),
            bottomSheet: _bubildBottomSheet(),
            floatingActionButton: _buildFAB(context),
            floatingActionButtonLocation: fabLocation,
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      initialData: null,
      future: _futureBuilderFuture,
    );
  }

  Future<PurchaseOrderModel> _getData() async {
    // 查询明细
    PurchaseOrderModel detailModel =
    await PurchaseOrderBLoC().getPurchaseOrderDetail(widget.code);
    order = detailModel;
    if (order != null) {
      initData(order);
    }
    return detailModel;
  }

  initData(PurchaseOrderModel order) {
    setState(() {
      print(order.code);
      mockData.clear();
      //把颜色尺码封装成ApparelSizeVariantProductEntry
      if (order.entries.isNotEmpty) {
        for (int i = 0; i < order.entries.length; i++) {
          if (order.entries[i].product.color != null &&
              order.entries[i].product.size != null) {
            ApparelSizeVariantProductEntry entry =
            new ApparelSizeVariantProductEntry();
            entry.quantity = order.entries[i].quantity;
            totalQuantity += order.entries[i].quantity;
            entry.model = order.entries[i].product;
            mockData.add(entry);
          }
        }
      }
      //控制是否显示按钮
      if (order.status == PurchaseOrderStatus.PENDING_PAYMENT ||
          (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE &&
              order.balancePaid == false)) {
        isShowButton = true;
      }

      if (order.status == PurchaseOrderStatus.PENDING_PAYMENT &&
          order.salesApplication == SalesApplication.ONLINE) {
        isHide = false;
      }

      final bloc = BLoCProvider.of<UserBLoC>(context);
      if (bloc.isBrandUser) {
        userType = 'brand';
      } else {
        userType = 'factory';
      }
      salesApplication = order.salesApplication;
    });
  }

  //产品详情
  Widget _buildEntries(BuildContext context) {
    //计算总数
    int sum = 0;
    order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return order.product == null
        ? Container()
        : Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey[300], offset: Offset(2, 3), blurRadius: 5)
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${SalesApplicationLocalizedMap[order.salesApplication]}',
                    style: TextStyle(
                        color: _statusColors[order.status],
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${PurchaseOrderStatusLocalizedMap[order.status]}',
                    style: TextStyle(
                        color: _statusColors[order.status],
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  child: Stack(
                    alignment: const Alignment(0.6, 1.1),
                    children: <Widget>[
                      ImageFactory.buildThumbnailImage(
                          order.product?.thumbnail),
                      Container(
                        child: Icon(
                          Icons.photo_size_select_actual,
                          color: Colors.black38,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PicturePickPreviewWidget(
                              medias: order.product.thumbnails,
                              isUpload: false,
                            )));
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        order.product == null || order.product.name == null
                            ? Container()
                            : Text(
                          order.product.name,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: order.product == null ||
                              order.product.skuID == null
                              ? Container()
                              : Text(
                            '货号：${order.product.skuID}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 243, 243, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: order.product == null ||
                              order.product.category == null
                              ? Container()
                              : Text(
                            "${order.product.category.name}  ${sum}件",
                            style: TextStyle(
                                fontSize: 15,
                                color:
                                Color.fromRGBO(255, 133, 148, 1)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  //底部订单信息
  Widget _buildBottom(BuildContext context) {
    return GestureDetector(
      onTap: () {
        copyToClipboard(order.code);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 50),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: order.code == null
                        ? Container()
                        : Text('生产订单号：${order.code}'),
                  ),
                ),
                Text(
                  '复制',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: order.requirementOrderCode == null
                    ? Container()
                    : Text('需求订单号：${order.requirementOrderCode}')),
            Align(
                alignment: Alignment.centerLeft,
                child: order.creationTime == null
                    ? Container()
                    : Text(
                        '订单生成时间：${DateFormatUtil.formatYMD(order.creationTime)}')),
            Align(
                alignment: Alignment.centerLeft,
                child: order.expectedDeliveryDate == null
                    ? Container()
                    : Text(
                        '预计交货时间：${DateFormatUtil.formatYMD(order.expectedDeliveryDate)}')),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

//构建工厂信息UI
  Widget _buildFactoryInfo(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (order.belongTo != null) {
          //TODO跳转详细页
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyFactoryPage(
                    factoryUid: order.belongTo.uid,
                    isFactoryDetail: true,
                  )));
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.CONFIRM_DIALOG,
                  contentText1: '订单未绑定工厂',
                  contentText2: '发送唯一码，邀请工厂绑定',
                  isNeedConfirmButton: true,
                  confirmButtonText: '确定',
                  dialogHeight: 180,
                );
              });
        }
      },
      child: Container(
//      padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: order.belongTo == null ||
                                      order.belongTo.name == null
                                  ? Text(
                                      '${order.companyOfSeller == null ? '' : order.companyOfSeller}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : Text(
                                      order.belongTo.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                            ),
                            order.belongTo == null ||
                                    order.belongTo.starLevel == null
                                ? Container()
                                : Stars(
                                    size: 14,
                                    color: Color.fromRGBO(255, 183, 0, 1),
                                    highlightOnly: false,
                                    starLevel: order.belongTo.starLevel,
                                  ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '历史接单${order.belongTo == null || order.belongTo.historyOrdersCount == null ? '0' : order.belongTo.historyOrdersCount}单',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Divider(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('合作方式'),
                    ),
                  ),
                  Container(
                    child: order.machiningType == null
                        ? Container()
                        : Text(MachiningTypeLocalizedMap[order.machiningType]),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('是否开具发票'),
                    ),
                  ),
                  Container(
                    child: order.invoiceNeeded == null
                        ? Container()
                        : Text(order.invoiceNeeded == true ? '开具发票' : '不开具发票'),
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  //品牌信息UI
  Widget _buildBrandInfo(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                order.purchaser == null ||
                    order.purchaser.profilePicture == null
                    ? Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Center(
                    child: Icon(
                      B2BIcons.noPicture,
                      color: Color.fromRGBO(200, 200, 200, 1),
                      size: 60,
                    ),
                  ),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(243, 243, 243, 1)),
                )
                    : Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                    imageUrl:
                    '${order.purchaser.profilePicture.previewUrl()}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        SpinKitRing(
                          color: Colors.black12,
                          lineWidth: 2,
                          size: 30,
                        ),
                    errorWidget: (context, url, error) =>
                        SpinKitRing(
                          color: Colors.black12,
                          lineWidth: 2,
                          size: 30,
                        ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        '${order.purchaser == null ||
                            order.purchaser.name == null ? order
                            .companyOfSeller == null ||
                            order.companyOfSeller == '' ? '' : order
                            .companyOfSeller : order.purchaser.name}',
                        textScaleFactor: 1.3,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        color: Color.fromRGBO(254, 252, 235, 1),
                        child: order.purchaser != null &&
                                order.purchaser.approvalStatus != null &&
                                order.purchaser.approvalStatus !=
                                    ArticleApprovalStatus.approved
                            ? Text('  已认证  ',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 133, 148, 1),
                                ))
                            : Text(
                                '  未认证  ',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 133, 148, 1),
                                ),
                              ))
                  ],
                ))
              ],
            ),
            Divider(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${order.contactPersonOfSeller == null ||
                          order.contactPersonOfSeller == '' ? '未填写联系人' : order
                          .contactPersonOfSeller}',
                      style: order.contactPersonOfSeller == null ||
                          order.contactPersonOfSeller == ''
                          ? TextStyle(color: Colors.grey)
                          : TextStyle(),
                    ),
                  ),
                  Text(
                    '${order.contactOfSeller == null ||
                        order.contactOfSeller == '' ? '未填写联系电话' : order
                        .contactOfSeller}',
                    style: order.contactOfSeller == null ||
                        order.contactOfSeller == ''
                        ? TextStyle(color: Colors.grey)
                        : TextStyle(),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('合作方式'),
                    ),
                  ),
                  Container(
                    child: order.machiningType == null
                        ? Container()
                        : Text(MachiningTypeLocalizedMap[order.machiningType]),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('是否开具发票'),
                    ),
                  ),
                  Container(
                    child: order.invoiceNeeded == null
                        ? Container()
                        : Text(order.invoiceNeeded == true ? '是' : '否'),
                  ),
                ],
              ),
            )
          ],
        ));
  }

//构建收货信息UI
  Widget _buildDeliveryAddress(BuildContext context) {
    return GestureDetector(
      child: Container(
//      padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                userType == 'brand' &&
                    order.status != PurchaseOrderStatus.COMPLETED &&
                    order.status != PurchaseOrderStatus.CANCELLED &&
                    order.status != PurchaseOrderStatus.OUT_OF_STORE
                    ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyAddressesPage(isJumpSource: true)),
                  //接收返回数据并处理
                ).then((value) async {
                  print(value);
                  if (value != null) {
                    setState(() {
                      order.deliveryAddress = value;
                    });
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: PurchaseOrderRepository()
                                .updateAddress(order.code, order),
                            outsideDismiss: false,
                            loadingText: '保存中。。。',
                            entrance: '0',
                          );
                        }).then((value) {
                      _getData();
                    });
                  }
                })
                    : null;
                PurchaseOrderBLoC.instance.refreshData('ALL');
              },
              child: Container(
                child: ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  title: Row(
                    children: <Widget>[
                      order.deliveryAddress == null ||
                              order.deliveryAddress.fullname == null
                          ? Container()
                          : Text(order.deliveryAddress.fullname),
                      order.deliveryAddress == null ||
                              order.deliveryAddress.cellphone == null
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(order.deliveryAddress.cellphone),
                            )
                    ],
                  ),
                  subtitle: order.deliveryAddress == null ||
                          order.deliveryAddress.region == null ||
                          order.deliveryAddress.city == null ||
                          order.deliveryAddress.cityDistrict == null ||
                          order.deliveryAddress.line1 == null
                      ? Container()
                      : Text(
                          order.deliveryAddress.region.name +
                              order.deliveryAddress.city.name +
                              order.deliveryAddress.cityDistrict.name +
                              order.deliveryAddress.line1,
                          style: TextStyle(
                            color: Colors.black,
                          )),
                ),
              ),
            ),
            SizedBox(
              child: Image.asset(
                'temp/common/address_under_line.png',
                package: 'assets',
                fit: BoxFit.fitWidth,
              ),
            ),
            GestureDetector(
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        '物流信息',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${order.consignment != null && order.consignment.carrierDetails != null ? order.consignment.carrierDetails.name : ''}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          child: Text(
                            '${order.consignment != null && order.consignment.carrierDetails != null ? order.consignment.trackingID : ''}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                if (order.consignment != null &&
                    order.consignment.carrierDetails != null &&
                    order.consignment.trackingID != null &&
                    order.consignment.carrierDetails.name != null) {
                  copyToClipboard(order.consignment.trackingID);
                } else {
                  null;
                }
              },
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {},
    );
  }

//构建生产进度UI
  Widget _buildPurchaseProductionProgresse(BuildContext context) {
    int _index = 0;
    if (order.progresses != null) {
      for (int i = 0; i < order.progresses.length; i++) {
        if (order.currentPhase == order.progresses[i].phase) {
          _index = order.progresses[i].sequence;
        }
      }
    }

    return order.progresses == null
        ? Container()
        : Container(
            padding: EdgeInsets.only(right: 15),
            child: Column(
              children: <Widget>[
                _buildProductionProgress(
                    context, order.progresses[_index], true),
                Container(
                    width: 200,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: OutlineButton(
                      child: Text(
                        '查看全部',
                        style: TextStyle(color: Colors.black),
                      ),
                      borderSide: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      onPressed: () {
                        ///更新生产进度状态数据模型
                        final state =
                        Provider.of<ProductionProgressState>(context);
                        state.setOrder(order);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductionProgressesPage(order: order),
                          ),
                        );
                      },
                    ))
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          );
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,
      ProductionProgressModel productionProgress, bool isCurrentStatus) {
    return Stack(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: _buildProgressTimeLine(
                context, productionProgress, isCurrentStatus)),
        Positioned(
          top: 30.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: Colors.black45,
          ),
        ),
        Positioned(
          top: 26.0,
          left: 10.0,
          child: Container(
            height: 16.0,
            width: 16.0,
            child: Container(
              margin: EdgeInsets.all(3.0),
              height: 16.0,
              width: 16.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,
      ProductionProgressModel productionProgress, bool isCurrentStatus) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      '${ProductionProgressPhaseLocalizedMap[productionProgress.phase]} ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 18)),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    (productionProgress.delayedDays ?? -1) > 0
                        ? "(已延期${productionProgress.delayedDays}天)"
                        : '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    isCurrentStatus == true &&
                        order.status == PurchaseOrderStatus.IN_PRODUCTION
                        ? _buildEstimatedDate(
                            context, productionProgress, isCurrentStatus)
                        : _buildFinishDate(
                            context, productionProgress, isCurrentStatus),
                    _buildQuantity(
                        context, productionProgress, isCurrentStatus),
                    _buildProgressRemarks(
                        context, productionProgress, isCurrentStatus),
                  ],
                ),
              ),
              GestureDetector(
                child: productionProgress.medias == null ||
                        productionProgress.medias.isEmpty
                    ? Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Center(
                          child: Icon(
                            B2BIcons.noPicture,
                            color: Color.fromRGBO(200, 200, 200, 1),
                            size: 60,
                          ),
                        ),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(243, 243, 243, 1)),
                )
                    : Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 100,
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl:
                    '${productionProgress.medias[0].previewUrl()}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        SpinKitRing(
                          color: Colors.black12,
                          lineWidth: 2,
                          size: 30,
                        ),
                    errorWidget: (context, url, error) =>
                        SpinKitRing(
                          color: Colors.black12,
                          lineWidth: 2,
                          size: 30,
                        ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => PicturePickPreviewWidget(
                                medias: productionProgress.medias,
                                isUpload: isCurrentStatus == true &&
                                        order.status ==
                                            PurchaseOrderStatus.IN_PRODUCTION
                                    ? true
                                    : false,
                              )))
                      .then((value) {
                    if (value != null) {
                      productionProgress.medias = value;
                      productionProgress.updateOnly = true;
                      uploadPicture(productionProgress);
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedDate(BuildContext context,
      ProductionProgressModel progress, bool isCurrentStatus) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          GestureDetector(
              child: Text('预计完成时间', style: TextStyle()),
              onTap: () {
                userType != null &&
                    userType == 'factory' &&
                    isCurrentStatus == true &&
                    order.status == PurchaseOrderStatus.IN_PRODUCTION
                    ? _showDatePicker(progress)
                    : null;
              }),
          GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: progress.estimatedDate == null
                    ? Text('选择日期', style: TextStyle(color: Colors.grey))
                    : Text(
                    '${DateFormatUtil.formatYMD(progress.estimatedDate)}',
                    style: TextStyle()),
              ),
              onTap: () {
                userType != null &&
                        userType == 'factory' &&
                        isCurrentStatus == true &&
                        order.status == PurchaseOrderStatus.IN_PRODUCTION
                    ? _showDatePicker(progress)
                    : null;
              }),
        ],
      ),
    );
  }

  Widget _buildFinishDate(BuildContext context,
      ProductionProgressModel progress, bool isCurrentStatus) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text('实际完成时间：', style: TextStyle()),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: progress.finishDate == null
                ? Container()
                : Text('${DateFormatUtil.formatYMD(progress.finishDate)}',
                style: TextStyle()),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context, ProductionProgressModel progress,
      bool isCurrentStatus) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            GestureDetector(
                child: Text('数量', style: TextStyle()),
                onTap: () {
                  userType != null &&
                      userType == 'factory' &&
                      isCurrentStatus == true &&
                      order.status == PurchaseOrderStatus.IN_PRODUCTION
                      ? _showDialog(progress)
                      : null;
                }),
            GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: progress.quantity == 0 || progress.quantity == null
                        ? Text('${userType == 'brand' ? '' : '填写'}',
                        style: TextStyle(
                          color: Colors.grey,
                        ))
                        : Text('${progress.quantity}', style: TextStyle()),
                  ),
                ),
                onTap: () {
                  userType != null &&
                          userType == 'factory' &&
                          isCurrentStatus == true &&
                          order.status == PurchaseOrderStatus.IN_PRODUCTION
                      ? _showDialog(progress)
                      : null;
                }),
            progress.quantity == null || progress.quantity == ''
                ? Align(
                    alignment: Alignment.centerRight,
                    child: userType == 'brand'
                        ? Container()
                        : IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              userType != null &&
                                      userType == 'factory' &&
                                      isCurrentStatus == true &&
                                      order.status ==
                                          PurchaseOrderStatus.IN_PRODUCTION
                                  ? _showDialog(progress)
                                  : null;
                            }),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRemarks(BuildContext context,
      ProductionProgressModel progress, bool isCurrentStatus) {
    return Container(
        child: GestureDetector(
      child: Container(
          padding: EdgeInsets.all(8),
          child: Row(children: <Widget>[
            Text('备注', style: TextStyle()),
            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                child: progress.remarks == null || progress.remarks == ''
                    ? Text(
                  '${userType == 'brand' ? '' : '填写'}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
                    : Container(
                  width: 140,
                  child: Text(
                    '${progress.remarks}',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ])),
      onTap: () async {
        userType != null &&
                userType == 'factory' &&
                isCurrentStatus == true &&
                order.status == PurchaseOrderStatus.IN_PRODUCTION
            ? _showRemarksDialog(progress, '备注', progress.remarks)
            : __neverShowMsg(
            '${progress.remarks == null ? '' : progress.remarks}');
      },
    ));
  }

  //提示付款信息
  Widget _buildTipsPayment(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return order.status == PurchaseOrderStatus.PENDING_PAYMENT
        ? Container(
            padding: EdgeInsets.only(left: 15),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                bloc.isBrandUser ? '生产状态尚未开始，请先确认订单' : '生产状态尚未开始，待客户确认订单',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        : Container();
  }

  // 提示隐藏产品颜色尺码UI
  Widget _buildProductHide(BuildContext context) {
    if (order.entries.length < 4) {
      return Container();
    }

    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    isHide ? "点击展开全部详情" : '点击折叠全部详情',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(
                    isHide
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.grey,
                    size: 28,
                  ),
                ],
              )),
        ),
        onTap: () {
          setState(() {
            isHide = !isHide;
          });
        });
  }

  //产品的颜色尺码及价格
  Widget _buildProductInfo(BuildContext context) {
    List<ApparelSizeVariantProductEntry> _datas;
    if (isHide) {
      _datas = mockData.getRange(0, 1).toList();
    } else {
      _datas = mockData;
    }

    return mockData.isEmpty
        ? Container()
        : Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          // Container(
          //   color: Colors.white,
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: ColorSizeNumTable(
          //     data: _datas,
          //   ),
          // ),
          _buildEntriesRow(),
          _buildProductHide(context),
          Container(
            child: ListTile(
                leading: Text(
                  '订单报价',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '￥',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '${order.unitPrice == null ? '' : order.unitPrice}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    )
                  ],
                )),
          ),
          Container(
            child: ListTile(
                leading: Text(
                  '合计',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '￥',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '${order.totalPrice == null ? '' : order.totalPrice}',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                      ),
                    )
                  ],
                )),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //备注
  Widget _buildRemarks(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '备注',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: order.remarks == null
                          ? Container()
                          : Text(
                              '${order.remarks}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    )),
              ],
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //合同
  Widget _buildContracts(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text('订单合同'),
                  ),
                  order.userAgreementIsSigned ?? false
                      ? B2BImage.signed(width: 50, height: 30)
                      : B2BImage.notSigned(width: 50, height: 30)
                ],
              )),
//          FlatButton(
//            color: const Color.fromRGBO(255, 219, 0, 1),
//            onPressed: () {},
//            child: Text('签署合同'),
//          )
        ],
      ),
    );
  }

  //账务
  Widget _buildFinance(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.white,
        child: order.payPlan != null
            ? Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text('账务'),
                        ),
                      ],
                    )),
//                FlatButton(
//                  color: const Color.fromRGBO(255, 219, 0, 1),
//                  onPressed: () {},
//                  child: Text('账务详情'),
//                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: order.payPlan.payPlanItems
                    .map((item) =>
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                              '${PayMoneyTypeLocalizedMap[item.moneyType]}'),
                          item.payStatus == PayStatus.PAID
                              ? B2BImage.paid(width: 40, height: 25)
                              : B2BImage.notPaid(
                              width: 40, height: 25)
                        ],
                      ),
                    ))
                    .toList())
          ],
        )
            : Center(
          child: Text('暂无财务'),
        ));
  }

  //操作日志
  Widget _buildLog(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('财务管理'),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '查看',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  //构建附件UI
  Widget _buildDocutment(BuildContext context) {
    return order.attachments == null || order.attachments.length <= 0
        ? Container()
        : Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.white,
            child: Attachments(list: order.attachments),
          );
  }

  //按钮UI，判断用户类型展示按钮
  Widget _buildCommitButton(BuildContext context) {
    if (userType == 'brand') {
      if (order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // _buildOnlineBrandButton(context),
              _buildOfflineButton(context),
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: _buildOnlineBrandButton(context),
        );
      }
    } else {
      if (order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildFactoryButton(context),
              _buildOfflineButton(context),
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: _buildFactoryButton(context),
        );
      }
    }
  }

  //线下单显示按钮
  Widget _buildOfflineButton(BuildContext context) {
    if (order.cooperator == null ||
        order.cooperator.type == CooperatorType.ONLINE) {
      return Container(
        margin: EdgeInsets.only(bottom: 50),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
                height: 30,
                padding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                    color: Colors.grey,
                    child: Text(
                      '唯一码',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductionGenerateUniqueCodePage(
                                    model: order,
                                  )));
                    })),
          ),
        ],
      ),
    );
  }

  //品牌端支付按钮
  Widget _buildShowBrandButton(BuildContext context) {
    return isShowButton == true &&
        order.depositPaid == false &&
        order.deposit != null &&
        order.deposit > 0 &&
        order.salesApplication == SalesApplication.ONLINE
        ? Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 30),
                child: order.status == PurchaseOrderStatus.PENDING_PAYMENT
                    ? FlatButton(
                    color: Colors.red,
                    child: Text(
                      '取消订单',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    onPressed: () async {})
                    : Container()),
          ),
          Expanded(
            child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 30),
                child: FlatButton(
                    color: Color(0xFFFFD600),
                    child: Text(
                      '去支付',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      //将支付金额置为定金
//                      order.totalPrice = order.deposit;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              OrderPaymentPage(
                                order: order,
                                paymentFor: PaymentFor.DEPOSIT,
                              )));
                    })),
          ),
        ],
      ),
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: Container(
              height: 30,
              padding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: FlatButton(
                  color: Color(0xFFFFD600),
                  child: Text(
                    '确认',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    bool result = await PurchaseOrderRepository()
                        .confirmProduction(order.code, order);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return CustomizeDialog(
                            dialogType: DialogType.RESULT_DIALOG,
                            successTips: '确认生产成功',
                            failTips: '确认生产失败',
                            callbackResult: result,
                          );
                        });
                  })),
        ),
      ],
    );
  }

  //品牌端显示按钮
  Widget _buildOnlineBrandButton(BuildContext context) {
    if (order.salesApplication == SalesApplication.ONLINE) {
      if (order.depositPaid == false &&
          order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
        return _buildShowBrandButton(context);
      } else if (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
        if (order.balancePaid == false &&
            order.balance != null &&
            order.balance > 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Container(
                    height: 30,
                    padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    child: FlatButton(
                        color: Color(0xFFFFD600),
                        child: Text(
                          '去支付',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          //将支付金额置为尾款
//                          order.totalPrice = order.balance;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OrderPaymentPage(
                                order: order,
                                paymentFor: PaymentFor.BALANCE,
                              )));
                        })),
              ),
            ],
          );
        }
      } else if (order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 30,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确认收货',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        bool result = false;
                        result = await PurchaseOrderRepository()
                            .purchaseOrderShipped(order.code, order);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return CustomizeDialog(
                                dialogType: DialogType.RESULT_DIALOG,
                                successTips: '确认收货成功',
                                failTips: '确认收货失败',
                                callbackResult: result,
                              );
                            });
                      })),
            ),
          ],
        );
      } else {
        return Container();
      }
    } else {
      if (order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 30,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确认收货',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        bool result = false;
                        result = await PurchaseOrderRepository()
                            .purchaseOrderShipped(order.code, order);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return CustomizeDialog(
                                dialogType: DialogType.RESULT_DIALOG,
                                successTips: '确认收货成功',
                                failTips: '确认收货失败',
                                callbackResult: result,
                              );
                            });
                      })),
            ),
          ],
        );
      } else {
        return Container();
      }
    }
  }

  //工厂端按钮
  Widget _buildFactoryButton(BuildContext context) {
    //当流程是待出库状态下
    if (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      //尾款已付时，出现确认发货
      if (order.balancePaid ||
          order.balance == 0 ||
          order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 30,
                padding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                  color: const Color(0xFFFFD600),
                  child: const Text(
                    '确认发货',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LogisticsInputPage(
                            isProductionOrder: true, purchaseOrderModel: order),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }
    }
    //当流程是已出库时，可以查看物流
    else if (order.status == PurchaseOrderStatus.OUT_OF_STORE) {
      return Container(
//        width: 300,
//        margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
//        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//        height: 40,
//        child: FlatButton(
//            color: Color(0xFFFFD600),
//            child: Text(
//              '查看物流',
//              style: TextStyle(
//                color: Colors.black,
//                fontWeight: FontWeight.w500,
//                fontSize: 18,
//              ),
//            ),
//            shape: RoundedRectangleBorder(
//                borderRadius:
//                BorderRadius.all(Radius.circular(5))),
//            onPressed: () {}
//        ),
          );
    } else {
      return Container();
    }
  }

//生成日期选择器
  Future<Null> _selectDate(
      BuildContext context, ProductionProgressModel model) async {
    DateTime nowDate = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowDate,
        firstDate: nowDate,
        lastDate: DateTime(2999));

    if (_picked != null) {
      setState(() {
        model.estimatedDate = _picked;
      });

      try {
        model.updateOnly = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return RequestDataLoading(
                requestCallBack: PurchaseOrderRepository()
                    .productionProgressUpload(
                    order.code, model.id.toString(), model),
                outsideDismiss: false,
                loadingText: '保存中。。。',
                entrance: '0',
              );
            });
      } catch (e) {
        print(e);
      }
      setState(() {
        _blDate = _picked;
      });
    }
  }

//生成Dialog控件
  Future<void> _neverSatisfied(
      BuildContext context, ProductionProgressModel model) async {
    dialogText = TextEditingController();
    _dialogFocusNode = FocusNode();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFieldComponent(
                  textAlign: TextAlign.left,
                  focusNode: _dialogFocusNode,
                  controller: dialogText,
                  autofocus: true,
                  inputType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if (dialogText.text != null) {
                  print(dialogText.text);
                  if (dialogText != null && dialogText.text != '') {
                    setState(() {
                      model.quantity = int.parse(dialogText.text);
                    });
                  }
                  model.updateOnly = true;
                  try {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: PurchaseOrderRepository()
                                .productionProgressUpload(
                                order.code, model.id.toString(), model),
                            outsideDismiss: false,
                            loadingText: '保存中。。。',
                            entrance: '0',
                          );
                        });
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    _blNumber = dialogText.text;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

//打开日期选择器
  void _showDatePicker(ProductionProgressModel model) {
    _selectDate(context, model);
  }

//打开数量输入弹框
  Future<void> _showDialog(ProductionProgressModel model) {
    TextEditingController inputController = TextEditingController();
    inputController.text = model.quantity.toString();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.INPUTS_DIALOG,
            inputController1: inputController,
            inputType1: TextInputType.number,
            focusNode1: FocusNode(),
          );
        }).then((value) {
      if (value != null && value != '') {
        model.quantity = int.parse(value);
        try {
          model.updateOnly = true;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return RequestDataLoading(
                  requestCallBack: PurchaseOrderRepository()
                      .productionProgressUpload(
                      order.code, model.id.toString(), model),
                  outsideDismiss: false,
                  loadingText: '保存中。。。',
                  entrance: '',
                );
              });
        } catch (e) {
          print(e);
        }
        setState(() {
          _blNumber = value;
        });
      }
    });
  }

  __neverShowMsg(String text) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            '备注',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('${text}'),
            ),
          ],
        );
      },
    );
  }

  //备注输入框
  void _showRemarksDialog(
      ProductionProgressModel model, String type, String remarks) {
    _neverRemarks(context, model, type, remarks);
  }

  Future<void> _neverRemarks(BuildContext context,
      ProductionProgressModel model, String type, String remarks) async {
    TextEditingController inputController = TextEditingController();
    inputController.text = model.remarks;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.INPUTS_DIALOG,
            inputController1: inputController,
            focusNode1: FocusNode(),
          );
        }).then((value) {
      if (value != null && value != '') {
        model.remarks = value;
        try {
          model.updateOnly = true;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return RequestDataLoading(
                  requestCallBack: PurchaseOrderRepository()
                      .productionProgressUpload(
                      order.code, model.id.toString(), model),
                  outsideDismiss: false,
                  loadingText: '保存中。。。',
                  entrance: '',
                );
              });
        } catch (e) {
          print(e);
        }
        setState(() {
          _blNumber = value;
        });
      }
    });
  }

  void uploadPicture(ProductionProgressModel model) async {
    await PurchaseOrderRepository()
        .productionProgressUpload(order.code, model.id.toString(), model);
  }

  void _showMessage(BuildContext context, bool result, String message) {
    _requestMessage(context, result == true ? '${message}成功' : '${message}失败');
  }

  Future<void> _requestMessage(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text(
            '提示',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          content: Text('${message}'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                PurchaseOrderBLoC.instance.refreshData('ALL');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PurchaseOrdersPage()),
                    ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  copyToClipboard(final String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              successTips: '复制成功',
              callbackResult: true,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  Widget _bubildBottomSheet() {
    Widget _contactPerson;
    if (order?.cooperator == null) {
      _contactPerson = Container();
    } else {
      if (order.cooperator.type == CooperatorType.ONLINE) {
        _contactPerson = Text('${order.cooperator.partner.contactPerson}');
      } else {
        _contactPerson = Text('${order.cooperator.contactPerson}');
      }
    }

    return Container(
      height: 55,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.phone,
                          size: 28,
                          color: Colors.green,
                        ),
                      ),
                      _contactPerson
                    ],
                  ),
                  onPressed: () async {
                    var url = 'tel:';
                    if (order.cooperator.type == CooperatorType.ONLINE) {
                      url += order.cooperator.partner.contactPhone;
                    } else {
                      url += order.cooperator.contactPhone;
                    }
                    await launch(url);
                  },
                ),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: PurchaseDetailBtnGroup(
                order: order,
              ))
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return order.salesApplication == SalesApplication.ONLINE
        ? null
        : SpeedDial(
      // animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '查看单据',
            style: TextStyle(color: Colors.black, fontSize: 12),
          )
        ],
      ),
      visible: true,
      curve: Curves.bounceIn,
      // overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: '查看单据',
      heroTag: '查看单据',
      // backgroundColor: Color.fromRGBO(255,214,12, 1),
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
      children: [
        SpeedDialChild(
          child: Center(
            child: Text(
              '发货单',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShippingOrderView(
                      shippingOrders: order.shippingOrders,
                    ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
        ),
        SpeedDialChild(
          child: Center(
            child: Text(
              '收货单',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          backgroundColor: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DeliverOrderView(
                      purchaseOrderCode: order.code,
                      deliveryOrder: order.deliveryOrders.isNotEmpty
                          ? order.deliveryOrders[0]
                          : null,
                    ),
              ),
            );
          },
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
        ),
        SpeedDialChild(
          child: Center(
            child: Text(
              '对账单',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          backgroundColor: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ReconciliationOrderView(
                      purchaseOrder: order,
                      reconciliationOrder:
                      order.reconciliationOrders.isNotEmpty
                          ? order.reconciliationOrders[0]
                          : null,
                    ),
              ),
            );
          },
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
        ),
      ],
    );
  }

  _getDeductionAmountText(double amount) {
    String text = '';
    if (amount != null) {
      if (amount < 0) {
        text += '-￥';
        amount = -amount;
      }
      text += amount.toString();
    }

    return text;
  }

  ///尺码
  Widget _buildEntriesRow() {
    List<Widget> entryRows = [];

    for (int i = 0; i < order.entries.length; i++) {
      if (i < 3 || !isHide) {
        entryRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 50),
                child: Text(
                  '颜色：${order.entries[i].product.color.name}',
                  style: TextStyle(color: Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text('尺码：${order.entries[i].product.size.name}',
                  style: TextStyle(color: Colors.grey)),
            ),
            Text('x${order.entries[i].quantity}')
          ],
        ));
      }
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(children: entryRows),
    );
  }
}
