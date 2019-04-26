import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:b2b_commerce/src/business/orders/form/product_size_color_num.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_detail.dart';
import 'package:b2b_commerce/src/production/offline_order_input_remarks.dart';
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

  double totalPrice = 0.0;
  double sample = 0.0;
  int totalQuantity = 0;

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

      int sum = 0;
      widget.model.entries.forEach((entry) {
        sum = sum + entry.quantity;
      });
      totalQuantity = sum;
      totalPrice = sum * widget.model.unitPrice;
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('创建打样订单'),
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
        )
    );
  }

  Widget _buildCompanyInfo() {
    /// 工厂端显示
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return GestureDetector(
        onTap: () {
          //TODO跳转详细页
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.only(bottom: 15),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    widget.quoteModel.requirementOrder
                        .belongTo ==
                        null ||
                        widget.quoteModel.requirementOrder.belongTo
                            .profilePicture ==
                            null
                        ?
                    Container(
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
                    ):
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 80,
                      height: 80,
                      child: CachedNetworkImage(
                          width: 100,
                          height: 100,
                          imageUrl: '${widget.quoteModel.requirementOrder.belongTo.profilePicture.previewUrl()}',
                          fit: BoxFit.cover,
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
                              )
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          ),
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            '${widget.quoteModel.requirementOrder == null || widget.quoteModel.requirementOrder.belongTo.name == null ? '' : widget.quoteModel.requirementOrder.belongTo.name}',
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            color: Color.fromRGBO(254, 252, 235, 1),
                            child: widget.quoteModel.requirementOrder != null &&
                                    widget.quoteModel.requirementOrder
                                            .belongTo !=
                                        null &&
                                    widget.quoteModel.requirementOrder.belongTo
                                            .approvalStatus !=
                                        null &&
                                    widget.quoteModel.requirementOrder.belongTo
                                            .approvalStatus !=
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
                    ))
                  ],
                ),
              ),
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
            inputType: TextInputType.number,
            leadingText: Text('打样费',style: TextStyle(fontSize: 16,),),
            hintText: '请输入打样费',
            prefix: '￥',
            hideDivider: true,
            onChanged: (value){
              _countTotalPrice(value);
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
      margin: EdgeInsets.only(top: 3,),
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
            onChanged: (val){
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
          _onProductSelect();
        });
  }

  void _onProductSelect() async {
    ApparelProductModel selectProduct =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ApparelProductsPage(
                  isSelectOption: true,
                )));

    setState(() {
      product = selectProduct;
      productEntries = product.variants
          .map((variant) => EditApparelSizeVariantProductEntry(
              controller: TextEditingController(), model: variant))
          .toList();
    });
  }

  Widget _buildSampleNum() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top:5,bottom: 3),
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      child: InkWell(
        onTap: onSampleNumTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Wrap(
                children: <Widget>[
                  Text('样衣数量',style: TextStyle(fontSize: 16,)),
                  Text(' *',style: TextStyle(fontSize: 16,color: Colors.red,)),
                ],
              ),
            ),
            Text(
              '${totalQuantity}件',
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

  void _countTotalPrice(String value) {
    int sum = 0;
    if (widget.update) {
      sum = totalQuantity;
    } else {
      productEntries.forEach((entry) {
        print(entry.controller.text);
        if (entry.controller.text != '') {
          sum = sum + int.parse(entry.controller.text);
        }
      });
    }

    setState(() {
      totalQuantity = sum;
      totalPrice = sum * double.parse(value);
    });
  }

  void onCreate() {
    if (productEntries == null || product == null) {
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(
        SnackBar(
          content: Text('请选择产品和数量'),
          duration: Duration(seconds: 1),
        ),
      );
    } else if (totalQuantity == 0 || _unitPriceController.text == "") {
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(
        SnackBar(
          content: Text('请填写打样费'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text('确定提交？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消', style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
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
                  if(unitPrice != null && unitPrice != ''){
                    unitPrice = unitPrice.substring(unitPrice.indexOf('￥')+1,unitPrice.length);
                  }
                  model
                    ..unitPrice = double.parse(unitPrice)
                    ..totalPrice = totalPrice
                    ..totalQuantity = totalQuantity
                    ..remarks = remarks;
                  String response = await ProofingOrderRepository()
                      .proofingCreate(widget.quoteModel.code, model);
                  //TODOS:跳转到打样订单详情
                  if (response != null && response != '') {
                    //查询明细
                    ProofingModel detailModel = await ProofingOrderRepository()
                        .proofingDetail(response);

                    if (detailModel != null) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ProofingOrderDetailPage(
                                    model: detailModel,
                                  )),
                          ModalRoute.withName('/'));
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  void onUpdate() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('确定修改？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                //拼装数据
                ProofingModel model = ProofingModel();
                model
                  ..code = widget.model.code
                  ..unitPrice = double.parse(_unitPriceController.text)
                  ..totalPrice = totalPrice
                  ..remarks = remarks;
                String response =
                    await ProofingOrderRepository().proofingUpdate(model);
                //TODOS:跳转到打样订单详情
                if (response != null && response != '') {
                  //查询明细
                  ProofingModel detailModel = await ProofingOrderRepository()
                      .proofingDetail(widget.model.code);
                  if (detailModel != null) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => ProofingOrderDetailPage(
                                  model: detailModel,
                                )),
                        ModalRoute.withName('/'));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onSampleNumTap() async {
    if (widget.update) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductSizeColorNum(
                update: true,
                data: widget.model.entries
                    .map((entry) => ApparelSizeVariantProductEntry(
                        model: entry.product, quantity: entry.quantity))
                    .toList(),
              )));
    } else {
      if (productEntries != null) {
        List<EditApparelSizeVariantProductEntry> returnEntries =
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductSizeColorNum(
                      editData: productEntries,
                    )));
        if (returnEntries != null) {
          productEntries = returnEntries;
        }
      }else{
        showDialog(context: context,builder: (context){
          return AlertDialog(
            title: Text('请先选择产品'),
          );
        });
        return;
      }
    }

    int sum = 0;
    if(productEntries != null && productEntries.length > 0){
      productEntries.forEach((entry) {
        if (entry.controller.text != '') {
          sum = sum + int.parse(entry.controller.text);
        }
      });
    }

    setState(() {
      totalQuantity = sum;
      if (_unitPriceController.text != '') {
        totalPrice = sum * StringUtil.removeSymbolRMBToDouble(_unitPriceController.text);
      }
    });
  }
}

