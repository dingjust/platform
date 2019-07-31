import 'dart:async';

import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:toast/toast.dart';
import 'package:widgets/widgets.dart';

class OrderConfirmForm extends StatefulWidget {
  final ApparelProductModel product;

  List<EditApparelSizeVariantProductEntry> productEntries;

  OrderType orderType;

  ///按颜色分组
  Map<String, List<EditApparelSizeVariantProductEntry>> colorRowList;
  Map<String, TextEditingController> totalEditingControllerMap;
  TextEditingController remarksEditingController;

  OrderConfirmForm(
      {Key key,
      this.product,
      this.productEntries,
      this.colorRowList,
      this.totalEditingControllerMap,
      this.remarksEditingController,
      this.orderType})
      : super(key: key);

  @override
  _OrderConfirmFormState createState() => _OrderConfirmFormState();
}

class _OrderConfirmFormState extends State<OrderConfirmForm> {
  AddressModel addressModel;

  EdgeInsetsGeometry widgetPadding = const EdgeInsets.fromLTRB(20, 0, 20, 0);

  Map<String, List<EditApparelSizeVariantProductEntry>> colorResultList =
      Map<String, List<EditApparelSizeVariantProductEntry>>();

  //总数流
  var _streamController = StreamController<int>.broadcast();

  Stream<int> get totalNumStream => _streamController.stream;
  double imageSize = 100;
  double imageOverTop = 40;
  double imageToLeft = 20;
  double bottomSheetHeight = 50;

  //总数
  int totalNum = 0;

  ///单价
  double price = 0;

  ///订金
  double deposit = 0;

  ///生产天数
  int produceDay = 0;

  ///订金百分比
  double depositPercent = 0.3;

  ///预计交货时间
  DateTime expectedDeliveryDate = DateTime.now();

  @override
  void initState() {
    ///过滤为空的
    widget.colorRowList.forEach((color, entries) {
      List<EditApparelSizeVariantProductEntry> list = entries
          .where((entry) =>
              entry.controller.text != '' && entry.controller.text != '0')
          .toList();
      if (list != null && list.isNotEmpty) {
        colorResultList[color] = list;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //计算总数
    countTotalNum();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(255, 214, 12, 1),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '确认订单',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: _buildMainListView(),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildMainListView() {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 3),
      child: ListView(
        children: <Widget>[
          Container(
            padding: widgetPadding,
            child: AddressSection(
              height: 120,
              context: context,
              deliveryAddress: addressModel,
              onAddressChanged: _handleAddressChange,
            ),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: widgetPadding,
            child: _buildHeadRow(),
          ),
          Padding(
            padding: widgetPadding,
            child: _buildBody(),
          ),
          _buildEnd()
        ],
      ),
    );
  }

  Widget _buildHeadRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: imageSize,
            margin: EdgeInsets.only(right: 20),
            child: CachedNetworkImage(
                width: imageSize,
                height: imageSize,
                imageUrl: '${widget.product.thumbnail.previewUrl()}',
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                placeholder: (context, url) => SpinKitCircle(
                      color: Colors.black12,
                      size: imageSize,
                    ),
                errorWidget: (context, url, error) => SpinKitCircle(
                      color: Colors.black12,
                      size: imageSize,
                    )),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                height: imageSize,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${widget.product.name}',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: _buildPriceText(),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBody() {
    List<Widget> _children = [];

    colorResultList.forEach((color, entries) {
      _children.add(_buildColorBlock(entries, color));
    });

    return Column(
      children: _children,
    );
  }

  Widget _buildColorBlock(
      List<EditApparelSizeVariantProductEntry> entries, String color) {
    //色值
    String colorCode =
    entries[0].model.color.colorCode?.replaceAll(RegExp('#'), '');

    return Container(
      // margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    // margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    child: Row(
                  children: <Widget>[
                    Text(
                      '${entries[0].model.color.name}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                )),
                entries[0].model.color.colorCode != null
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Color(int.parse('0xFF${colorCode}')),
                            border: Border.all(
                                width: 0.5, color: Colors.grey[300])),
                        child: Text(''),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildViewBody(entries, color),
          )
        ],
      ),
    );
  }

  Widget _buildEnd() {
    return StreamBuilder<int>(
      initialData: totalNum,
      stream: totalNumStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Container(
          // height: 50,
          padding: widgetPadding,
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
          margin: EdgeInsets.only(bottom: bottomSheetHeight + 10),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        '备注',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: widget.remarksEditingController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '填写备注',
                            hintStyle: TextStyle(fontSize: 14)),
                      ),
                    )
                  ],
                ),
              ),
              _buildProduceDayRow(snapshot)
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewBody(
      List<EditApparelSizeVariantProductEntry> entries, String color) {
    List<Widget> widgets = entries
        .map((entry) => Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${entry.model.size.name}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          B2BIcons.remove_rect,
                          color: Colors.grey[300],
                        ),
                        onPressed: () {
                          if (int.parse(entry.controller.text) > 1) {
                            setState(() {
                              int i = int.parse(entry.controller.text);
                              i--;
                              entry.controller.text = '$i';
                            });
                          }
                        },
                      ),
                      Container(
                        width: 40,
                        child: TextField(
                          controller: entry.controller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              hintStyle: TextStyle(fontSize: 14)),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                          //只能输入数字
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val) {
                            if (val == '0') {
                              setState(() {
                                entry.controller.text = '';
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          B2BIcons.add_rect,
                          color: Colors.grey[300],
                        ),
                        onPressed: () {
                          setState(() {
                            if (entry.controller.text == '') {
                              entry.controller.text = '1';
                            } else {
                              int i = int.parse(entry.controller.text);
                              i++;
                              entry.controller.text = '$i';
                            }
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ))
        .toList();
    return Column(
      children: widgets,
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: bottomSheetHeight,
      // margin: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // _buildEnd(),
          Container(
            height: 50,
            decoration:
                BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey, //阴影颜色
                blurRadius: 5.0, //阴影大小
              ),
            ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RichText(text: _buildAmountTextSpan()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          child: FlatButton(
                            color: Color.fromRGBO(255, 214, 12, 1),
                            onPressed: onSure,
                            disabledColor: Colors.grey[300],
                            child: Text(
                              '确认下单',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  TextSpan _buildAmountTextSpan() {
    if (widget.orderType == OrderType.PURCHASE) {
      return TextSpan(
          text: '订金(总额x30%): ',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          children: <TextSpan>[
            TextSpan(text: '￥$deposit', style: TextStyle(color: Colors.red)),
          ]);
    } else if (widget.orderType == OrderType.PROOFING) {
      return TextSpan(
          text: '总额: ',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
                text: '￥${totalNum * widget.product.proofingFee}',
                style: TextStyle(color: Colors.red)),
          ]);
    } else {
      return null;
    }
  }

  Text _buildPriceText() {
    if (widget.orderType == OrderType.PURCHASE) {
      return Text(
        totalNum == 0
            ? '￥${widget.product.minSteppedPrice} ~ ￥${widget.product.maxSteppedPrice}'
            : '￥$price',
        style: TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.left,
      );
    } else if (widget.orderType == OrderType.PROOFING) {
      return Text(
        '￥${widget.product.proofingFee}',
        style: TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.left,
      );
    }
    return Text('');
  }

  Widget _buildProduceDayRow(AsyncSnapshot<int> snapshot) {
    if (widget.orderType == OrderType.PURCHASE) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: '预计生产天数：',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                      text: '${countProduceDays(snapshot.data)}',
                      style: TextStyle(color: Colors.black87, fontSize: 14)),
                ]),
          ),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: '共',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${totalNum}',
                          style: TextStyle(color: Colors.red)),
                      TextSpan(text: '件')
                    ]),
              ),
              Text(
                '￥${DoubleUtil.getDecimalsValue(snapshot.data * price, 2)}',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _handleAddressChange(AddressModel address) {
    setState(() {
      addressModel = address;
    });
  }

  int countTotalNum() {
    int i = 0;
    widget.productEntries.forEach((entry) {
      if (entry.controller.text == '') {
        i = i + 0;
      } else {
        i = i + int.parse(entry.controller.text);
      }
    });
    totalNum = i;
    //计算生产天数
    produceDay = countProduceDays(totalNum);
    //计算单价
    price = countUnitPrice(totalNum);
    deposit = DoubleUtil.getDecimalsValue(totalNum * price * depositPercent, 2);
    _streamController.sink.add(totalNum);
    return totalNum;
  }

  int countProduceDays(int totalNum) {
    //基础生产天数
    int basic = widget.product.productionDays;
    int addOnDay = 0;
    if (totalNum > widget.product.basicProduction) {
      addOnDay = ((totalNum - widget.product.basicProduction) /
              widget.product.productionIncrement)
          .ceil();
    }
    produceDay = basic + addOnDay;
    return produceDay;
  }

  double countUnitPrice(int totalNum) {
    for (int i = 0; i < widget.product.steppedPrices.length; i++) {
      if (i == widget.product.steppedPrices.length - 1) {
        if (totalNum >= widget.product.steppedPrices[i].minimumQuantity) {
          price = widget.product.steppedPrices[i].price;
          return price;
        }
      } else {
        if (totalNum >= widget.product.steppedPrices[i].minimumQuantity &&
            totalNum < widget.product.steppedPrices[i + 1].minimumQuantity) {
          price = widget.product.steppedPrices[i].price;
          return price;
        }
      }
    }
    price = widget.product.steppedPrices.first.price;
    return price;
  }

  int colorTotalNum(List<EditApparelSizeVariantProductEntry> entries) {
    int result = 0;
    entries.forEach((entry) {
      if (entry.controller.text == '') {
        result = result + 0;
      } else {
        result = result + int.parse(entry.controller.text);
      }
    });
    return result;
  }

  ///校验表单
  bool validateForm() {
    if (totalNum < widget.product.steppedPrices[0].minimumQuantity &&
        widget.orderType != OrderType.PROOFING) {
      Toast.show("未达最低采购量", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      return false;
    }
    if (addressModel == null) {
      Toast.show("请选择收货地址", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      return false;
    }
    return true;
  }

  void onSure() {
    if (validateForm()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.CONFIRM_DIALOG,
              contentText2: '是否提交订单？',
              isNeedConfirmButton: true,
              isNeedCancelButton: true,
              dialogHeight: 200,
              confirmAction: () {
                Navigator.of(context).pop();
                onSubmit();
              },
            );
          });
    }
  }

  void onSubmit() {
    switch (widget.orderType) {
      case OrderType.PROOFING:
        onProofingSubmit();
        break;
      case OrderType.PURCHASE:
        onPurchaseSubmit();
        break;
      default:
        Toast.show("未知订单类型", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  ///打样下单
  void onProofingSubmit() async {
    //拼装数据
    ProofingModel model = ProofingModel();
    model.entries = widget.productEntries.where((entry) {
      return entry.controller.text != '';
    }).map((entry) {
      ApparelSizeVariantProductModel variantProduct = entry.model;
      variantProduct
        ..thumbnail = widget.product.thumbnail
        ..thumbnails = widget.product.thumbnails
        ..images = widget.product.images;
      return ProofingEntryModel(
        quantity: int.parse(entry.controller.text),
        product: variantProduct,
      );
    }).toList();
    model
      ..unitPrice = widget.product.proofingFee
      ..totalPrice = totalNum * widget.product.proofingFee
      ..totalQuantity = totalNum
      ..deliveryAddress = addressModel
      ..remarks = widget.remarksEditingController.text;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ProofingOrderRepository()
                .proofingCreateByProduct(model, widget.product.belongTo.uid),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: '',
          );
        }).then((value) {
      print('==================$value');
      bool result = false;
      if (value != null) {
        result = true;
      }
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '下单失败',
              successTips: '下单成功',
              callbackResult: result,
              confirmAction: () {
                onPaying(value);
              },
            );
          });
    });
  }

  ///采购下单
  void onPurchaseSubmit() async {
    //拼装数据
    PurchaseOrderModel model = new PurchaseOrderModel();
    model.entries = widget.productEntries.where((entry) {
      return entry.controller.text != '';
    }).map((entry) {
      ApparelSizeVariantProductModel variantProduct = entry.model;
      variantProduct
        ..thumbnail = widget.product.thumbnail
        ..thumbnails = widget.product.thumbnails
        ..images = widget.product.images;
      return PurchaseOrderEntryModel(
        quantity: int.parse(entry.controller.text),
        product: variantProduct,
      );
    }).toList();
    model
      ..unitPrice = price
      ..totalPrice = totalNum * price
      ..totalQuantity = totalNum
      ..deposit = deposit
      ..salesApplication = SalesApplication.ONLINE
      ..machiningType = MachiningType.LABOR_AND_MATERIAL
      ..invoiceNeeded = false
      ..expectedDeliveryDate = expectedDeliveryDate
      ..deliveryAddress = addressModel
      ..remarks = widget.remarksEditingController.text;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: PurchaseOrderRepository()
                .purchaseByProduct(model, widget.product.belongTo.uid),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: '',
          );
        }).then((value) {
      bool result = false;
      if (value != null) {
        result = true;
      }
      print('=================');
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '下单失败',
              successTips: '下单成功',
              callbackResult: result,
              confirmAction: () {
                onPaying(value);
              },
            );
          });
    });
  }

  void onPaying(String code) async {
    if (code != null && code != '') {
      switch (widget.orderType) {
        case OrderType.PROOFING:
          print('$code');
          onProofingPaying(code);
          break;
        case OrderType.PURCHASE:
          print('$code');
          onPurchasePaying(code);
          break;
        default:
          print('!!!!!!!!!!!!!!!');
      }
    }
  }

  void onPurchasePaying(String code) async {
    PurchaseOrderModel detailModel =
        await PurchaseOrderRepository().getPurchaseOrderDetail(code);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => OrderPaymentPage(
                  order: detailModel,
                  paymentFor: PaymentFor.DEPOSIT,
                )),
        ModalRoute.withName('/'));
  }

  void onProofingPaying(String code) async {
    ProofingModel detailModel =
        await ProofingOrderRepository().proofingDetail(code);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => OrderPaymentPage(
                  order: detailModel,
                )),
        ModalRoute.withName('/'));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    super.dispose();
  }
}

class AddressSection extends StatelessWidget {
  final double height;

  BuildContext context;

  AddressModel deliveryAddress;

  final ValueChanged<AddressModel> onAddressChanged;

  AddressSection(
      {Key key,
      this.height,
      this.deliveryAddress,
      this.context,
      this.onAddressChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectDeliveryAddress,
      child: Container(
        height: height,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5),
        //     color: Colors.white,
        //     boxShadow: <BoxShadow>[
        //       BoxShadow(
        //         color: Colors.grey, //阴影颜色
        //         blurRadius: 5.0, //阴影大小
        //       ),
        //     ]),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[Text('收货地址')],
            ),
            Expanded(
                flex: 1,
                child: deliveryAddress == null
                    ? _buildSelectBlock()
                    : _buildInfoBlock())
          ],
        ),
      ),
    );
  }

  Widget _buildSelectBlock() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(),
            Align(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  '请选择收货地址',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.chevron_right),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          deliveryAddress == null ||
                                  deliveryAddress.fullname == null
                              ? Container()
                              : Text(deliveryAddress.fullname),
                          deliveryAddress == null ||
                                  deliveryAddress.cellphone == null
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(deliveryAddress.cellphone),
                                )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          deliveryAddress == null ||
                                  deliveryAddress.region == null ||
                                  deliveryAddress.city == null ||
                                  deliveryAddress.cityDistrict == null ||
                                  deliveryAddress.line1 == null
                              ? Container()
                              : Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                        deliveryAddress.region.name +
                                            deliveryAddress.city.name +
                                            deliveryAddress.cityDistrict.name +
                                            deliveryAddress.line1,
                                        style: TextStyle(
                                          color: Colors.black,
                                        )),
                                  ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        Icon(Icons.chevron_right),
      ],
    );
  }

  void _handleTap(AddressModel address) {
    onAddressChanged(address);
  }

  void selectDeliveryAddress() {
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAddressesPage(
                  isJumpSource: true,
                  title: '选择地址',
                )),
        //接收返回数据并处理
      ).then((value) async {
        if (value != null) {
          _handleTap(value);
        }
      });
    }
  }
}

class BodySection extends StatelessWidget {
  final ApparelProductModel product;

  final double imageSize;

  const BodySection({Key key, this.imageSize = 100, this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildImage(),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      child: CachedNetworkImage(
          width: imageSize,
          height: imageSize,
          imageUrl: '${product.thumbnail.previewUrl()}',
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) => Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
          placeholder: (context, url) => SpinKitCircle(
                color: Colors.black12,
                size: imageSize,
              ),
          errorWidget: (context, url, error) => SpinKitCircle(
                color: Colors.black12,
                size: imageSize,
              )),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
    );
  }
}

/// 订单类型
enum OrderType {
  /// 打样
  PROOFING,

  /// 采购
  PURCHASE,
}
