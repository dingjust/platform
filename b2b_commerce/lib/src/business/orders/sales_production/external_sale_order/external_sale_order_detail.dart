import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/company_bar.dart';
import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/info/contracts_info.dart';
import 'package:b2b_commerce/src/_shared/widgets/info/info_widgets.dart';
import 'package:b2b_commerce/src/_shared/widgets/info/order_info.dart';
import 'package:b2b_commerce/src/_shared/widgets/info/reconciliation_order_info.dart';
import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/_shared/widgets/order_contracts_info.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/cooperator_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/external_order_form.dart';
import 'order_detail_btn_group.dart';
import 'order_entry_detail.dart';
import 'order_payment_info.dart';

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
                appBar: AppBarFactory.buildDefaultAppBar(
                  '订单明细',
                  actions: <Widget>[
                    Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: PopupMenuButton<String>(
                        onSelected: (v) => onMenuSelect(v),
                        icon: Icon(
                          B2BIcons.more,
                          size: 5,
                        ),
                        offset: Offset(0, 50),
                        itemBuilder: (BuildContext context) =>
                            _buildPopupMenu(),
                      ),
                    )
                  ],
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  color: Color(0xFFF7F7F7),
                  child: ListView(
                    children: <Widget>[
                      OrderStateCard(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        val:
                            '${SalesProductionOrderStateLocalizedMap[order.state]}',
                        val2:
                            '${SalesProductionOrderStateDecsMap[order.state]}',
                      ),
                      CompanyBar(
                          companyModel: B2BUnitModel.fromJson(
                              CompanyModel.toJson(
                                  CooperatorHelper.getCooperator(
                                      order.originCompany, order.belongTo)))),
                      _EntriesInfo(order: order),
                      MainInfo(order: order),
                      ContractsCard(
                          agreements: order?.agreements,
                          beforeTap: recordRouteInfo),
                      ReconciliationOrderCard(
                          callback: () {
                            setState(() {
                              order = null;
                              callBackPop = true;
                            });
                          },
                          beforeTap: recordRouteInfo,
                          sheets: order.reconciliationSheetList,
                          order: order),
                      OrderPaymentInfo(order: order),
                      _OrderInfo(order: order),
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
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.refresh),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      order = null;
                    });
                  },
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

  List<PopupMenuItem<String>> _buildPopupMenu() {
    // 可编辑状态
    if ([
      SalesProductionOrderState.TO_BE_SUBMITTED,
      SalesProductionOrderState.AUDIT_REJECTED,
      SalesProductionOrderState.AUDITING
    ].contains(order.state)) {
      if ((order.recipient == AgreementRoleType.PARTYA && !isPartyA) ||
          (order.recipient == AgreementRoleType.PARTYB && isPartyA)) {
        return [_editItem(), _shareItem()];
      }
    }
    return [_shareItem()];
  }

  PopupMenuItem _editItem() {
    return PopupMenuItem<String>(
      value: 'edit',
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Icon(Icons.edit),
          ),
          Text('编辑')
        ],
      ),
    );
  }

  PopupMenuItem _shareItem() {
    return PopupMenuItem<String>(
      value: 'share',
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Icon(Icons.share),
          ),
          Text('分享')
        ],
      ),
    );
  }

  onMenuSelect(String value) async {
    switch (value) {
      case 'edit':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExternalOrderForm(model: order)));
        break;
      case 'share':
        ShareDialog.orderShareDialog(context, uniqueCode: order.uniqueCode);
        break;
      default:
    }
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

  ///来源方(我是甲方)
  bool get isPartyA {
    if (order.originCompany != null) {
      return order?.originCompany?.uid ==
          UserBLoC.instance.currentUser.companyCode;
    }
    return false;
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

  ///记录路由信息
  void recordRouteInfo() {
    ///缓存路由(签合同跳转)
    NavigatorStack.instance.setCacheRoute(CacheRouteInfo(
        route: AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS_DETAIL,
        arguments: {'id': widget.id, 'title': widget.titile}));
  }
}

///主要信息
class MainInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const MainInfo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            InfoRow(
              label: '订单总数量',
              val: '${order.totalQuantity}件',
              textAlign: TextAlign.right,
            ),
            InfoDivider(
              height: 16,
            ),
            InfoRow(
                label: '订单总金额',
                val: '￥${order.totalAmount.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 14)),
            InfoDivider(
              height: 16,
            ),
            InfoRow(
              label: '合作方式',
              val: CooperationModeLocalizedMap[order.cooperationMode],
              textAlign: TextAlign.right,
            ),
            InfoDivider(
              height: 16,
            ),
            InfoRow(
              label: '是否开票',
              val: order.invoiceNeeded ? '开发票' : '不开发票',
              textAlign: TextAlign.right,
            ),
            InfoDivider(
              height: 16,
            ),
            InfoRow(
              label: '账期',
              val: _getDepositStr(),
              textAlign: TextAlign.right,
            ),
            InfoDivider(
              height: 16,
            ),
            InfoRow(
              label: '创建人',
              val: isPartyA ? order?.sendBy?.name : order?.creator?.name,
              textAlign: TextAlign.right,
            ),
            InfoDivider(
              height: 16,
            ),
            for (B2BCustomerModel approver in isPartyA
                ? (order?.sendApprovers ?? [])
                : (order?.approvers ?? [])) ...[
              InfoRow(
                label: '审批人',
                val: approver.name,
                textAlign: TextAlign.right,
              ),
              InfoDivider(
                height: 16,
              ),
            ],
            InfoRow(
              label: '跟单员',
              val: isPartyA
                  ? order.merchandiser?.name
                  : order?.productionLeader?.name,
              textAlign: TextAlign.right,
            ),
          ],
        ));
  }

  Widget buildRow(String title, String val,
      {TextStyle valStryle = const TextStyle()}) {
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
        children: [
          Text('$title'),
          Text(
            '$val',
            style: valStryle,
          )
        ],
      ),
    );
  }

  ///定金值
  String _getDepositStr() {
    if (order.payPlan == null) {
      return '';
    }

    String depositStr = '无定金';
    if (order?.payPlan?.isHaveDeposit ?? false) {
      depositStr = '定金';
      AbstractPayPlanItemModel item = order.payPlan.payPlanItems.firstWhere(
          (element) => element.moneyType == PayMoneyType.DEPOSIT,
          orElse: () => null);
      if (item != null) {
        depositStr =
            '$depositStr(${(item.payPercent * 100).toStringAsFixed(2)}%)';
      }
    }

    return '$depositStr+' + PayPlanTypeLocalizedMap[order.payPlan.payPlanType];
  }

  ///来源方(我是甲方)
  bool get isPartyA {
    if (order.originCompany != null) {
      return order?.originCompany?.uid ==
          UserBLoC.instance.currentUser.companyCode;
    }
    return false;
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
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
      margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
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
          InfoDivider(height: 16),
          _buildInfoRow(
              '创建时间', DateFormatUtil.formatYMDHMS(order.creationtime)),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _children(context)),
    );
  }

  List<Widget> _children(BuildContext context) {
    List<Widget> results = [];
    if (order.taskOrderEntries != null)
      for (int i = 0; i < order.taskOrderEntries.length; i++) {
        results.add(_buildItem(context, order.taskOrderEntries[i]));
        if (i < order.taskOrderEntries.length - 1) {
          results.add(InfoDivider(height: 32));
        }
      }
    return results;
  }

  Widget _buildItem(BuildContext context, ProductionTaskOrderModel entry,
      {double height = 86.0}) {
    return Container(
      child: Material(
          color: Colors.white,
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
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${entry.product.name}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '货号：${entry.product.skuID}',
                                    style: TextStyle(
                                        color: Color(0xFF666666), fontSize: 14),
                                  ),
                                  // Text('￥${entry.unitPrice}',
                                  //     style: TextStyle(
                                  //         fontSize: 17,
                                  //         color: Color(0xffff1744)))
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '交货日期：${DateFormatUtil.formatYMD(entry.deliveryDate)}',
                                    style: TextStyle(
                                        color: Color(0xFF666666), fontSize: 14),
                                  )
                                ],
                              ),
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
                              text: '￥',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFFF4D4F)),
                              children: [
                            TextSpan(
                                text: '${entry.unitPrice}',
                                style: TextStyle(fontSize: 16)),
                            TextSpan(
                                text: ' x ${entry.quantity}件',
                                style: TextStyle(
                                    color: Color(0xff666666), fontSize: 14))
                          ])),
                      RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                              text: '￥',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFFF4D4F)),
                              children: [
                                TextSpan(
                                    text:
                                        '${(entry?.totalPrimeCost)?.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
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
