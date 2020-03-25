import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/sale/components/input_row.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///销售订单申请退货
class ReturnPage extends StatefulWidget {
  final SalesOrderModel order;

  const ReturnPage(this.order, {Key key}) : super(key: key);

  @override
  _ReturnPageState createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  SalesOrderRefundDetailModel model;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesOrderRefundDetailModel>(
      builder: (BuildContext context,
          AsyncSnapshot<SalesOrderRefundDetailModel> snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                brightness: Brightness.light,
                centerTitle: true,
                elevation: 0.5,
                title: Text(
                  '退货详情',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: Container(
                child: ListView(
                  children: <Widget>[_buildProductInfo(), _buildForm()],
                ),
              ),
              bottomNavigationBar: _buildBottomSheet(context));
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

  ///商品信息
  Widget _buildProductInfo() {
    double contentHeight = 80;
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          children: <Widget>[
            ImageFactory.buildThumbnailImage(
                widget.order.entries.first.product.baseProductDetail.thumbnail),
            Expanded(
                flex: 1,
                child: Container(
                  height: contentHeight,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                                  '${widget.order.entries.first.product.baseProductDetail.name}'))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '￥${widget.order.totalPrice}',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ));
  }

  ///收货人信息
  Widget _buildForm() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: <Widget>[
          SaleOrderInputRow(
            label: '退货方式',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('${SalesOrderRefundTypeLocalizedMap[model.refundType]}'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              children: <Widget>[
                Text(
                  '退货原因：',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          Container(
            child: Text('${model.applyReason}'),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              children: <Widget>[
                Text(
                  '上传凭证',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Attachments(
                list: model.applyImages ?? [],
              ))
        ],
      ),
    );
  }

  ///底部
  Widget _buildBottomSheet(BuildContext context) {
    //根据买卖方显示按钮
    UserType userType = BLoCProvider.of<UserBLoC>(context).currentUser.type;

    if (model.status == SalesOrderRefundStatus.PENDING_CONFIRM &&
        userType == UserType.FACTORY) {
      return Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  child: FlatButton(
                      color: Constants.THEME_COLOR_BACKGROUND,
                      onPressed: onRefuseRefund,
                      child: Text(
                        '拒绝退货',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      )),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  child: FlatButton(
                      color: Constants.THEME_COLOR_MAIN,
                      onPressed: onConfirmRefund,
                      child: Text(
                        '同意退货',
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  /// 查询明细
  Future<SalesOrderRefundDetailModel> _getData() async {
    if (model == null && widget.order.code != null) {
      SalesOrderRefundResponse response =
          await SalesOrderRespository().refundDetail(widget.order.code);
      if (response.data != null) {
        model = response.data;
      }
    }
    return model;
  }

  ///同意退款
  void onConfirmRefund() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否同意退款？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              confirm();
            },
          );
        });
  }

  void confirm() async {
    BaseMsg msg =
        await SalesOrderRespository().refundAudit(widget.order.code, true, '');
    if (msg != null && msg.resultCode == 0) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '同意失败',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  ///拒绝退款
  void onRefuseRefund() {
    TextEditingController inputController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.INPUTS_DIALOG,
            inputController1: inputController,
            title: '填写拒绝原因',
            focusNode1: FocusNode(),
          );
        }).then((val) {
      refuseRefund(val);
    });
  }

  void refuseRefund(String reason) async {
    BaseMsg msg = await SalesOrderRespository()
        .refundAudit(widget.order.code, false, '$reason');
    if (msg != null && msg.resultCode == 0) {
      Navigator.of(context).pop(true);
    }
  }
}
