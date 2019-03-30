import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:b2b_commerce/src/business/orders/form/product_size_color_num.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_detail.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_item.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _unitPriceController = TextEditingController();

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
        _unitPriceController.text = widget.quoteModel.unitPrice.toString();
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
            color: Color.fromRGBO(245, 245, 245, 1),
            margin: EdgeInsets.only(bottom: 70),
            child: ListView(
              children: <Widget>[
                _buildCompanyInfo(),
                product == null ?
                _buildProductSelect()
                :_buildProduct(),
                _buildProofingInfo(),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          icon: Container(
            width: 0,
            child: Icon(
              null,
              color: Colors.white,
            ),
          ),
          label: Container(
              width: 300,
              child: Center(
                child: Text(
                  widget.update ? '修改订单' : '提交订单',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              )),
          onPressed: widget.update ? onUpdate : onCreate,
          backgroundColor: Colors.amberAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget
                                              .quoteModel
                                              .requirementOrder
                                              .belongTo
                                              ?.profilePicture !=
                                          null
                                      ? '${GlobalConfigs.IMAGE_BASIC_URL}${widget.quoteModel.requirementOrder.belongTo.profilePicture.url}'
                                      : 'http://img.jituwang.com/uploads/allimg/150305/258852-150305121F483.jpg')),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.quoteModel.requirementOrder.belongTo?.name}',
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 38, 41, 1)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(229, 242, 255, 1),
                                ),
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  '已认证',
                                  style: TextStyle(
                                      color: Color.fromRGBO(22, 141, 255, 1)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 35,
                      color: Color.fromRGBO(180, 180, 180, 1),
                    )
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
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            _buildSampleNum(),
            InputRow(
                label: '打样费',
                field: TextField(
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  controller: _unitPriceController,
                  onChanged: (value) {
                    _countTotalPrice(value);
                  },
                  //只能输入数字
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration:
                      InputDecoration(hintText: '填写', border: InputBorder.none),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.5,
                          color: Color.fromRGBO(200, 200, 200, 1)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
            InputRow(
                hasBottom: false,
                label: '备注',
                field: TextField(
                  autofocus: false,
                  textAlign: TextAlign.right,
                  controller: _remarksController,
                  decoration:
                      InputDecoration(hintText: '填写', border: InputBorder.none),
                )),
          ],
        ));
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
                  child: Center(child: Text('商品选择/创建'))),
            ),
            onTap: () {
              _onProductSelect();
            }
        )
    );
  }

  Widget _buildProduct() {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: product.thumbnail != null
                          ? NetworkImage(
                          '${GlobalConfigs.IMAGE_BASIC_URL}${product.thumbnail.url}')
                          : AssetImage(
                        'temp/picture.png',
                        package: "assets",
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
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
        }
    );
  }

//  Widget _buildProductSelect() {
//    return GestureDetector(
//      onTap: _onProductSelect,
//      child: Container(
//        width: double.infinity,
//        padding: EdgeInsets.symmetric(vertical: 30),
//        color: Colors.white,
//        child: product == null
//            ? Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text(
//                    '商品选择/创建',
//                    style: TextStyle(fontSize: 20),
//                  ),
//                  Icon(
//                    Icons.chevron_right,
//                    size: 35,
//                    color: Color.fromRGBO(180, 180, 180, 1),
//                  )
//                ],
//              )
//            : Column(
//                children: <Widget>[
//                  ApparelProductItem(
//                    product,
//                    isRequirement: false,
//                    isSelectItem: true,
//                  ),
//                  widget.update
//                      ? Container()
//                      : FlatButton(
//                          onPressed: _onProductSelect,
//                          child: Text('重新选择'),
//                        )
//                ],
//              ),
//      ),
//    );
//  }

  void _onProductSelect() async {
    ApparelProductModel selectProduct =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ApparelProductsPage(
                  isRequirement: true,
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
    if (product != null) {
      return GestureDetector(
        onTap: onSampleNumTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  '样衣数量',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                ),
              ),
              Text(
                '${totalQuantity}件',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.chevron_right,
                size: 35,
                color: Color.fromRGBO(180, 180, 180, 1),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
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
          content: Text('请选择商品和数量'),
          duration: Duration(seconds: 1),
        ),
      );
    } else if (totalQuantity == 0) {
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
                child: Text('取消',
                    style: TextStyle(
                        color: Colors.grey
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('确定',
                style: TextStyle(
                  color: Colors.black
                ),),
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
                  model
                    ..unitPrice = double.parse(_unitPriceController.text)
                    ..totalPrice = totalPrice
                    ..totalQuantity = totalQuantity
                    ..remarks = _remarksController.text;
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
              child: Text('取消',
                  style: TextStyle(
                      color: Colors.grey
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定',
                  style: TextStyle(
                  color: Colors.black
                  )
              ),
              onPressed: () async {
                //拼装数据
                ProofingModel model = ProofingModel();
                model
                  ..code = widget.model.code
                  ..unitPrice = double.parse(_unitPriceController.text)
                  ..totalPrice = totalPrice
                  ..remarks = _remarksController.text;
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
      List<EditApparelSizeVariantProductEntry> returnEntries =
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductSizeColorNum(
                    editData: productEntries,
                  )));
      if (returnEntries != null) {
        productEntries = returnEntries;
      }
    }

    int sum = 0;
    productEntries.forEach((entry) {
      if (entry.controller.text != '') {
        sum = sum + int.parse(entry.controller.text);
      }
    });
    setState(() {
      totalQuantity = sum;
      if (_unitPriceController.text != '') {
        totalPrice = sum * double.parse(_unitPriceController.text);
      }
    });
  }
}

class InputRow extends StatelessWidget {
  final String label;

  final TextField field;

  final bool hasBottom;

  const InputRow(
      {Key key,
      @required this.label,
      @required this.field,
      this.hasBottom = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          border: hasBottom
              ? Border(
                  bottom: BorderSide(
                      width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))
              : Border()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            margin: EdgeInsets.only(right: 20),
            child: Text(
              label,
              style:
                  TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: field,
          )
        ],
      ),
    );
  }
}
