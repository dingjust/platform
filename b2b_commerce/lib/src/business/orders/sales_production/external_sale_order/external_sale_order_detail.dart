import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:b2b_commerce/src/business/_shared/widgets/order_contracts_info.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/cooperator_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'order_detail_btn_group.dart';
import 'order_entry_detail.dart';

///外接订单详情页
class ExternalSaleOrderDetailPage extends StatefulWidget {
  int id;

  final String titile;

  ExternalSaleOrderDetailPage(
      {Key key, @required this.id, this.titile = '外接订单明细'})
      : super(key: key);

  @override
  _ExternalSaleOrderDetailPageState createState() =>
      _ExternalSaleOrderDetailPageState();
}

class _ExternalSaleOrderDetailPageState
    extends State<ExternalSaleOrderDetailPage> {
  SalesProductionOrderModel order;

  ///是否需要回调
  bool callBackPop;

  @override
  void initState() {
    super.initState();
    callBackPop = false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesProductionOrderModel>(
      builder: (BuildContext context,
          AsyncSnapshot<SalesProductionOrderModel> snapshot) {
        if (snapshot.data != null && order != null) {
          return WillPopScope(
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('${widget.titile}'),
                  backgroundColor: Constants.THEME_COLOR_MAIN,
                  elevation: 0.5,
                ),
                body: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListView(
                    children: <Widget>[
                      _Header(
                        order: order,
                      ),
                      _EntriesInfo(
                        order: order,
                      ),
                      _MainInfo(
                        order: order,
                      ),
                      OrderContractsBlock(
                        agreements: order?.agreements,
                      ),
                      _OrderInfo(
                        order: order,
                      ),
                      //底部占位
                      Container(
                        height: 80,
                      )
                    ],
                  ),
                ),
                bottomSheet: OrderDetailBtnGroup(
                  order: order,
                  listCallback: listPageCallback,
                  detailCallback: _clearData,
                  needCallbackPop: needCallbackPop,
                ),
                resizeToAvoidBottomPadding: true,
              ),
              onWillPop: onPop);
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
  Future<SalesProductionOrderModel> _getData() async {
    if (order == null) {
      SalesProductionOrderModel detailModel =
          await ExternalSaleOrderRespository().getOrderDetail(widget.id);
      order = detailModel;
    }
    return order;
  }

  ///刷新
  void _clearData() async {
    setState(() {
      order = null;
    });
  }

  ///返回回页面刷新
  void listPageCallback() {
    Navigator.of(context).pop(true);
  }

  ///需要页面返回列表刷新
  void needCallbackPop() {
    setState(() {
      callBackPop = true;
    });
  }

  ///页面回退回调
  Future<bool> onPop() async {
    if (callBackPop) {
      Navigator.of(context).pop(true);
      return false;
    } else {
      return true;
    }
  }
}

///主要信息
class _MainInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const _MainInfo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '订单基本信息',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            buildRow(
                '合作方式', CooperationModeLocalizedMap[order.cooperationMode]),
            buildRow('是否开票', order.invoiceNeeded ? '开发票' : '不开发票'),
            buildRow('定金', _getDepositStr()),
            buildRow('创建人', order?.creator?.name),
            for (B2BCustomerModel approver in order?.approvers ?? [])
              buildRow('审批人', approver.name),
            buildRow('跟单员', order?.productionLeader?.name),
          ],
        ));
  }

  Widget buildRow(String title, String val) {
    if (val == null || val == '') {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('$title'), Text('$val')],
      ),
    );
  }

  ///定金值
  String _getDepositStr() {
    return order.payPlan.isHaveDeposit
        ? '有定金'
        : '无定金' + PayPlanTypeLocalizedMap[order.payPlan.payPlanType];
  }
}

///订单基础信息
class _OrderInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  final TextStyle _infoStyle = const TextStyle(color: Colors.grey);

  const _OrderInfo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoRow('订单编号', order.code),
              ),
              GestureDetector(
                onTap: () {
                  copyToClipboard(order.code);
                },
                child: Text(
                  '复制单号',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
              )
            ],
          ),
          _buildInfoRow(
              '创建时间', DateFormatUtil.formatYMDHMS(order.creationtime)),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildInfoRow(String title, String val) {
    if (val == '' || val == null) {
      return Container();
    } else {
      return Row(
        children: [
          Container(
            width: 80,
            child: Text(
              '$title：',
              style: _infoStyle,
              textAlign: TextAlign.justify,
            ),
          ),
          Expanded(
              child: Text(
            '$val',
            style: _infoStyle,
          ))
        ],
      );
    }
  }

  ///复制粘贴
  copyToClipboard(final String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      BotToast.showText(text: '复制到粘贴板');
    }
  }
}

///合作商信息
class _Header extends StatelessWidget {
  final SalesProductionOrderModel order;

  const _Header({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: EdgeInsets.only(bottom: 2),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(right: 5),
            child: CircleAvatar(
              backgroundImage: CooperatorHelper.getCooperatorImage(
                  order.targetCooperator, order.originCompany),
              radius: 30,
            ),
          ),
          Expanded(
              child: Text(
                '${CooperatorHelper.getCooperatorName(order.targetCooperator, order.originCompany, order.originCooperator)}',
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          )),
          Text('.${SalesProductionOrderStateLocalizedMap[order.state]}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getSalesProductionStateColor(order.state)))
        ],
      ),
    );
  }
}

///明细行
class _EntriesInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const _EntriesInfo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      margin: EdgeInsets.only(bottom: 2),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              '订单明细',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          for (ProductionTaskOrderModel e in order.taskOrderEntries ?? [])
            _buildItem(context, e)
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, ProductionTaskOrderModel entry,
      {double height = 60.0}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Material(
          color: Colors.grey[100],
          child: InkWell(
            onTap: () => onTap(context, entry),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'productHero${entry.code}',
                        child: ImageFactory.buildThumbnailImage(
                            entry?.product?.thumbnail,
                            containerSize: height),
                      ),
                      Expanded(
                        child: Container(
                          height: height,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${entry.product.name}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                      '交货时间：${DateFormatUtil.formatYMD(entry.deliveryDate)}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '货号：${entry.product.skuID}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text('￥${entry.unitPrice}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xffff1744)))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: '数量：',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                              children: [
                            TextSpan(
                                text: '${entry.quantity}',
                                style: TextStyle(color: Color(0xffff1744)))
                          ])),
                      RichText(
                          text: TextSpan(
                              text: '接单总价：',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                              children: [
                            TextSpan(
                                text:
                                    '￥${(entry.quantity * entry.unitPrice).toStringAsFixed(2)}',
                                style: TextStyle(color: Color(0xffff1744)))
                          ])),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void onTap(BuildContext context, ProductionTaskOrderModel entry) {
    if (order.auditState == AuditState.PASSED) {
      Navigator.of(context).pushNamed(
          AppRoutes.ROUTE_PRODUCTION_TASK_ORDER_DETAIL,
          arguments: entry.id);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ExternalSaleOrderEntryDetailPage(
                entry: entry,
              )));
    }
  }
}
