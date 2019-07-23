import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class BuyPurchaseForm extends StatefulWidget {
  final ApparelProductModel product;

  const BuyPurchaseForm(this.product, {Key key}) : super(key: key);

  @override
  _BuyPurchaseFormState createState() => _BuyPurchaseFormState();
}

class _BuyPurchaseFormState extends State<BuyPurchaseForm> {
  List<EditApparelSizeVariantProductEntry> productEntries;

  ///按颜色分组
  Map<String, List<EditApparelSizeVariantProductEntry>> colorRowList =
      Map<String, List<EditApparelSizeVariantProductEntry>>();
  TextEditingController totalEditingController;
  TextEditingController remarksEditingController;
  List<Widget> tabs = [];
  List<Widget> views = [];
  double imageSize = 100;
  double imageOverTop = 40;
  double imageToLeft = 20;

  ///单价
  double price = 20.00;

  ///订金
  double deposit = 800.00;

  ///预计交货时间
  DateTime expectedDeliveryDate = DateTime.now();

  @override
  void initState() {
    totalEditingController = TextEditingController(text: '0');
    remarksEditingController = TextEditingController();

    productEntries = widget.product.variants
        .map((variant) => EditApparelSizeVariantProductEntry(
            controller: TextEditingController(text: '0'), model: variant))
        .toList();
    if (productEntries != null) {
      productEntries.forEach((entry) {
        if (colorRowList[entry.model.color.code] == null) {
          colorRowList[entry.model.color.code] = [];
        }
        colorRowList[entry.model.color.code].add(entry);
      });
    }
    colorRowList.forEach((color, entries) {
      tabs.add(_buildTab(color, entries));
      views.add(_buildViewBody(entries));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //空处理，防止关闭bottomSheet
      },
      child: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: imageOverTop),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding:
                            EdgeInsets.fromLTRB(imageToLeft, 5, imageToLeft, 5),
                        child: Column(
                          children: <Widget>[
                            _buildHeadRow(),
                            _buildBody(),
                            // _buildTotal()
                            _buildEnd(),
                          ],
                        ),
                      ),
                    ),
                    _buildSubmit()
                  ],
                )),
            _buildImageBlock()
          ],
        ),
      ),
    );
  }

  Widget _buildImageBlock() {
    return Positioned(
      top: 0,
      left: imageToLeft,
      child: Container(
        padding: EdgeInsets.all(1),
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
            placeholder: (context, url) => SpinKitRing(
                  color: Colors.black12,
                  lineWidth: 2,
                  size: imageSize,
                ),
            errorWidget: (context, url, error) => SpinKitRing(
                  color: Colors.black12,
                  lineWidth: 2,
                  size: imageSize,
                )),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
      ),
    );
  }

  Widget _buildHeadRow() {
    return Container(
        height: imageSize - imageOverTop + 15,
        padding: EdgeInsets.fromLTRB(imageToLeft + imageSize, 0, 0, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${widget.product.name}',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          '￥60.0',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  Widget _buildBody() {
    return Expanded(
      flex: 1,
      child: DefaultTabController(
        length: colorRowList.length,
        child: Scaffold(
          appBar: TabBar(
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: _buildTabs(),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            isScrollable: true,
            indicatorColor: Colors.orange,
          ),
          body: TabBarView(children: views),
        ),
      ),
    );
  }

  Widget _buildViewBody(List<EditApparelSizeVariantProductEntry> entries) {
    List<Widget> widgets = entries
        .map((entry) => Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${entry.model.size.name}'),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          B2BIcons.remove_rect,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (int.parse(entry.controller.text) > 0) {
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
                          decoration: InputDecoration(border: InputBorder.none),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          //只能输入数字
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          B2BIcons.add_rect,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            int i = int.parse(entry.controller.text);
                            i++;
                            entry.controller.text = '$i';
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ))
        .toList();

    widgets.add(_buildTotal());

    return ListView(
      children: widgets,
    );
  }

  Widget _buildTotal() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text('备注'),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: remarksEditingController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: '填写备注'),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('批量修改数量'),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      B2BIcons.remove_rect,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      if (int.parse(totalEditingController.text) > 0) {
                        setState(() {
                          int i = int.parse(totalEditingController.text);
                          i--;
                          totalEditingController.text = '$i';
                          productEntries.forEach((entry) {
                            entry.controller.text = '$i';
                          });
                        });
                      }
                    },
                  ),
                  Container(
                    width: 40,
                    child: TextField(
                      controller: totalEditingController,
                      decoration: InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      //只能输入数字
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (val) {
                        setState(() {
                          productEntries.forEach((entry) {
                            entry.controller.text = val;
                          });
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      B2BIcons.add_rect,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        int i = int.parse(totalEditingController.text);
                        i++;
                        totalEditingController.text = '$i';
                        productEntries.forEach((entry) {
                          entry.controller.text = '$i';
                        });
                      });
                    },
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: '预计生产天数：',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                          text: '3天', style: TextStyle(color: Colors.black87)),
                    ]),
              ),
              Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: '共',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${totalNum()}',
                              style: TextStyle(color: Colors.orange)),
                          TextSpan(text: '件')
                        ]),
                  ),
                  Text(
                    '￥${totalNum() * 20.00}',
                    style: TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                ],
              )
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 0.5, color: Colors.grey[300]))),
    );
  }

  Widget _buildEnd() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: '订金(总额x30%): ',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                          text: '￥800.00',
                          style: TextStyle(color: Colors.orange)),
                    ]),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 0.5, color: Colors.grey[300]))),
    );
  }

  List<Widget> _buildTabs() {
    List<Widget> result = [];
    colorRowList.forEach((color, entries) {
      result.add(_buildTab(color, entries));
    });
    return result;
  }

  Widget _buildTab(
      String color, List<EditApparelSizeVariantProductEntry> entries) {
    String colorCode =
        entries[0].model.color.colorCode.replaceAll(RegExp('#'), '');
    return Tab(
      // text: '${entries[0].model.color.name}',
      child: Container(
        width: 60,
        height: 30,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            entries[0].model.color.colorCode != null
                ? Positioned(
                    left: 0,
                    top: 12,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Color(int.parse('0xFF${colorCode}')),
                          border:
                              Border.all(width: 0.5, color: Colors.grey[300])),
                      child: Text(''),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text(
                '${entries[0].model.color.name}',
              ),
            ),
            colorTotalNum(entries) > 0
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.orangeAccent),
                        child: Center(
                          child: Text(
                            '${colorTotalNum(entries)}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )))
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Container(
      width: double.infinity,
      height: 40,
      margin: EdgeInsets.only(top: 5),
      child: FlatButton(
        color: Colors.orange,
        child: Text(
          '确定',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onSure,
      ),
    );
  }

  int totalNum() {
    int i = 0;
    productEntries.forEach((entry) {
      i = i + int.parse(entry.controller.text);
    });
    return i;
  }

  int colorTotalNum(List<EditApparelSizeVariantProductEntry> entries) {
    int result = 0;
    entries.forEach((entry) {
      result = result + int.parse(entry.controller.text);
    });
    return result;
  }

  void onSure() {
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

  void onSubmit() async {
    //拼装数据
    PurchaseOrderModel model = new PurchaseOrderModel();
    model.entries = productEntries.where((entry) {
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
      ..totalPrice = totalNum() * price
      ..totalQuantity = totalNum()
      ..deposit = deposit
      ..salesApplication = SalesApplication.ONLINE
      ..machiningType = MachiningType.LABOR_AND_MATERIAL
      ..invoiceNeeded = false
      ..expectedDeliveryDate = expectedDeliveryDate
      ..remarks = remarksEditingController.text;
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
                getOrderDetail(value);
              },
            );
          });
    });
  }

  void getOrderDetail(String code) async {
    if (code != null && code != '') {
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
  }
}
