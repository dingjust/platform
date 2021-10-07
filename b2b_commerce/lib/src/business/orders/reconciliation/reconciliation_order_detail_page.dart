import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/company_bar.dart';
import 'package:b2b_commerce/src/_shared/widgets/info/info_widgets.dart';
import 'package:b2b_commerce/src/_shared/widgets/info/order_info.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/reconciliation_order_form.dart';

///对账单详情
class ReconciliationOrderDetailPage extends StatefulWidget {
  final int id;

  ///说否需要回退刷新
  final bool needRefresh;

  const ReconciliationOrderDetailPage(
      {Key key, this.id, this.needRefresh = false})
      : super(key: key);

  @override
  _ReconciliationOrderDetailPageState createState() =>
      _ReconciliationOrderDetailPageState();
}

class _ReconciliationOrderDetailPageState
    extends State<ReconciliationOrderDetailPage> {
  FastReconciliationSheetModel order;

  ///是否需要回调刷新
  bool needRefresh = false;

  UserModel user = UserBLoC.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.needRefresh != null) {
      needRefresh = widget.needRefresh;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FastReconciliationSheetModel>(
      builder: (BuildContext context,
          AsyncSnapshot<FastReconciliationSheetModel> snapshot) {
        if (snapshot.data != null && order != null) {
          return WillPopScope(
              onWillPop: onPop,
              child: Scaffold(
                appBar: AppBarFactory.buildDefaultAppBar(
                  '对账单详情',
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          B2BIconsV2.share,
                          color: Color(0xff231815),
                        ),
                        onPressed: onShare)
                  ],
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  color: Color(0xFFF7F7F7),
                  child: ListView(
                    children: <Widget>[
                      OrderStateCard(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        val: stateStr(),
                        val2: '联系对方进行订单对账',
                      ),
                      Container(
                        margin: EdgeInsets.only(),
                        child: CooperatorBar(
                          model: order.cooperator,
                        ),
                      ),
                      _buildContact(),
                      _main(),
                      _buildAttachments(),
                      _buildRemarks(),
                      _OrderInfo(
                        order: order,
                      )
                    ],
                  ),
                ),
                bottomSheet: _bottomSheet(),
              ));
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

  Widget _buildContact() {
    String name = '';
    String phone = '';
    TextAlign textAlign = TextAlign.right;
    if (order.cooperator.partner != null) {
      name = order.cooperator.partner.contactPerson;
      phone = order.cooperator.partner.contactPhone;
    } else {
      name = order.cooperator.contactPerson;
      phone = order.cooperator.contactPhone;
    }

    return InfoCard(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            InfoRow(
              label: '联系人',
              val: '$name',
              textAlign: textAlign,
            ),
            InfoDivider(),
            InfoRow(
              label: '联系电话',
              val: '$phone',
              textAlign: textAlign,
            ),
            InfoDivider(),
            InfoRow(
              label: '类型',
              val: '${CooperatorTypeLocalizedMap[order.cooperator.type]}',
              textAlign: textAlign,
            )
          ],
        ));
  }

  ///单据
  Widget _main() {
    return InfoCard(
        child: GestureDetector(
      onTap: _onSignature,
      child: Column(children: [
        Row(
          children: [
            Text(
              '对账单',
              style: TextStyle(color: Color(0xFF999999), fontSize: 14),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                margin: EdgeInsets.only(right: 4),
                child: Image.asset(
                  'img/icons/b2b-v2/my/account@3x.png',
                  package: 'assets',
                  width: 24,
                ),
              ),
              Expanded(
                  child: Text(
                '${order.title}',
                style: TextStyle(color: Color(0xFF222222), fontSize: 14),
              ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 28),
          child: Row(
            children: [
              Text(
                '结算金额',
                style: TextStyle(color: Color(0xFF222222), fontSize: 14),
              ),
              Expanded(
                  child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                          text: '￥',
                          style:
                              TextStyle(color: Color(0xFFFF4D4F), fontSize: 10),
                          children: [
                            TextSpan(
                                text: '${order.amountPayableTotal}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold))
                          ])))
            ],
          ),
        ),
      ]),
    ));
  }

  Widget _buildRemarks(
      {TextStyle textStyle =
          const TextStyle(color: Color(0xFF222222), fontSize: 14)}) {
    return InfoCard(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Container(
            width: 96,
            child: Text('备注', style: textStyle),
          ),
          Expanded(
            child: Text(
              order.remarks != null && order.remarks != ''
                  ? '${order.remarks}'
                  : '-',
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomSheet({double height = 55}) {
    //若对账单状态为待乙方签署，且账单为线下签署则可以确认跳过
    if (needSign()) {
      //不签署确认
      if (order.otherPartyNeedSigned != null &&
          order.otherPartyNeedSigned == false) {
        return Container(
          height: height,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    height: height,
                    child: FlatButton(
                        onPressed: _onConfirm,
                        color: Color(0xFFD8D8D8),
                        child: Text('直接确认',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF222222),
                            ))),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: height,
                    child: FlatButton(
                        onPressed: _onSignature,
                        color: Constants.THEME_COLOR_MAIN,
                        child: Text('签署确认',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ))),
                  ))
            ],
          ),
        );
      }
    }

    return Container(
      height: height,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    onPressed: _onSignature,
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text('对账',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF000000),
                        ))),
              ))
        ],
      ),
    );
  }

  /// 查询明细
  Future<FastReconciliationSheetModel> _getData() async {
    if (order == null) {
      FastReconciliationSheetModel detailModel =
          await ReconciliationOrderRespository.getDetail(widget.id);
      order = detailModel;
    }
    return order;
  }

  ///页面回退回调
  Future<bool> onPop() async {
    if (needRefresh != null && needRefresh) {
      Navigator.of(context).pop(true);
      return false;
    } else {
      return true;
    }
  }

  Widget _buildAttachments() {
    return (order?.medias != null && order.medias.isNotEmpty)
        ? InfoCard(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 14),
                  child: InfoTitle('附件'),
                ),
                ImageGrid(
                  medias: order.medias,
                )
              ],
            ))
        : Container();
  }

  ///乙方确认
  void _onConfirm() {
    BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        clickClose: false,
        crossPage: false,
        backgroundColor: Colors.black38,
        toastBuilder: (cancelFunc) => AlertDialog(
              content: Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('是否不进行电子签署，直接确认对账单？'),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: FlatButton(
                                onPressed: cancelFunc, child: Text('否'))),
                        Expanded(
                            child: FlatButton(
                                onPressed: _onConfirmByPartyB,
                                child: Text('是',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ))))
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  void _onConfirmByPartyB() async {
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: false);
    BaseResponse response =
        await ReconciliationOrderRespository.confirmByPartyB(order.id);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '确认成功');
      setState(() {
        order = null;
      });
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  void onShare() {
    ShareDialog.reconciliationOrderShareDialog(context, id: widget.id);
  }

  ///审批中,或取消状态则禁用签署
  bool get signDisable =>
      order.state == FastReconciliationSheetState.PENDING_APPROVAL ||
      order.state == FastReconciliationSheetState.CANCELLED;

  ///获取最新状态
  DocSignatureModel getLast() {
    List<DocSignatureModel> datas = order.docSignatures ?? [];
    return datas.lastWhere(
            (element) => element.state != DocSignatureState.CANCELED,
        orElse: () => null);
  }

  bool needSign() {
    bool needToSign = false;
    if ([
      FastReconciliationSheetState.PENDING_A_SIGN,
      FastReconciliationSheetState.PENDING_B_SIGN
    ].contains(order.state)) {
      DocSignatureModel doc = getLast();
      UserModel user = UserBLoC.instance.currentUser;
      if (doc != null) {
        //待我签署
        if (doc.state == DocSignatureState.WAIT_PARTYA_SIGN) {
          if (user.companyCode == doc.partyA.uid) {
            needToSign = true;
          }
        } else if (doc.state == DocSignatureState.WAIT_PARTYB_SIGN) {
          if (user.companyCode == doc.partyB.uid) {
            needToSign = true;
          }
        }
      }
    }
    return needToSign;
  }

  ///状态
  String stateStr() {
    String stateStr = FastReconciliationSheetStateLocalizedMap[order.state];
    if ([
      FastReconciliationSheetState.PENDING_A_SIGN,
      FastReconciliationSheetState.PENDING_B_SIGN
    ].contains(order.state)) {
      DocSignatureModel doc = getLast();
      UserModel user = UserBLoC.instance.currentUser;
      if (doc != null) {
        //待我签署
        stateStr = '${DocSignatureStateLocalizedMap[doc.state]}';
        if (doc.state == DocSignatureState.WAIT_PARTYA_SIGN) {
          if (user.companyCode == doc.partyA.uid) {
            stateStr = '待我签署';
          } else {
            stateStr = '待对方签署';
          }
        } else if (doc.state == DocSignatureState.WAIT_PARTYB_SIGN) {
          if (user.companyCode == doc.partyB.uid) {
            stateStr = '待我签署';
          } else {
            stateStr = '待对方签署';
          }
        }
      }
    }
    return stateStr;
  }

  void _onSignature() async {
    DocSignatureModel model = getLast();
    DocSignatureHelper.open(
        context: context,
        model: model,
        disable: signDisable,
        onEdit: (nContext) => onEdit(nContext)).then((value) {
      //需要刷新
      if (value != null && value) {
        setState(() {
          order = null;
          needRefresh = true;
        });
      }
    });
  }

  ///更新
  void onEdit(BuildContext nContext) async {
    //获取详情
    Function cancelFunc =
    BotToast.showLoading(crossPage: false, clickClose: false);
    SalesProductionOrderModel salesProductionOrderModel =
    await ExternalSaleOrderRespository()
        .getOrderDetail(order.salesProductionOrder.id);

    cancelFunc.call();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(
        builder: (context) =>
            ReconciliationOrderForm(
              order: salesProductionOrderModel,
              model: order,
            )))
        .then((value) {
      setState(() {
        order = null;
        needRefresh = true;
      });
    });
  }
}

///订单基础信息
class _OrderInfo extends StatelessWidget {
  final FastReconciliationSheetModel order;

  final TextStyle _infoStyle =
  const TextStyle(color: Color(0xFF222222), fontSize: 14);

  const _OrderInfo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          _buildInfoRow(
              '订单编号',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${order.code}',
                      style: _infoStyle,
                    ),
                  ),
                  GestureDetector(
                      onTap: () => copyToClipboard(order.code),
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFEDED),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          '复制',
                          style:
                          TextStyle(color: Color(0xFFFF4D4F), fontSize: 12),
                        ),
                      ))
                ],
              )),
          InfoDivider(
            height: 28,
          ),
          _buildInfoRow(
            '创建时间',
            Text(
              '${DateFormatUtil.formatYMDHMS(order.creationtime)}',
              style: _infoStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, Widget child) {
    {
      return Container(
          child: Row(
            children: [
              Container(
                width: 86,
                child: Text(
                  '$title',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                ),
              ),
              Expanded(child: child)
            ],
          ));
    }
  }

  ///复制粘贴
  void copyToClipboard(String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      BotToast.showText(text: '复制到粘贴板');
    }
  }
}
