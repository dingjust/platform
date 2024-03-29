import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:b2b_commerce/src/business/_shared/widgets/order_contracts_info.dart';
import 'package:b2b_commerce/src/business/_shared/widgets/progress_time_line.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 生产工单详情页
class ProductionTaskOrderEntryDetailPage extends StatefulWidget {
  int id;

  ProductionTaskOrderEntryDetailPage({Key key, @required this.id})
      : super(key: key);

  _ProductionTaskOrderEntryDetailPageState createState() =>
      _ProductionTaskOrderEntryDetailPageState();
}

class _ProductionTaskOrderEntryDetailPageState
    extends State<ProductionTaskOrderEntryDetailPage> {
  SalesProductionOrderModel order;

  bool _returnRefreshListData = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesProductionOrderModel>(
      builder: (BuildContext context,
          AsyncSnapshot<SalesProductionOrderModel> snapshot) {
        if (snapshot.data != null) {
          return WillPopScope(
            onWillPop: () {
              if (_returnRefreshListData) {
                Navigator.pop(context, true);
              } else {
                return Future.value(true);
              }
              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('生产工单明细'),
                backgroundColor: Constants.THEME_COLOR_MAIN,
                elevation: 0.5,
              ),
              body: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListView(
                    children: <Widget>[
                      _MainInfo(
                        order: order.taskOrderEntries[0],
                        saleOrder: order,
                        onRefreshData: refreshData,
                      )
                    ],
                  )),
            ),
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

  Future<SalesProductionOrderModel> _getData() async {
    if (order == null) {
      SalesProductionOrderModel detailModel =
          await ProductionTaskOrderRespository().getOrderDetail(widget.id);
      order = detailModel;
    }
    return order;
  }

  void refreshData(bool returnRefreshData) async {
    SalesProductionOrderModel detailModel =
        await ProductionTaskOrderRespository().getOrderDetail(widget.id);
    if (detailModel != null) {
      setState(() {
        order = detailModel;
        order.taskOrderEntries[0] = detailModel.taskOrderEntries[0];
        if (returnRefreshData && !_returnRefreshListData) {
          _returnRefreshListData = true;
        }
      });
    }
  }
}

class _MainInfo extends StatelessWidget {
  final ProductionTaskOrderModel order;

  final SalesProductionOrderModel saleOrder;

  final ValueChanged<bool> onRefreshData;

  const _MainInfo({Key key, this.order, this.saleOrder, this.onRefreshData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildStatusRow(),
              _buildProductRow(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ColorSizeEntryTable(
                  data: order.colorSizeEntries,
                  compareFunction:
                      Provider.of<SizeState>(context, listen: false).compare,
                ),
              ),
              buildRow('生产数量', '${order.quantity}'),
              buildRow(
                  '合作方式', CooperationModeLocalizedMap[order.cooperationMode]),
              buildRow('交货日期', DateFormatUtil.formatYMD(order.deliveryDate)),
              order.progressWorkSheet != null
                  ? _buildProgressTimeLine()
                  : Container(),
              AddressInfoBlock(
                model: order.shippingAddress,
              ),
            ],
          ),
        ),
        _partnerInfo(saleOrder),
        _staffInfo(order, saleOrder),
        OrderContractsBlock(agreements: saleOrder?.agreements),
        _buildBottom(context),
      ],
    );
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
    return Text(
      '·${ProductionTaskOrderStateLocalizedMap[order.state]}',
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 18,
        color: PRODUCTION_TASK_ORDER_STATE_COLORS[order.state],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  ProgressTimeLine _buildProgressTimeLine() {
    bool _enableEdit = false;
    String companyCode = UserBLoC.instance.currentUser.companyCode;
    String belongToUid = order.progressWorkSheet?.belongTo?.uid;
    if (belongToUid == null) {
      belongToUid = order.progressWorkSheet?.partyBCompany?.uid;
    }
    if (companyCode == belongToUid &&
        (order.state == ProductionTaskOrderState.PRODUCING ||
            order.state == ProductionTaskOrderState.TO_BE_PRODUCED) &&
        (order.outboundOrderCode == null)) {
      _enableEdit = true;
    }

    return ProgressTimeLine(
      model: order.progressWorkSheet,
      enableEdit: _enableEdit,
      onRefreshOrderData: onRefreshData,
    );
  }

  Widget _partnerInfo(SalesProductionOrderModel saleOrder) {
    CooperatorModel cooperator = getCooperator(saleOrder);

    return cooperator != null
        ? Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.white,
            child: Column(children: <Widget>[
              Row(children: [
                Text('合作商信息', style: TextStyle(color: Colors.grey))
              ]),
              buildRow('客户',
                  '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.name : cooperator.name}'),
              buildRow('联系人',
                  '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.contactPerson : cooperator.contactPerson}'),
              buildRow('联系电话',
                  '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.contactPhone : cooperator.contactPhone}'),
            ]),
          )
        : Container();
  }

  CooperatorModel getCooperator(SalesProductionOrderModel saleOrder) {
    CooperatorModel cooperator;

    var companyCode = UserBLoC.instance.currentUser.companyCode;
    // 来源自己的情况
    if (saleOrder.originCompany != null &&
        saleOrder.originCompany.uid == companyCode) {
      cooperator = saleOrder.targetCooperator;
    }
    // 外接的情况
    if (saleOrder.originCooperator != null) {
      cooperator = saleOrder.originCooperator;
    }
    return cooperator;
  }

  Widget _staffInfo(ProductionTaskOrderModel order,
      SalesProductionOrderModel saleOrder) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: Column(children: <Widget>[
        Row(children: [Text('人员设置', style: TextStyle(color: Colors.grey))]),
        buildRow('跟单员', '${order?.merchandiser?.name}'),
        buildRow('审批人',
            '${saleOrder.approvers != null ? saleOrder.approvers[0].name : ''}')
      ]),
    );
  }

  Widget _buildProductRow({double height = 83.0}) {
    return Padding(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          Hero(
              tag: 'productHero${order.code}',
              child: ImageFactory.buildThumbnailImage(order?.product?.thumbnail,
                  containerSize: height)),
          Expanded(
              child: Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.product.name,
                      style: TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '货号：${order.product.skuID}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 243, 243, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '品类：${order.product.category.name}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(255, 133, 148, 1)),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget buildRow(String title, String val) {
    if (val == null || val == '') {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
          ),
          Expanded(
              child: Text(
                '$val',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }

  /// 底部订单信息
  Widget _buildBottom(BuildContext context) {
    TextStyle _infoStyle = TextStyle(color: Colors.grey);

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 60),
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
              child: order.creationtime == null
                  ? Container()
                  : Text(
                '创建时间：${DateFormatUtil.formatYMDHMS(order.creationtime)}',
                style: _infoStyle,
              )),
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
}
