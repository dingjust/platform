import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_constants.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/sales_detail_button_group.dart';

///销售订单详情
class SaleOrderDetailPage extends StatefulWidget {
  final String code;

  final VoidCallback callback;

  SaleOrderDetailPage({
    Key key,
    @required this.code,
    this.callback,
  }) : super(key: key);

  _PurchaseDetailPageState createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<SaleOrderDetailPage> {
  List<ApparelSizeVariantProductEntry> mockData = new List();
  bool isHide = true;

  SalesOrderModel order;

  _PurchaseDetailPageState({this.order});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesOrderModel>(
      builder: (BuildContext context, AsyncSnapshot<SalesOrderModel> snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('销售订单明细'),
              backgroundColor: Constants.THEME_COLOR_MAIN,
              elevation: 0.5,
            ),
            body: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: ListView(
                children: <Widget>[
                  _buildStatusRow(),
                  _buildProductRow(),
                  _buildEntriesRow(),
                  _buildProductInfo(context),
                  _builRefundInfo(),
                  _buildDeliveryAddress(context),
                  _buildRemarks(context),
                  _buildBottom(context),
                ],
              ),
            ),
            bottomSheet: SalesDetailButtonGroup(
                model: order, callback: _buttonGroupCallback),
            resizeToAvoidBottomPadding: true,
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
      future: _getData(),
    );
  }

  /// 查询明细
  Future<SalesOrderModel> _getData() async {
    if (order == null) {
      SalesOrderModel detailModel =
      await SalesOrderRespository().getSalesOrderDetail(widget.code);
      order = detailModel;
    }
    if (order != null) {
      initData(order);
    }
    return order;
  }

  ///刷新数据
  Future<SalesOrderModel> _refreshData() async {
    SalesOrderModel detailModel =
    await SalesOrderRespository().getSalesOrderDetail(widget.code);
    order = detailModel;
    if (order != null) {
      initData(order);
    }
    return order;
  }

  initData(SalesOrderModel order) {
    setState(() {
      mockData.clear();
      //把颜色尺码封装成ApparelSizeVariantProductEntry
      if (order.entries.isNotEmpty) {
        for (int i = 0; i < order.entries.length; i++) {
          if (order.entries[i].product.color != null &&
              order.entries[i].product.size != null) {
            ApparelSizeVariantProductEntry entry =
                new ApparelSizeVariantProductEntry();
            entry.quantity = order.entries[i].quantity;
            entry.model = order.entries[i].product;
            mockData.add(entry);
          }
        }
        //大于三行不隐藏
        if (order.entries.length < 4) {
          isHide = false;
        }
      }
    });
  }

  Widget _buildStatusRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[_getOrderStatus()],
      ),
    );
  }

  ///订单状态
  Widget _getOrderStatus() {
    if (order.refunding != null && order.refunding) {
      return Text(
        '·退款/售后',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: 18,
          color: Colors.purple,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(
      '·${SalesOrderStatusLocalizedMap[order.status]}',
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 18,
        color: SaleOrderConstants.STATUS_COLORS[order.status],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// 产品详情
  Widget _buildProductRow() {
    ApparelProductModel productModel =
        order.entries.first.product.baseProductDetail;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImage(productModel?.thumbnail,
              containerSize: 60),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${productModel.name}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            '￥${order.unitPrice}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text(
                        '货号：${productModel.skuID}',
                        style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  /// 底部订单信息
  Widget _buildBottom(BuildContext context) {
    TextStyle _infoStyle = TextStyle(color: Colors.grey);

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 100),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '订单信息',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    copyToClipboard(order.code);
                  },
                  child: Text(
                    '复制',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '订单编号：${order.code}',
                style: _infoStyle,
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: order.creationTime == null
                  ? Container()
                  : Text(
                      '创建时间：${DateFormatUtil.formatYMDHMS(order.creationTime)}',
                      style: _infoStyle,
                    )),
          Align(
              alignment: Alignment.centerLeft,
              child: order.payTime == null
                  ? Container()
                  : Text('付款时间：${DateFormatUtil.formatYMDHMS(order.payTime)}',
                      style: _infoStyle)),
          Align(
              alignment: Alignment.centerLeft,
              child: order.deliveryTime == null
                  ? Container()
                  : Text(
                  '发货时间：${DateFormatUtil.formatYMDHMS(order.deliveryTime)}',
                  style: _infoStyle)),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  ///退款信息
  Widget _builRefundInfo() {
    if (order.refundStatus == SalesOrderRefundStatus.REJECT) {
      return Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(top: 10),
          color: Colors.white,
          // height: 100,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      '卖家已拒绝退款',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '拒绝原因：',
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          order.refundApply != null
                              ? '${order.refundApply.auditMsg}'
                              : '',
                          overflow: TextOverflow.ellipsis,
                        ))
                  ],
                ),
              )
            ],
          ));
    }
    return Container();
  }

  /// 构建收货信息UI
  Widget _buildDeliveryAddress(BuildContext context) {
    String companyCode = UserBLoC.instance.currentUser.companyCode;
    bool canUpdateAddress = false;
    if (companyCode == order?.belongTo?.uid ??
        null && SalesOrderStatus.PENDING_PAYMENT == order.status) {
      canUpdateAddress = true;
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              onTap: (){
                if(canUpdateAddress){
                  selectDeliveryAddress();
                }
              },
              leading: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              title: Row(
                children: <Widget>[
                  Text('${order?.deliveryAddress?.fullname ?? ''}'),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('${order?.deliveryAddress?.cellphone ?? ''}'),
                  )
                ],
              ),
              subtitle: Text('${order?.deliveryAddress?.details ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: canUpdateAddress ? Icon(
                Icons.edit,
                color: Colors.black,
              ):null,
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
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Container(
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.grey[300]),
              //         shape: BoxShape.circle),
              //     padding: EdgeInsets.fromLTRB(5, 2, 5, 5),
              //     margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
              //     child: Icon(
              //       B2BIcons.truck,
              //       color: Colors.grey[400],
              //     )),
              order.isOfflineConsignment ?? false
                  ? Container(
                padding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('订单已走线下物流'),
              )
                  : Container()
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  void selectDeliveryAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyAddressesPage(
            isJumpSource: true,
            title: '选择地址',
          )),
      //接收返回数据并处理
    ).then((value) async {
      if (value != null) {
        setState(() {
          order.deliveryAddress = value;
        });

        bool result = await SalesOrderRespository().updateAddress(order.code, order);
        if(result){
          BotToast.showText(text: '修改收货地址成功');
        }else{
          BotToast.showText(text: '修改收货地址失败');
        }

      }
    });
  }

  /// 提示隐藏产品颜色尺码UI
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

  /// 产品的颜色尺码及价格
  Widget _buildProductInfo(BuildContext context) {
    TextStyle _infoStyle = TextStyle(color: Colors.grey, fontSize: 16);

    return mockData.isEmpty
        ? Container()
        : Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: <Widget>[
                _buildProductHide(context),
                Container(
                  child: ListTile(
                      leading: Text('单价X数量', style: _infoStyle),
                      trailing: Text(
                        '￥${order.unitPrice}x${order.quality}',
                      )),
                ),
                Container(
                  child: ListTile(
                    leading: Text('合计总价', style: _infoStyle),
                    trailing: Text('￥${order.totalPrice}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        )),
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

  ///复制粘贴
  copyToClipboard(final String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      BotToast.showText(text: '复制到粘贴板');
    }
  }

  ///备注
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

  ///按钮组回调
  void _buttonGroupCallback() {
    //回调刷新页面
    _refreshData();
    setState(() {});
    // //列表刷新回调
    if (widget.callback != null) {
      widget.callback();
    }
  }
}
