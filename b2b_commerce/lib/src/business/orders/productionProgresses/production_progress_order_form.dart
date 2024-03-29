import 'package:b2b_commerce/src/business/orders/form/purchase/ColorSizeEntry.dart';
import 'package:b2b_commerce/src/business/orders/productionProgresses/production_progress_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/ProgressColorSizeTabTable.dart';

class ProductionProgressOrderForm extends StatefulWidget {
  final PurchaseOrderModel order;

  final ProductionProgressModel progress;

  final ProductionProgressOrderModel progressOrder;

  const ProductionProgressOrderForm(
      {Key key, this.order, this.progress, this.progressOrder})
      : super(key: key);

  _ProductionProgressOrderFormState createState() =>
      _ProductionProgressOrderFormState();
}

class _ProductionProgressOrderFormState
    extends State<ProductionProgressOrderForm> {
  ProductionProgressOrderModel form;
  TextEditingController remarksController = TextEditingController();
  List<ColorSizeEntry> colorSizeEntries;

  final GlobalKey globalKey = GlobalKey();
  double tableWidth = 0;
  double tableHeight = 0;

  @override
  void initState() {
    super.initState();

    ///新建
    if (widget.progressOrder == null) {
      form = ProductionProgressOrderModel(medias: [], entries: []);
    } else {
      ///修改
      form = widget.progressOrder;
      remarksController.text = form.remarks;
    }
    colorSizeEntries = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text(
            '${ProductionProgressPhaseLocalizedMap[widget.progress.phase]}'),
        backgroundColor: Constants.THEME_COLOR_MAIN,
      ),
      body: Container(
        color: Constants.THEME_COLOR_BACKGROUND,
        child: ListView(
          children: <Widget>[
            _buildInfoBlock(),
            _buildColorSizeTabForm(),
            _buildMediasBlock(),
            _buildRemarksBlock(),
            _buildBtn()
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('上报时间：'),
              FlatButton(
                color: Colors.grey[100],
                child: Row(
                  children: <Widget>[
                    Text(
                      form.reportTime != null
                          ? '${DateFormatUtil.formatYMD(form.reportTime)}'
                          : '选择上报时间',
                    ),
                    Icon(Icons.date_range)
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () {
                  _selectDateTime();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('上报人员：'),
              FlatButton(
                color: Colors.grey[100],
                child: Row(
                  children: <Widget>[
                    Text(
                      '${UserBLoC.instance.currentUser.name}',
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () {},
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text('款号：${widget.order.product.skuID ?? ''}'),
          ),
          Text(
              '合作商：${widget.order.getCooperatorName(
                  UserBLoC.instance.currentUser.type)}')
        ],
      ),
    );
  }

  // Widget _buildTableBlock() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10),
  //     color: Colors.white,
  //     child: FlatButton(
  //       onPressed: _onEditEntries,
  //       child: Container(
  //           child: Stack(
  //         children: <Widget>[
  //           Container(
  //             key: globalKey,
  //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //             child: SingleProgressAbbreviationTable(
  //               entries: widget.order.entries,
  //               order: form,
  //             ),
  //           ),
  //           Positioned(
  //             right: 0,
  //             top: 5,
  //             child: Icon(
  //               Icons.loupe,
  //               size: 25,
  //               color: Colors.grey,
  //             ),
  //           ),
  //           FutureBuilder<BuildContext>(
  //             future: _getTableContext(),
  //             builder:
  //                 (BuildContext context, AsyncSnapshot<BuildContext> snapshot) {
  //               if (tableHeight == 0 && tableWidth == 0) {
  //                 _getTableContext();
  //                 return Container();
  //               } else {
  //                 return Container(
  //                   width: tableWidth,
  //                   height: tableHeight,
  //                   color: Color.fromRGBO(0, 0, 0, 0.2),
  //                   child: Center(
  //                       child: FlatButton(
  //                     onPressed: _onEditEntries,
  //                     child: Container(
  //                       color: Colors.white60,
  //                       padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
  //                       child: Text('编辑'),
  //                     ),
  //                   )),
  //                 );
  //               }
  //             },
  //           )
  //         ],
  //       )),
  //     ),
  //   );
  // }

  Widget _buildMediasBlock() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('上传图片：'),
          Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    EditableAttachments(
                  list: form.medias,
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
      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('备注：'),
          Expanded(
            flex: 1,
            child: TextField(
              controller: remarksController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[300], width: 0.5)),
                hintText: '输入备注',
              ),
              maxLines: 3,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: FlatButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        child: Text(
          '上报数量',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        onPressed: () {
          _onSubmit();
        },
      ),
    );
  }

  // Future<BuildContext> _getTableContext() async {
  //   Future.delayed(Duration(milliseconds: 100)).then((e) {
  //     if (globalKey.currentContext == null) {
  //       return _getTableContext();
  //     } else {
  //       tableWidth = globalKey.currentContext.size.width;

  //       tableHeight = globalKey.currentContext.size.height;
  //       return globalKey.currentContext;
  //     }
  //   });
  // }

  Widget _buildColorSizeTabForm() {
    return ProgressColorSizeTabTable(
        noteEntries: widget?.progressOrder?.entries ?? null,
        orderEntries: widget.order.entries,
        colorSizeEntries: colorSizeEntries,
        productionProgressOrders: widget.progress.productionProgressOrders);
  }

  ///选取时间
  _selectDateTime() async {
    DateTime nowTime = DateTime.now();
    DateTime dateTime = form.reportTime == null
        ? nowTime
        : form.reportTime.compareTo(nowTime) < 0 ? nowTime : form.reportTime;
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: dateTime,
        lastDate: DateTime(2999));

    setState(() {
      form.reportTime = _picked;
    });
  }

  // ///调整颜色尺码数量编辑页
  // void _onEditEntries() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => ProgressOrderFullTableForm(
  //             entries: widget.order.entries,
  //             order: form,
  //           )));
  // }

  void _onSubmit() {
    //校验
    String validateStr = '';
    if (form.reportTime == null) {
      validateStr = '请选择上报时间';
    }
    if (colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .length ==
        0) {
      validateStr = '请填写上报数量';
    }

    if (validateStr != '') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.CONFIRM_DIALOG,
              contentText2: '$validateStr',
              isNeedConfirmButton: true,
              isNeedCancelButton: false,
              confirmButtonText: '是',
              dialogHeight: 180,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.CONFIRM_DIALOG,
              contentText2: '是否确认上报?',
              isNeedConfirmButton: true,
              isNeedCancelButton: true,
              confirmButtonText: '是',
              cancelButtonText: '否',
              dialogHeight: 180,
              confirmAction: () {
                Navigator.of(context).pop();
                _create();
              },
            );
          });
    }
  }

  ///上报
  Future<void> _create() async {
    form
      ..remarks = remarksController.text
      ..operator = B2BCustomerModel(id: UserBLoC.instance.currentUser.id)
      ..entries = colorSizeEntries
          .where((entry) => entry.controller.text != '')
          .map((entry) =>
          OrderNoteEntryModel(
              color: entry.color,
              size: entry.size,
              quantity: getIntFromController(entry.controller)))
          .toList();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: widget.progressOrder == null
                ? ProgressOrderRepository()
                .createProductionProgressOrder(widget.progress.id, form)
                : ProgressOrderRepository().updateProductionProgressOrder(
                widget.progress.id, widget.progressOrder.id, form),
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
              failTips: '上报失败',
              successTips: '上报成功',
              callbackResult: result,
              confirmAction: () => jumpToDetail(int.tryParse(value)),
            );
          });
    });
  }

  int getIntFromController(TextEditingController controller) {
    if (controller.text == '') {
      return 0;
    }
    return int.tryParse(controller.text) ?? 0;
  }

  void jumpToDetail(int id) async {
    final state = Provider.of<ProductionProgressState>(context, listen: false);
    PurchaseOrderModel order = await state.refreshPurchaseOrder();
    ProductionProgressOrderModel newOrder = state
        .progress.productionProgressOrders
        .firstWhere((order) => order.id == id, orElse: () => null);
    if (newOrder != null) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProductionProgressOrderDetailPage(
                model: newOrder,
              )));
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
}
