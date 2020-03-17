import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_update_deduction_amount_dialog.dart';
import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_update_total_price_dialog.dart';
import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:b2b_commerce/src/business/purchase_orders.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import 'form/purchase/purchase_detail_btn_group_online.dart';

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

class PurchaseOrderDetailOnlinePage extends StatefulWidget {
  final String code;

  final bool isProduction;

  PurchaseOrderDetailOnlinePage({
    Key key,
    @required this.code,
    this.isProduction = false,
  }) : super(key: key);

  _PurchaseDetailOnlinePageState createState() =>
      _PurchaseDetailOnlinePageState();
}

class _PurchaseDetailOnlinePageState
    extends State<PurchaseOrderDetailOnlinePage> {
  TextEditingController dialogText;
  List<ApparelSizeVariantProductEntry> mockData = new List();
  bool isShowButton = false;
  String userType;
  String remarks;
  bool isHide = true;
  int totalQuantity = 0;
  SalesApplication salesApplication;
  var _futureBuilderFuture;

  PurchaseOrderModel order;

  _PurchaseDetailOnlinePageState({this.order});

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
                      (order.status == PurchaseOrderStatus.PENDING_PAYMENT &&
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
                      _buildBottom(context),
                    ],
                  )),
                ],
              ),
            ),
            bottomSheet: _bubildBottomSheet(),
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
                            builder: (context) => PicturePickPreviewWidget(
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
                          placeholder: (context, url) => SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30,
                          ),
                          errorWidget: (context, url, error) => SpinKitRing(
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
                        '${order.purchaser == null || order.purchaser.name == null ? order.companyOfSeller == null || order.companyOfSeller == '' ? '' : order.companyOfSeller : order.purchaser.name}',
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
                      '${order.contactPersonOfSeller == null || order.contactPersonOfSeller == '' ? '未填写联系人' : order.contactPersonOfSeller}',
                      style: order.contactPersonOfSeller == null ||
                              order.contactPersonOfSeller == ''
                          ? TextStyle(color: Colors.grey)
                          : TextStyle(),
                    ),
                  ),
                  Text(
                    '${order.contactOfSeller == null || order.contactOfSeller == '' ? '未填写联系电话' : order.contactOfSeller}',
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
                    '${productionProgress.delayedDays > 0 ? '已延期${productionProgress.delayedDays}天' : ''}',
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
                          placeholder: (context, url) => SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30,
                          ),
                          errorWidget: (context, url, error) => SpinKitRing(
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
    return order.depositPaid == false
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
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ColorSizeNumTable(
                    data: _datas,
                  ),
                ),
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
                            '${(order.totalPrice ?? 0).toStringAsFixed(2)}',
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
                Container(
                  child: ListTile(
                      leading: Text(
                        '定金',
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
                            '${order.deposit == null ? 0 : order.deposit.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.red,
                            ),
                          )
                        ],
                      )),
                ),
                Offstage(
                  offstage: order.salesApplication != SalesApplication.ONLINE ||
                      order.status != PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('其他扣款'),
                        Text(
                          _getDeductionAmountText(order.deductionAmount),
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: order.salesApplication != SalesApplication.ONLINE ||
                      order.status != PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '实付金额',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '￥${((order.balance ?? 0) + (order.deductionAmount ?? 0)).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
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
    }
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
      }
    });
  }

  void uploadPicture(ProductionProgressModel model) async {
    await PurchaseOrderRepository()
        .productionProgressUpload(order.code, model.id.toString(), model);
  }

  //打开修改尾款金额弹框
  void onUpdateBalance() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return PurchaseUpdateDeductionAmountDialog(
            purchaseOrderModel: order,
          );
        }).then((value) {
      if (value != null && value != '') {
        String str = value;
        _updateBalance(context, order, str);
      }
    });
  }

  void _updateBalance(
      BuildContext context, PurchaseOrderModel model, String text) async {
    double amount = double.parse(text);

    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: PurchaseOrderRepository()
                  .purchaseOrderDeductionAmountUpdate(
                      model.code, PurchaseOrderModel(deductionAmount: amount)),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: 'purchaseOrders',
            );
          }).then((value) async {
        if (value) {
          PurchaseOrderModel purchaseOrderModel =
              await PurchaseOrderRepository()
                  .getPurchaseOrderDetail(model.code);
          setState(() {
            order = purchaseOrderModel;
            PurchaseOrderBLoC.instance
                .updateAmountResetData('ALL', purchaseOrderModel);
            PurchaseOrderBLoC.instance.updateAmountResetData(
                'WAIT_FOR_OUT_OF_STORE', purchaseOrderModel);
            BotToast.showText(text: '修改价格成功');
          });
        } else {
          BotToast.showText(text: '修改价格失败');
        }
//          if (value) {
//            if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
//              try {
//                for (int i = 0; i < _model.progresses.length; i++) {
//                  if (_model.currentPhase ==
//                      _model.progresses[i].phase) {
//                    await PurchaseOrderRepository().productionProgressUpload(
//                        _model.code,
//                        _model.progresses[i].id.toString(),
//                        _model.progresses[i]);
//                  }
//                }
//              } catch (e) {
//                print(e);
//              }
//            }
//          }
      });
    } catch (e) {
      print(e);
    }
    PurchaseOrderBLoC.instance.refreshData('ALL');
    PurchaseOrderBLoC.instance.refreshData('WAIT_FOR_OUT_OF_STORE');
  }

  //打开修改定金金额弹框
  void _showDepositDialog(BuildContext context, PurchaseOrderModel model,
      String depositText, DateTime date) {
    double totalPrice = 0.0;
    if (depositText != null && depositText != '') {
      if (depositText.indexOf('￥') != 0) {
        totalPrice = double.parse(depositText.replaceAll('￥', ''));
      }
    }

//    model.skipPayBalance = false;
//    model.totalPrice = totalPrice;
//    model.expectedDeliveryDate = date;
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: PurchaseOrderRepository()
                  .purchaseOrderDepositUpdate(
                      model.code,
                      PurchaseOrderModel(
                          totalPrice: totalPrice, expectedDeliveryDate: date)),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: '0',
            );
          }).then((value) async {
        if (value) {
          PurchaseOrderModel purchaseOrderModel =
              await PurchaseOrderRepository()
                  .getPurchaseOrderDetail(model.code);
          setState(() {
            order = purchaseOrderModel;
            PurchaseOrderBLoC.instance
                .updateAmountResetData('ALL', purchaseOrderModel);
            PurchaseOrderBLoC.instance
                .updateAmountResetData('PENDING_PAYMENT', purchaseOrderModel);
            BotToast.showText(text: '修改价格成功');
          });
        } else {
          BotToast.showText(text: '修改价格失败');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showTips(BuildContext context, PurchaseOrderModel model) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否无需付款直接跳过？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              _neverComplete(context, order);
            },
          );
        });
  }

  //确认跳过按钮
  Future<void> _neverComplete(
      BuildContext context, PurchaseOrderModel model) async {
    model.balance = 0;
    model.skipPayBalance = true;
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: PurchaseOrderRepository()
                  .purchaseOrderBalanceUpdate(model.code, model),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: 'purchaseOrders',
            );
          }).then((value) async {
        if (value) {
          PurchaseOrderModel purchaseOrderModel =
              await PurchaseOrderRepository()
                  .getPurchaseOrderDetail(model.code);
          setState(() {
            model = purchaseOrderModel;
            BotToast.showText(text: '跳过尾款成功');
            PurchaseOrderBLoC.instance.refreshData('ALL');
            PurchaseOrderBLoC.instance.refreshData('WAIT_FOR_OUT_OF_STORE');
            PurchaseOrderBLoC.instance.refreshData('OUT_OF_STORE');
          });
        } else {
          BotToast.showText(text: '跳过尾款失败');
        }
      });

      if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
        try {
          for (int i = 0; i < order.progresses.length; i++) {
            if (order.currentPhase == order.progresses[i].phase) {
              await PurchaseOrderRepository().productionProgressUpload(
                  order.code,
                  order.progresses[i].id.toString(),
                  order.progresses[i]);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
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
              child: PurchaseDetailOnlineBtnGroup(
                order: order,
                onUpdateDeposit: onUpdateDeposit,
                onUpdateBalance: onUpdateBalance,
              ))
        ],
      ),
    );
  }

  //修改定金
  onUpdateDeposit() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return PurchaseUpdateTotalPriceDialog(
            purchaseOrderModel: order,
          );
        }).then((value) {
      if (value != null && value != '') {
        String str = value;
        str = str.replaceAll('￥', '');
        print(str);
        String deposit = str.substring(0, str.indexOf(','));
        String date = str.substring(str.indexOf(',') + 1, str.length);
        _showDepositDialog(context, order, deposit,
            date == 'null' ? null : DateTime.parse(date));
      }
    });
  }

  _getDeductionAmountText(double amount) {
    String text = '';
    if (amount == null || amount == 0) {
      text = '￥0.00';
    } else {
      if (amount < 0) {
        text += '-￥';
        amount = -amount;
      }
      text += amount.toString();
    }
    return text;
  }
}
