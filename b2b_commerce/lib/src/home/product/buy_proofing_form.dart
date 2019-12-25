import 'dart:async';

import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:b2b_commerce/src/home/product/order_confirm_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:toast/toast.dart';
import 'package:widgets/widgets.dart';

class BuyProofingForm extends StatefulWidget {
  final ApparelProductModel product;

  final double heightScale;

  final VoidCallback onRefresh;

  const BuyProofingForm(this.product,
      {Key key, this.heightScale = 0.75, this.onRefresh})
      : super(key: key);

  @override
  _BuyProofingFormState createState() => _BuyProofingFormState();
}

class _BuyProofingFormState extends State<BuyProofingForm> {
  List<EditApparelSizeVariantProductEntry> productEntries;

  ///按颜色分组
  Map<String, List<EditApparelSizeVariantProductEntry>> colorRowList =
      Map<String, List<EditApparelSizeVariantProductEntry>>();
  Map<String, TextEditingController> totalEditingControllerMap =
      Map<String, TextEditingController>();
  TextEditingController remarksEditingController;

  //总数流
  var _streamController = StreamController<int>.broadcast();

  Stream<int> get totalNumStream => _streamController.stream;
  List<Widget> tabs = [];
  List<Widget> views = [];
  double imageSize = 100;
  double imageOverTop = 40;
  double imageToLeft = 20;

  //总数
  int totalNum = 0;

  //输入即时刷新监听
  Function textEditControllerListener;

  @override
  void initState() {
    remarksEditingController = TextEditingController();

    //初始化监听器
    textEditControllerListener = () {
      setState(() {});
    };

    productEntries = widget.product.variants.map((variant) {
      TextEditingController controller = TextEditingController();
      //赋值监听器，即时监听用户输入
      controller.addListener(textEditControllerListener);
      return EditApparelSizeVariantProductEntry(
          controller: controller, model: variant);
    }).toList();
    if (productEntries != null) {
      productEntries.forEach((entry) {
        if (colorRowList[entry.model.color.code] == null) {
          colorRowList[entry.model.color.code] = [];
        }
        colorRowList[entry.model.color.code].add(entry);
      });
    }
    colorRowList.forEach((color, entries) {
      totalEditingControllerMap[color] = TextEditingController();
      tabs.add(_buildTab(color, entries));
      views.add(_buildViewBody(entries, color));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //计算总数
    countTotalNum();

    return GestureDetector(
        onTap: () {
          //空处理，防止关闭bottomSheet
        },
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * widget.heightScale,
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
                            padding: EdgeInsets.fromLTRB(
                                imageToLeft, 5, imageToLeft, 5),
                            child: Column(
                              children: <Widget>[
                                _buildHeadRow(),
                                _buildBody(),
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
        ));
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
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
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
                          '￥${widget.product.proofingFee}',
                          style: TextStyle(color: Colors.red, fontSize: 18),
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
          resizeToAvoidBottomInset: false,
          appBar: TabBar(
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: _buildTabs(),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            isScrollable: true,
            indicatorColor: Color.fromRGBO(255, 214, 12, 1),
          ),
          body: TabBarView(children: views),
        ),
      ),
    );
  }

  Widget _buildViewBody(
      List<EditApparelSizeVariantProductEntry> entries, String color) {
    List<Widget> widgets = entries
        .map((entry) => Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
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
                          if (int.parse(entry.controller.text) > 0) {
                            setState(() {
                              if (entry.controller.text == '1') {
                                entry.controller.text = '';
                              } else {
                                int i = int.parse(entry.controller.text);
                                i--;
                                entry.controller.text = '$i';
                              }
                            });
                          }
                        },
                      ),
                      Container(
                        width: 40,
                        child: TextField(
                          controller: entry.controller,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: '0'),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
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

    widgets.add(_buildTotal(entries, color));

    return ListView(
      children: widgets,
    );
  }

  Widget _buildTotal(
      List<EditApparelSizeVariantProductEntry> entries, String color) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '批量修改数量',
                style: TextStyle(fontSize: 14),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      B2BIcons.remove_rect,
                      color: Color.fromRGBO(255, 214, 12, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        if (int.parse(totalEditingControllerMap[color].text) >
                            0) {
                          if (totalEditingControllerMap[color].text == '1') {
                            totalEditingControllerMap[color].text = '';
                            entries.forEach((entry) {
                              entry.controller.text = '';
                            });
                          } else {
                            int i = int.parse(
                                totalEditingControllerMap[color].text);
                            i--;
                            totalEditingControllerMap[color].text = '$i';
                            entries.forEach((entry) {
                              entry.controller.text = '$i';
                            });
                          }
                        }
                      });
                    },
                  ),
                  Container(
                    width: 40,
                    child: TextField(
                      controller: totalEditingControllerMap[color],
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: '0'),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      //只能输入数字
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (val) {
                        if (val == '') {
                          val = '0';
                        }
                        setState(() {
                          entries.forEach((entry) {
                            entry.controller.text = val;
                          });
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      B2BIcons.add_rect,
                      color: Color.fromRGBO(255, 214, 12, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        if (totalEditingControllerMap[color].text == '') {
                          totalEditingControllerMap[color].text = '1';
                          entries.forEach((entry) {
                            entry.controller.text = '1';
                          });
                        } else {
                          int i =
                              int.parse(totalEditingControllerMap[color].text);
                          i++;
                          totalEditingControllerMap[color].text = '$i';
                          entries.forEach((entry) {
                            entry.controller.text = '$i';
                          });
                        }
                      });
                    },
                  )
                ],
              )
            ],
          ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamBuilder<int>(
                initialData: totalNum,
                stream: totalNumStream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return RichText(
                    text: TextSpan(
                        text: '共',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${totalNum}',
                              style: TextStyle(color: Colors.red)),
                          TextSpan(text: '件')
                        ]),
                  );
                },
              ),
              RichText(
                text: TextSpan(
                    text: '总额: ',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                          '￥${DoubleUtil.getDecimalsValue(
                              totalNum * widget.product.proofingFee, 2)}',
                          style: TextStyle(color: Colors.red)),
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
    entries[0].model.color.colorCode?.replaceAll(RegExp('#'), '');
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
                style: TextStyle(fontSize: 16),
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
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            colorTotalNum(entries) > 99
                                ? '···'
                                : '${colorTotalNum(entries)}',
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
      height: 50,
      margin: EdgeInsets.only(top: 5),
      child: FlatButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        child: Text(
          '确定',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: onSure,
      ),
    );
  }

  int countTotalNum() {
    int i = 0;
    productEntries.forEach((entry) {
      if (entry.controller.text == '') {
        i = i + 0;
      } else {
        i = i + int.parse(entry.controller.text);
      }
    });
    totalNum = i;
    _streamController.sink.add(totalNum);
    return totalNum;
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
    return totalNum > 0;
  }

  void onSure() {
    if (validateForm()) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OrderConfirmForm(
                product: widget.product,
                colorRowList: colorRowList,
                productEntries: productEntries,
                remarksEditingController: remarksEditingController,
                totalEditingControllerMap: totalEditingControllerMap,
                orderType: OrderType.PROOFING,
              )));
    } else {
      Toast.show("请输入采购量", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  void onSubmit() async {
    //拼装数据
    ProofingModel model = ProofingModel();
    model.entries = productEntries.where((entry) {
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
      ..remarks = remarksEditingController.text;
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
      ProofingModel detailModel =
          await ProofingOrderRepository().proofingDetail(code);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => OrderPaymentPage(
                    order: detailModel,
                  )),
          ModalRoute.withName('/'));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    //删除监听器
    productEntries.forEach((entry) {
      entry.controller.removeListener(textEditControllerListener);
    });
    super.dispose();
  }
}
