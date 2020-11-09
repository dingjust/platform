import 'package:b2b_commerce/src/_shared/widgets/employee_select.dart';
import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/_shared/widgets/order_contracts_info.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/production_task_order/production_task_order_entry_detail.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesProductionOrderModel>(
      builder: (BuildContext context,
          AsyncSnapshot<SalesProductionOrderModel> snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
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
                    agreements: order.agreements,
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
            bottomSheet: _BtnGroup(
              order: order,
              listCallback: listPageCallback,
              detailCallback: _getData,
            ),
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
  Future<SalesProductionOrderModel> _getData() async {
    if (order == null) {
      SalesProductionOrderModel detailModel =
          await ExternalSaleOrderRespository().getOrderDetail(widget.id);
      order = detailModel;
    }
    return order;
  }

  ///返回回页面刷新
  void listPageCallback() {
    Navigator.of(context).pop(true);
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
              backgroundImage: getImage(),
              radius: 30,
            ),
          ),
          Expanded(
              child: Text(
            '${getCoopertorName()}',
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

  String getCoopertorName() {
    String name = '';
    if (order.originCompany != null) {
      name = order.originCompany.name;
    } else {
      name = order.originCooperator.type == CooperatorType.ONLINE
          ? order.originCooperator.partner.name
          : order.originCooperator.name;
    }
    return name;
  }

  ImageProvider getImage() {
    if (order.originCompany != null &&
        order.originCompany.profilePicture != null) {
      return NetworkImage(order.originCompany.profilePicture.thumbnailUrl());
    } else {
      return AssetImage(
        'temp/picture.png',
        package: "assets",
      );
    }
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
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductionTaskOrderEntryDetailPage(
                id: entry.id,
              )));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ExternalSaleOrderEntryDetailPage(
                entry: entry,
              )));
    }
  }
}

///底部按钮组
class _BtnGroup extends StatelessWidget {
  final SalesProductionOrderModel order;

  final double height;

  ///详情页刷新回调
  final VoidCallback detailCallback;

  ///列表页刷新回调
  final VoidCallback listCallback;

  const _BtnGroup(
      {Key key,
      this.order,
      this.height = 55,
      this.detailCallback,
      this.listCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (order.state != SalesProductionOrderState.CANCELED) {
      //外接来源订单
      if (isSaleOrder &&
          (order.auditState == AuditState.NONE ||
              order.auditState == AuditState.AUDITED_FAILED) &&
          hasOrigin) {
        return _acceptBtns(context);
      }
    }

    //空
    return Container(
      height: 0,
    );
  }

  ///接单按钮
  Widget _acceptBtns(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: _onRefuse,
                    child: Text('拒单',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ))),
              )),
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: () => _onAccept(context),
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text('接单',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ))),
              ))
        ],
      ),
    );
  }

  ///接单
  void _onAccept(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EmployeeSelectPage()));
  }

  ///拒绝
  void _onRefuse() {
    BotToast.showEnhancedWidget(
        onlyOne: true,
        duration: null,
        clickClose: true,
        backgroundColor: Colors.black38,
        allowClick: false,
        toastBuilder: (cancelFunc) => AlertDialog(
              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          '确认拒绝订单?',
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(onPressed: cancelFunc, child: Text('否')),
                        FlatButton(
                          onPressed: () {
                            cancelFunc.call();
                            _resuse();
                          },
                          child: Text('是'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  ///拒单接口
  void _resuse() async {
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: false);
    BaseResponse response =
        await ExternalSaleOrderRespository().refuse(order.id);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '拒单成功');
      //订单取消返回列表页面刷新
      if (listCallback != null) {
        listCallback.call();
      }
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  ///是否审批人
  bool get isApprover {
    if (order.approvers == null || UserBLoC.instance.currentUser == null) {
      return false;
    }

    return order.approvers.any((element) =>
        element.id == UserBLoC.instance.currentUser.id ||
        element.uid == UserBLoC.instance.currentUser.uid);
  }

  ///是否创建者
  bool get isCreator {
    if (order.creator != null || UserBLoC.instance.currentUser != null) {
      return order.creator.uid == UserBLoC.instance.currentUser.uid;
    } else {
      return false;
    }
  }

  ///是否销售订单（外接订单）
  bool get isSaleOrder => order?.type == ProductionOrderType.SALES_ORDER;

  ///来源
  bool get hasOrigin =>
      order?.originCompany != null && order?.originCompany?.uid != null;
}
