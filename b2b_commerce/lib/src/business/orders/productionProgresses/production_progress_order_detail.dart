import 'package:b2b_commerce/src/business/orders/productionProgresses/production_progress_order_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/progress_abbreviation_table.dart';
import 'components/progress_order_full_table.dart';

class ProductionProgressOrderDetailPage extends StatefulWidget {
  final ProductionProgressOrderModel model;

  const ProductionProgressOrderDetailPage({Key key, this.model})
      : super(key: key);

  _ProductionProgressOrderDetailPageState createState() =>
      _ProductionProgressOrderDetailPageState();
}

class _ProductionProgressOrderDetailPageState
    extends State<ProductionProgressOrderDetailPage> {
  final GlobalKey globalKey = GlobalKey();
  double tableWidth = 0;
  double tableHeight = 0;
  bool showAllOrders = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionProgressState>(
        builder: (context, ProductionProgressState state, _) =>
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0.5,
                title: Text(
                    '${ProductionProgressPhaseLocalizedMap[state.progress
                        .phase]}'),
                backgroundColor: Constants.THEME_COLOR_MAIN,
              ),
              body: Container(
                color: Constants.THEME_COLOR_BACKGROUND,
                child: ListView(
                  children: <Widget>[
                    _buildInfoBlock(state),
                    _buildTableBlock(state),
                    _buildMediasBlock(),
                    _buildRemarksBlock(),
                    _buildBtnRow(state)
                  ],
                ),
              ),
            ));
  }

  Widget _buildInfoBlock(ProductionProgressState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('单号：${widget.model.id}'),
              Text(
                state.progress.delayedDays != 0
                    ? '已延期${state.progress.delayedDays}天'
                    : '',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text('款号：${state.order.product.skuID ?? ''}'),
          ),
          Text('上报时间：${DateFormatUtil.formatYMD(widget.model.reportTime)}'),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('上报人员：${widget.model.operator.name}'),
          )
        ],
      ),
    );
  }

  Widget _buildTableBlock(ProductionProgressState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProgressOrderFullTable(
                entries: state.order.entries,
                order: widget.model,
              )));
        },
        child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  key: globalKey,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: SingleProgressAbbreviationTable(
                    entries: state.order.entries,
                    order: widget.model,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 5,
                  child: Icon(
                    Icons.loupe,
                    size: 25,
                    color: Colors.grey,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildMediasBlock() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('上传图片：'),
          Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    Attachments(
                      list: widget.model.medias,
                      width: constraints.maxWidth,
                    ),
              ))
        ],
      ),
    );
  }

  Widget _buildRemarksBlock() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('备注：'),
          Expanded(flex: 1, child: Text('${widget.model.remarks ?? ''}'))
        ],
      ),
    );
  }

  Widget _buildBtnRow(ProductionProgressState state) {
    if (UserBLoC.instance.currentUser.type != UserType.FACTORY ||
        state.order.currentPhase != state.progress.phase) {
      return Container();
    }

    return Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            widget.model.status == ProductionProgressOrderStatus.PASS
                ? Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: FlatButton(
                    color: Color.fromRGBO(255, 214, 12, 1),
                    child: Text(
                      '作废',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    onPressed: onDelete,
                  ),
                ))
                : Container(),
            Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: FlatButton(
                    color: Color.fromRGBO(255, 214, 12, 1),
                    child: Text(
                      '修改',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    onPressed: onUpdate,
                  ),
                ))
          ],
        ));
  }

  void onDelete() {
    ProductionProgressState state =
        Provider.of<ProductionProgressState>(context, listen: false);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            contentText2: '是否确认作废?',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmButtonText: '是',
            cancelButtonText: '否',
            dialogHeight: 180,
            confirmAction: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return RequestDataLoading(
                      requestCallBack: ProgressOrderRepository()
                          .deleteProductionProgressOrder(
                          state.progress.id, widget.model.id),
                      outsideDismiss: false,
                      loadingText: '上报中。。。',
                      entrance: '',
                    );
                  }).then((value) {
                bool result = false;
                if (value != null) {
                  result = true;
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return CustomizeDialog(
                          dialogType: DialogType.RESULT_DIALOG,
                          failTips: '作废失败',
                          successTips: '作废成功',
                          callbackResult: result,
                          confirmAction: _submitCallback);
                    });
              });
            },
          );
        });
  }

  void onUpdate() {
    ProductionProgressState state =
    Provider.of<ProductionProgressState>(context, listen: false);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            ProductionProgressOrderForm(
              order: state.order,
              progress: state.progress,
              progressOrder: widget.model,
            )));
  }

  void _submitCallback() async {
    ProductionProgressState state =
    Provider.of<ProductionProgressState>(context, listen: false);
    await state.refreshPurchaseOrder();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
