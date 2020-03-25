import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/sale/components/input_row.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///销售订单申请退货
class ReturnFormPage extends StatefulWidget {
  final SalesOrderModel order;

  final String code;

  const ReturnFormPage(this.code, {Key key, this.order}) : super(key: key);

  @override
  _ReturnFormPageState createState() => _ReturnFormPageState();
}

class _ReturnFormPageState extends State<ReturnFormPage> {
  TextEditingController _reasonController = TextEditingController();
  FocusNode _reasonNode = FocusNode();
  List<MediaModel> medias = [];
  SalesOrderRefundType type = SalesOrderRefundType.ONLY_MONEY;

  SalesOrderModel order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesOrderModel>(
      builder: (BuildContext context, AsyncSnapshot<SalesOrderModel> snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0.5,
              title: Text(
                '申请退货',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
              child: ListView(
                children: <Widget>[_buildProductInfo(), _buildForm()],
              ),
            ),
            bottomNavigationBar: _buildBottomSheet(),
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

  ///商品信息
  Widget _buildProductInfo() {
    double contentHeight = 80;
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          children: <Widget>[
            ImageFactory.buildThumbnailImage(
                order.entries.first.product.baseProductDetail.thumbnail),
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
                                  '${order.entries.first.product
                                      .baseProductDetail.name}'))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '￥${order.totalPrice}',
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
          GestureDetector(
            onTap: () {
              _onSelect(context);
            },
            child: SaleOrderInputRow(
              label: '退货方式',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('${SalesOrderRefundTypeLocalizedMap[type]}'),
                  Row(
                    children: <Widget>[
                      Text(
                        '请选择',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        B2BIcons.double_arrow_right,
                        color: Colors.grey,
                        size: 12,
                      )
                    ],
                  )
                ],
              ),
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
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFieldComponent(
              padding: EdgeInsets.symmetric(vertical: 5),
              dividerPadding: EdgeInsets.only(),
              focusNode: _reasonNode,
              hintText: '填写原因',
              autofocus: false,
              inputType: TextInputType.text,
              textAlign: TextAlign.left,
              hideDivider: true,
              maxLines: null,
              maxLength: 120,
              controller: _reasonController,
            ),
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
              child: EditableAttachments(
                list: medias,
                maxNum: 5,
                editable: true,
              ))
        ],
      ),
    );
  }

  ///底部
  Widget _buildBottomSheet() {
    return Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                child: FlatButton(
                    color: Constants.THEME_COLOR_MAIN,
                    onPressed: _onSubmit,
                    child: Text(
                      '提交',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            )
          ],
        ));
  }

  void _onSelect(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          // height: 155,
          height: 120,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('退货方式')],
                  ),
                  GestureDetector(
                      onTap: () {
                        _onItemSelect(SalesOrderRefundType.ONLY_MONEY);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        // color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                SalesOrderRefundTypeLocalizedMap[
                                SalesOrderRefundType.ONLY_MONEY],
                                style: TextStyle(
                                    color:
                                    type == SalesOrderRefundType.ONLY_MONEY
                                        ? Constants.THEME_COLOR_MAIN
                                        : Colors.black87)),
                            Radio(
                              groupValue: type,
                              value: SalesOrderRefundType.ONLY_MONEY,
                              onChanged: _onItemSelect,
                            )
                          ],
                        ),
                      )),
                  Divider(),
                ],
              ),
            ));
  }

  void _onItemSelect(SalesOrderRefundType val) {
    setState(() {
      type = val;
    });
    Navigator.of(context).pop();
  }

  /// 查询明细
  Future<SalesOrderModel> _getData() async {
    if (order != null && order.deliveryAddress != null) {
      order = order;
    }

    if (order == null && widget.code != null) {
      SalesOrderModel detailModel =
      await SalesOrderRespository().getSalesOrderDetail(widget.code);
      order = detailModel;
    }
    return order;
  }

  void _onSubmit() {
    if (_reasonController.text == '') {
      BotToast.showText(text: '请填写退货原因');
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否确认退货？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              _submit();
            },
          );
        });
  }

  void _submit() async {
    SalesOrderRespository()
        .refundApply(SalesOrderRefundInfoModel(
        code: order.code,
        refundType: type,
        applyReason: _reasonController.text,
        applyImages: medias))
        .then((msg) {
      if (msg.resultCode == 0) {
        Navigator.of(context).pop(true);
      }
    });
  }
}
