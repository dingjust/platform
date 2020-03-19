import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/sale/form/return_form_page.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import 'form/delivery_form_page.dart';

///
class SaleOrderDetailPage extends StatefulWidget {
  final String code;

  SaleOrderDetailPage({
    Key key,
    @required this.code,
  }) : super(key: key);

  _PurchaseDetailPageState createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<SaleOrderDetailPage> {
  List<ApparelSizeVariantProductEntry> mockData = new List();
  bool isHide = true;
  int totalQuantity = 0;

  PurchaseOrderModel order;

  _PurchaseDetailPageState({this.order});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return FutureBuilder<PurchaseOrderModel>(
      builder:
          (BuildContext context, AsyncSnapshot<PurchaseOrderModel> snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    pinned: true,
                    elevation: 0.5,
                    centerTitle: true,
                    title: Text('销售订单明细'),
                    actions: <Widget>[
                      IconButton(
                        iconSize: 4,
                        icon: Icon(B2BIcons.more),
                        onPressed: () {},
                      )
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
                      _buildDeliveryAddress(context),
                      _buildBottom(context),
                    ],
                  )),
                ],
              ),
            ),
            bottomSheet: _bubildBottomSheet(),
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
  Future<PurchaseOrderModel> _getData() async {
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
    });
  }

  /// 产品详情
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '•${PurchaseOrderStatusLocalizedMap[order.status]}',
                        style: TextStyle(
                            color:
                                SaleOrderConstants.STATUS_COLORS[order.status],
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

  /// 底部订单信息
  Widget _buildBottom(BuildContext context) {
    TextStyle _infoStyle = TextStyle(color: Colors.grey);

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 50),
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
              child: order.creationTime == null
                  ? Container()
                  : Text(
                      '付款时间：${DateFormatUtil.formatYMDHMS(order.creationTime)}',
                      style: _infoStyle)),
          Align(
              alignment: Alignment.centerLeft,
              child: order.creationTime == null
                  ? Container()
                  : Text(
                      '发货时间：${DateFormatUtil.formatYMDHMS(order.creationTime)}',
                      style: _infoStyle)),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  /// 构建收货信息UI
  Widget _buildDeliveryAddress(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
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
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     Container(
            //         padding: EdgeInsets.symmetric(horizontal: 20),
            //         child: Icon(B2BIcons.truck)),
            //   ],
            // ),
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

  /// 提示隐藏产品颜色尺码UI
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

  /// 产品的颜色尺码及价格
  Widget _buildProductInfo(BuildContext context) {
    List<ApparelSizeVariantProductEntry> _datas;
    if (isHide) {
      _datas = mockData.getRange(0, 1).toList();
    } else {
      _datas = mockData;
    }

    TextStyle _infoStyle = TextStyle(color: Colors.grey, fontSize: 16);

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
                      leading: Text('单价X数量', style: _infoStyle),
                      trailing: Text(
                        '￥50x2000',
                        style: _infoStyle,
                      )),
                ),
                Container(
                  child: ListTile(
                    leading: Text('合计总价', style: _infoStyle),
                    trailing: Text('￥100,000', style: _infoStyle),
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

  ///底部按钮
  Widget _bubildBottomSheet() {
    double height = 55;

    return Container(
      height: height,
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 2, color: Colors.grey[100])),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    var url = 'tel:';
                    url += order.belongTo.contactPhone;
                    await launch(url);
                  },
                  child: Container(
                    height: height,
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    child: Icon(
                      Icons.phone,
                      color: Colors.green,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ReturnFormPage()));
                    },
                    child: Text('退货',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ))),
              )),
          Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                child: FlatButton(
                    color: Color.fromRGBO(255, 212, 74, 1),
                    shape: RoundedRectangleBorder(),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DeliveryFormPage()));
                    },
                    child: Text('发货',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ))),
              ))
        ],
      ),
    );
  }
}
