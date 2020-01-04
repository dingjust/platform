import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/form/product_size_color_num.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_detail.dart';
import 'package:b2b_commerce/src/business/products/product_select.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProofingOrderForm extends StatefulWidget {
  QuoteModel quoteModel;
  bool update;
  ProofingModel model;
  ProofingOrderForm({this.quoteModel, this.update = false, this.model});

  _ProofingOrderFormState createState() => _ProofingOrderFormState();
}

class _ProofingOrderFormState extends State<ProofingOrderForm> {
  FocusNode _costOfSamplesFocusNode = FocusNode();
  TextEditingController _unitPriceController = TextEditingController();
  FocusNode _remarksFocusNode = FocusNode();
  TextEditingController _remarksController = TextEditingController();
  String remarks;

  GlobalKey _scaffoldKey = GlobalKey();

  double sample = 0.0;

  ApparelProductModel product;

  List<EditApparelSizeVariantProductEntry> productEntries;

  @override
  void initState() {
    if (widget.update) {
      product = ApparelProductModel();
      product
        ..thumbnail = widget.model.product.thumbnail
        ..thumbnails = widget.model.product.thumbnails
        ..images = widget.model.product.images
        ..name = widget.model.product.name
        ..code = widget.model.product.code
        ..skuID = widget.model.product.skuID
        ..price = widget.model.product.price
        ..category = widget.model.product.category;

      remarks = widget.model.remarks;
      _remarksController.text = widget.model.remarks;
      _unitPriceController.text = widget.model.unitPrice.toString();
    } else {
      if (widget.quoteModel.unitPrice != null &&
          widget.quoteModel.unitPrice >= 0) {
        _unitPriceController.text = widget.quoteModel.costOfSamples.toString();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(widget.update ? '编辑打样订单' : '创建打样订单'),
          ),
          body: Container(
              margin: EdgeInsets.only(bottom: 70),
              child: ListView(
                children: <Widget>[
                  _buildCompanyInfo(),
                  product == null ? _buildProductSelect() : _buildProduct(),
                  _buildProofingInfo(),
                ],
              )),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 50,
            child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                widget.update ? '修改订单' : '提交订单',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: widget.update ? onUpdate : onCreate,
            ),
          )),
      onWillPop: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.CONFIRM_DIALOG,
                contentText2: '正在创建订单，是否确认退出',
                isNeedConfirmButton: true,
                isNeedCancelButton: true,
                confirmButtonText: '退出',
                cancelButtonText: '再看看',
                dialogHeight: 180,
                confirmAction: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              );
            });
      },
    );
  }

  Widget _buildCompanyInfo() {
    /// 工厂端显示
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      //判断是否看款单
      BrandModel brandModel;
      if (widget.quoteModel?.requirementOrder?.belongTo != null) {
        brandModel = widget.quoteModel.requirementOrder.belongTo;
      } else if (widget.model.brandReference != null) {
        brandModel = widget.model.brandReference;
      }

      return GestureDetector(
        onTap: () {
          //TODO跳转详细页
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.only(bottom: 15),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              brandModel == null || brandModel.profilePicture == null
                  ? Container(
                margin: EdgeInsets.all(10),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        'temp/picture.png',
                        package: "assets",
                      ),
                      fit: BoxFit.cover,
                    )),
              )
                  : Container(
                margin: EdgeInsets.all(10),
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                    width: 100,
                    height: 100,
                    imageUrl: '${brandModel.profilePicture.previewUrl()}',
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                    placeholder: (context, url) =>
                        SpinKitRing(
                          color: Colors.black12,
                          lineWidth: 2,
                          size: 30,
                        ),
                    errorWidget: (context, url, error) =>
                        SpinKitRing(
                          color: Colors.black12,
                          lineWidth: 2,
                          size: 30,
                        )),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            '${widget?.quoteModel?.requirementOrder == null ||
                                brandModel.name == null ? '' : brandModel
                                .name}',
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            color: Color.fromRGBO(254, 252, 235, 1),
                            child: widget?.quoteModel?.requirementOrder !=
                                null &&
                                brandModel != null &&
                                brandModel.approvalStatus != null &&
                                brandModel.approvalStatus !=
                                    ArticleApprovalStatus.approved
                                ? Text('  已认证  ',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 133, 148, 1),
                                ))
                                : Text(
                              '  未认证  ',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 133, 148, 1),
                              ),
                            ))
                      ],
                    )),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildProofingInfo() {
    return Column(
      children: <Widget>[
        _buildSampleNum(),
        Container(
          margin: EdgeInsets.only(bottom: 3),
          color: Colors.white,
          child: TextFieldComponent(
            focusNode: _costOfSamplesFocusNode,
            controller: _unitPriceController,
            leadingText: Text(
              '打样费',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            hintText: '请输入打样费（数字）',
            prefix: '￥',
            inputFormatters: [
              DecimalInputFormat(),
            ],
            hideDivider: true,
            onChanged: (value) {
              setState(() {
                widget.model.unitPrice = _unitPriceController.text == ''
                    ? 0
                    : ClassHandleUtil.removeSymbolRMBToDouble(
                    _unitPriceController.text);
              });
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '合计',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
              ),
              Text(
                '￥${totalPrice}',
                style: TextStyle(
                    color: Color.fromRGBO(255, 68, 68, 1), fontSize: 18),
              ),
            ],
          ),
        ),
        _buildRemarks(context),
//            InputRow(
//                hasBottom: false,
//                label: '备注',
//                field: TextField(
//                  autofocus: false,
//                  textAlign: TextAlign.right,
//                  controller: _remarksController,
//                  decoration:
//                      InputDecoration(hintText: '填写', border: InputBorder.none),
//                )),
      ],
    );
  }

  //订单备注
  Widget _buildRemarks(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(
        top: 3,
      ),
      padding: EdgeInsets.all(15),
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "备注",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 5),
            dividerPadding: EdgeInsets.only(),
            focusNode: _remarksFocusNode,
            hintText: '填写',
            autofocus: false,
            inputType: TextInputType.text,
            textAlign: TextAlign.left,
            hideDivider: true,
            maxLines: null,
            maxLength: 120,
            controller: _remarksController,
            onChanged: (val) {
              remarks = _remarksController.text;
            },
          ),
        )
      ]),
    );
  }

  Widget _buildProductSelect() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        child: GestureDetector(
            child: Container(
              height: 100,
              child: Card(
                  elevation: 0,
                  color: Colors.white10,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: '产品选择/创建',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' *',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red)),
                          ]),
                    ),
                  )),
            ),
            onTap: () {
              _onProductSelect();
            }));
  }

  Widget _buildProduct() {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              ImageFactory.buildThumbnailImage(product.thumbnail),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${product != null && product.name != null ? product.name : ''}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          '货号：${product != null && product.skuID != null ? product.skuID : ''}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 243, 243, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "${product != null && product.category != null ? product.category.name : ''}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(255, 133, 148, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          if (!widget.update) {
            _onProductSelect();
          }
        });
  }

  void _onProductSelect() async {
    ApparelProductModel selectProduct = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProductSelectPage()));

    if (selectProduct != null) {
      setState(() {
        product = selectProduct;
        productEntries = product.variants
            .map((variant) => EditApparelSizeVariantProductEntry(
            controller: TextEditingController(), model: variant))
            .toList();
      });
    }
  }

  Widget _buildSampleNum() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5, bottom: 3),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: InkWell(
        onTap: onSampleNumTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Wrap(
                children: <Widget>[
                  Text('样衣数量',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Text(' *',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      )),
                ],
              ),
            ),
            Text(
              '$totalQuantity件',
              style: TextStyle(color: Colors.grey),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  double get totalPrice {
    if (_unitPriceController.text != '') {
      return totalQuantity *
          ClassHandleUtil.removeSymbolRMBToDouble(_unitPriceController.text);
    }
  }

  int get totalQuantity {
    int sum = 0;
    if (productEntries != null && productEntries.length > 0) {
      productEntries.forEach((entry) {
        if (entry.controller.text != '') {
          sum = sum + int.parse(entry.controller.text);
        }
      });
    }
    return sum;
  }

  void onCreate() {
    if (productEntries == null || product == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择产品和数量',
              callbackResult: false,
              outsideDismiss: true,
            );
          });
    } else if (_unitPriceController.text == "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请填写打样费',
              callbackResult: false,
              outsideDismiss: true,
            );
          });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.CONFIRM_DIALOG,
              contentText2: '是否保存该订单？',
              isNeedCancelButton: true,
              isNeedConfirmButton: true,
              dialogHeight: 210,
              outsideDismiss: false,
              confirmAction: () {
                Navigator.of(context).pop();
                submitSave();
              },
              cancelAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  void onUpdate() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            contentText2: '确定修改该订单吗？',
            dialogHeight: 210,
            outsideDismiss: false,
            isNeedCancelButton: true,
            isNeedConfirmButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              submitUpdate();
            },
            cancelAction: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  void submitSave() {
    //拼装数据
    ProofingModel model = ProofingModel();
    model.entries = productEntries.where((entry) {
      return entry.controller.text != '';
    }).map((entry) {
      ApparelSizeVariantProductModel variantProduct = entry.model;
      variantProduct
        ..thumbnail = product.thumbnail
        ..thumbnails = product.thumbnails
        ..images = product.images;
      return ProofingEntryModel(
        quantity: int.parse(entry.controller.text),
        product: variantProduct,
      );
    }).toList();
    String unitPrice = _unitPriceController.text;
    if (unitPrice != null && unitPrice != '') {
      unitPrice =
          unitPrice.substring(unitPrice.indexOf('￥') + 1, unitPrice.length);
    }
    model
      ..unitPrice = double.parse(unitPrice)
      ..totalPrice = totalPrice
      ..totalQuantity = totalQuantity
      ..remarks = remarks;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ProofingOrderRepository()
                .proofingCreate(widget.quoteModel.code, model),
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
              failTips: '创建打样单失败',
              successTips: '创建打样单成功',
              callbackResult: result,
              confirmAction: () {
                Navigator.of(context).pop();
                getOrderDetail(value);
              },
            );
          });
    });
  }

  void submitUpdate() {
    print(_unitPriceController.text);
    ProofingModel model = ProofingModel();
    model
      ..code = widget.model.code
      ..totalPrice = totalPrice
      ..remarks = remarks;
    if (_unitPriceController.text != null && _unitPriceController.text != '') {
      _unitPriceController.text = _unitPriceController.text.replaceAll('￥', '');
      model.unitPrice = double.parse(_unitPriceController.text);
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ProofingOrderRepository().proofingUpdate(model),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: 'proofingOrder',
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
              failTips: '修改打样单失败',
              successTips: '修改打样单成功',
              callbackResult: result,
              confirmAction: () {
                Navigator.of(context).pop();
                getOrderDetail(value);
              },
            );
          });
    });
  }

  void getOrderDetail(String code) async {
    if (code != null && code != '') {
      // ProofingModel detailModel = await ProofingOrderRepository()
      //     .proofingDetail(code);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => ProofingOrderDetailPage(code)),
          ModalRoute.withName('/'));
    }
  }

  void onSampleNumTap() async {
    print('.......................');
    if (widget.update) {
      // if (productEntries != null) {
      //   List<EditApparelSizeVariantProductEntry> returnEntries =
      //       await Navigator.of(context).push(MaterialPageRoute(
      //           builder: (context) => ProductSizeColorNum(
      //                 editData: productEntries,
      //               )));
      //   if (returnEntries != null) {
      //     productEntries = returnEntries;
      //   }
      // }
      List<EditApparelSizeVariantProductEntry> returnEntries =
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ProductSizeColorNum(
                update: true,
                data: widget.model.entries
                    .map((entry) =>
                    ApparelSizeVariantProductEntry(
                        model: entry.product, quantity: entry.quantity))
                    .toList(),
              )));

      if (returnEntries != null) {
        setState(() {
          productEntries = returnEntries;
        });
      }
    } else {
      if (productEntries != null) {
        List<EditApparelSizeVariantProductEntry> returnEntries =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductSizeColorNum(
              editData: productEntries,
            )));
        if (returnEntries != null) {
          setState(() {
            productEntries = returnEntries;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('请先选择产品'),
              );
            });
        return;
      }
    }
  }
}
