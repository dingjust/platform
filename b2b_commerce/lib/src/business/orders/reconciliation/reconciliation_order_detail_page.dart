import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:b2b_commerce/src/business/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/business/doc/doc_signature_tag.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('对账单详情'),
                  backgroundColor: Constants.THEME_COLOR_MAIN,
                  elevation: 0.5,
                ),
                body: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListView(
                    children: <Widget>[
                      CooperatorItem(
                        model: order.cooperator,
                      ),
                      _main(),
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

  Widget _buildStateRow() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('.${FastReconciliationSheetStateLocalizedMap[order.state]}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getReconciliationOrderStateColor(order.state)))
        ],
      ),
    );
  }

  ///单据
  Widget _main() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            _buildStateRow(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('标题：')],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '${order.title ?? ''}',
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('电子对账单：')],
              ),
            ),
            _buildDocs(),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('附件：')],
              ),
            ),
            _buildAttachments(),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('备注：')],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '${order.remarks ?? ''}',
                  ))
                ],
              ),
            ),
          ],
        ));
  }

  Widget _bottomSheet({double height = 55}) {
    //若对账单状态为待乙方签署，且账单为线下签署则可以确认跳过
    if (order.state == FastReconciliationSheetState.PENDING_B_SIGN) {
      if (order.docSignatures != null && order.docSignatures.isNotEmpty) {
        if (order.docSignatures.first.signMethod ==
            SignMethodType.OFFLINE_SIGN) {
          return Container(
            height: height,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      height: height,
                      child: FlatButton(
                          onPressed: () => _onConfirm(),
                          color: Constants.THEME_COLOR_MAIN,
                          child: Text('确认账单',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ))),
                    ))
              ],
            ),
          );
        }
      }
    }

    return Container(
      height: 0,
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
        ? Row(
            children: [Expanded(child: Attachments(list: order?.medias ?? []))],
          )
        : Container();
  }

  Widget _buildDocs() {
    return Row(children: [
      for (DocSignatureModel doc in (order.docSignatures ?? [])
          .where((element) => element.state != DocSignatureState.CANCELED))
        _buildBtn(doc)
    ]);
  }

  Widget _buildBtn(DocSignatureModel model,
      {double height = 65, double width = 80}) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            DocSignatureHelper.open(
                    context: context, model: model, disable: signDisable)
                .then((value) {
              //需要刷新
              if (value != null && value) {
                setState(() {
                  order = null;
                  needRefresh = true;
                });
              }
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DocSignatureHelper.getDocTypeIcon(signMethod: model.signMethod),
              DocSignatureTag(doc: model)
            ],
          ),
        ),
      ),
    );
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
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('是否确认对账单？'),
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

  ///审批中,或取消状态则禁用签署
  bool get signDisable =>
      order.state == FastReconciliationSheetState.PENDING_APPROVAL ||
          order.state == FastReconciliationSheetState.CANCELLED;
}

///订单基础信息
class _OrderInfo extends StatelessWidget {
  final FastReconciliationSheetModel order;

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
