import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/production/offline_order_input_page.dart';
import 'package:b2b_commerce/src/production/offline_order_input_remarks.dart';
import 'package:b2b_commerce/src/production/offline_order_quantity.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionOnlineOrderFrom extends StatefulWidget {
  QuoteModel quoteModel;

  ProductionOnlineOrderFrom({@required this.quoteModel});

  _ProductionOnlineOrderFromState createState() =>
      _ProductionOnlineOrderFromState();
}

class _ProductionOnlineOrderFromState extends State<ProductionOnlineOrderFrom> {
  ApparelProductModel productModel = new ApparelProductModel();
  Map<ColorModel, List<SizeQuantityItem>> colorSizeList = Map();
  Map<ColorModel, List<SizeQuantityItem>> _items = Map();
  Map<ColorModel, List<SizeQuantityItem>> _newItems;
  Map<ColorModel, List<SizeQuantityItem>> sizeQuantityList;
  List<MediaModel> mediaList = new List();
  int _totalQuantity;
  String price;
  String earnestMoney;
  MachiningType machiningType;
  bool isInvoice;
  String remarks;
  ApparelProductModel _product;
  PurchaseOrderModel purchaseOrder = new PurchaseOrderModel();
  double totalPrice;

  @override
  void initState() {
    _product = productModel;
//    if (widget.quoteModel.attachments != null) {
//      mediaList = widget.quoteModel.attachments;
//    } else {
//      mediaList = [];
//    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建生产订单'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: ListView(
        children: <Widget>[
          _buildBrandInfo(context),
          productModel == null || productModel.name == null
              ? _buildSelectionProduct(context)
              : _buildProduct(context),
          _buildProcessCount(context),
          _buildExpectPrice(context),
          _buildEarnestMoney(context),
          _buildDeliveryDate(context),
          _buildCooperationModes(context),
          _buildInvoice(context),
          _buildAnnex(context),
          _buildRemarks(context),
          _buildCommitButton(context),
        ],
      ),
    );
  }

  Widget _buildBrandInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: widget.quoteModel.requirementOrder.belongTo == null ||
                            widget.quoteModel.requirementOrder.belongTo.profilePicture == null
                            ? AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        )
                            : NetworkImage(
                            '${widget.quoteModel.requirementOrder.belongTo.profilePicture.actualUrl}'),
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            '${widget.quoteModel.requirementOrder == null || widget.quoteModel.requirementOrder.belongTo.name == null ?
                            '' : widget.quoteModel.requirementOrder.belongTo.name}',
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            color: Color.fromRGBO(254, 252, 235, 1),
                            child: widget.quoteModel.requirementOrder != null && widget.quoteModel.requirementOrder.belongTo != null &&
                                widget.quoteModel.requirementOrder.belongTo.approvalStatus != null
                                && widget.quoteModel.requirementOrder.belongTo.approvalStatus != ArticleApprovalStatus.approved
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
    );
  }

  Widget _buildSelectionProduct(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: GestureDetector(
          child: Container(
            height: 100,
            child: Card(
                elevation: 0,
                color: Colors.white10,
                child: Center(child: RichText(
                  text: TextSpan(
                      text: '产品选择/创建',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red)
                        ),
                      ]),
                ),)),
          ),
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductsPage(
                      isSelectOption: true,
                      item: _product,
                    ),
              ),
            );
            if (result != null) {
              productModel = result;

              if (productModel.variants != null) {
                List<ColorModel> colors = List();
                List<SizeModel> sizes = List();
                //把每个款的颜色记录下,并去重
                for (int i = 0; i < productModel.variants.length; i++) {
                  colors.add(productModel.variants[i].color);
                }
                for (int i = 0; i < colors.length - 1; i++) {
                  for (int j = colors.length - 1; j > i; j--) {
                    if (colors[j].code.contains(colors[i].code)) {
                      colors.removeAt(j);
                    }
                  }
                }

                //尺码
                for (int i = 0; i < productModel.variants.length; i++) {
                  sizes.add(productModel.variants[i].size);
                }
                for (int i = 0; i < sizes.length - 1; i++) {
                  for (int j = sizes.length - 1; j > i; j--) {
                    if (sizes[j].code.contains(sizes[i].code)) {
                      sizes.removeAt(j);
                    }
                  }
                }

                _newItems = Map.from(_items);
                _items.clear();
                _newItems.clear();
                _totalQuantity = 0;

                colors.forEach((color) {
                  ColorModel itemColor = _newItems.keys.firstWhere(
                      (key) => key.code == color.code,
                      orElse: () => null);

                  if (itemColor != null) {
                    _items[itemColor] = sizes.map((size) {
                      SizeQuantityItem item = _newItems[itemColor].firstWhere(
                          (SizeQuantityItem) =>
                              SizeQuantityItem.size.code == size.code,
                          orElse: () => null);
                      if (item != null) {
                        return item;
                      } else {
                        return SizeQuantityItem(size: size);
                      }
                    }).toList();
                  } else {
                    _items[color] = sizes
                        .map((size) => SizeQuantityItem(size: size))
                        .toList();
                  }
                });
              }
            }
          }),
    );
  }

  Widget _buildProduct(BuildContext context) {
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
                      image: productModel.thumbnail != null
                          ? NetworkImage(
                              '${productModel.thumbnail.actualUrl}')
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
                        '${productModel != null && productModel.name != null ? productModel.name : ''}',
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
                          '货号：${productModel != null && productModel.skuID != null ? productModel.skuID : ''}',
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
                          "${productModel != null && productModel.category != null ? productModel.category.name : ''}",
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
          dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApparelProductsPage(
                    isSelectOption: true,
                    item: _product,
                  ),
            ),
          );
          if (result != null) {
            productModel = result;

            if (productModel.variants != null) {
              List<ColorModel> colors = List();
              List<SizeModel> sizes = List();
              //把每个款的颜色记录下,并去重
              for (int i = 0; i < productModel.variants.length; i++) {
                colors.add(productModel.variants[i].color);
              }
              for (int i = 0; i < colors.length - 1; i++) {
                for (int j = colors.length - 1; j > i; j--) {
                  if (colors[j].code.contains(colors[i].code)) {
                    colors.removeAt(j);
                  }
                }
              }

              //尺码
              for (int i = 0; i < productModel.variants.length; i++) {
                sizes.add(productModel.variants[i].size);
              }
              for (int i = 0; i < sizes.length - 1; i++) {
                for (int j = sizes.length - 1; j > i; j--) {
                  if (sizes[j].code.contains(sizes[i].code)) {
                    sizes.removeAt(j);
                  }
                }
              }

              _newItems = Map.from(_items);
              _items.clear();
              _newItems.clear();
              _totalQuantity = 0;

              colors.forEach((color) {
                ColorModel itemColor = _newItems.keys.firstWhere(
                    (key) => key.code == color.code,
                    orElse: () => null);

                if (itemColor != null) {
                  _items[itemColor] = sizes.map((size) {
                    SizeQuantityItem item = _newItems[itemColor].firstWhere(
                        (SizeQuantityItem) =>
                            SizeQuantityItem.size.code == size.code,
                        orElse: () => null);
                    if (item != null) {
                      return item;
                    } else {
                      return SizeQuantityItem(size: size);
                    }
                  }).toList();
                } else {
                  _items[color] = sizes
                      .map((size) => SizeQuantityItem(size: size))
                      .toList();
                }
              });
            }
          }
        });
  }

  //生产数量
  Widget _buildProcessCount(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          child: ListTile(
            leading: RichText(
              text: TextSpan(
                  text: '生产数量',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' *',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)
                    ),
                  ]),
            ),
            trailing: _totalQuantity == null || _totalQuantity < 0
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
                    _totalQuantity.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OfflineOrderQuantityInputPage(
                    items: _items,
                  ),
            ),
          ).then((result) {
            if (result != null) _items = result;
            setState(() {
              _totalQuantity = 0;
              _items.forEach((color, items) {
                items.forEach((item) {
                  _totalQuantity += int.parse(item.quantityController.text == ''
                      ? '0'
                      : item.quantityController.text);
                });
              });
              if(price != null && price != ''){
                totalPrice = double.parse(price) * _totalQuantity;
              }else if(price == null && widget.quoteModel != null && widget.quoteModel.unitPrice != null){
                totalPrice = widget.quoteModel.unitPrice * _totalQuantity;
              }

            });
          });

        });
  }

  //价格
  Widget _buildExpectPrice(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 3),
      child: Column(
        children: <Widget>[
          GestureDetector(
              child: Container(
                child: ListTile(
                  leading: RichText(
                    text: TextSpan(
                        text: '生产单价',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' *',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red)
                          ),
                        ]),
                  ),
                  trailing: widget.quoteModel == null || widget.quoteModel.unitPrice == null
                      ? Icon(Icons.keyboard_arrow_right)
                      : Text(
                          '￥${widget.quoteModel.unitPrice}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OfflineOrderInputPage(
                          fieldText: '生产单价', inputType: TextInputType.number)),
                  //接收返回数据并处理
                ).then((value) {
                  setState(() {
                    price = value;
                    widget.quoteModel.unitPrice = double.parse(price);
                    totalPrice = double.parse(price) * _totalQuantity;
                  });
                });
              }),
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text('合计：',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                ),
                Container(
                  child: Text('￥ ${totalPrice == null ? '' : totalPrice}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.red)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //定金
  Widget _buildEarnestMoney(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 3),
          child: ListTile(
            leading: RichText(
              text: TextSpan(
                  text: '定金',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' *',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)
                    ),
                  ]),
            ),
            trailing: earnestMoney == null || earnestMoney == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
                    '￥${earnestMoney}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderInputPage(
                    fieldText: '定金', inputType: TextInputType.number)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              earnestMoney = value;
            });
          });
        });
  }

  //预计交货时间
  Widget _buildDeliveryDate(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 3),
          child: ListTile(
            leading: Text(
              '预计交货时间',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: widget.quoteModel == null || widget.quoteModel.expectedDeliveryDate == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              '${DateFormatUtil.formatYMD(widget.quoteModel.expectedDeliveryDate)}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        );
  }

  //合作方式
  Widget _buildCooperationModes(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 3),
          child: ListTile(
            leading: RichText(
              text: TextSpan(
                  text: '合作方式',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' *',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)
                    ),
                  ]),
            ),
            trailing: machiningType == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
                    MachiningTypeLocalizedMap[machiningType],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
          ),
        ),
        onTap: () {
          _showTypeSelect();
        });
  }

//是否开具发票
  Widget _buildInvoice(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 3),
          child: ListTile(
            leading: RichText(
              text: TextSpan(
                  text: '是否开具发票',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' *',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)
                    ),
                  ]),
            ),
            trailing: isInvoice == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
                    isInvoice == true ? '开发票' : '不开发票',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
          ),
        ),
        onTap: () {
          _showIsInvoiceSelect();
        });
  }

  //附件
  Widget _buildAnnex(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
          EditableAttachments(list: mediaList)
        ],
      ),
    );
  }

  //订单备注
  Widget _buildRemarks(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 3),
          child: ListTile(
              leading: Text(
                '订单备注',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: remarks == null || remarks == ''
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container(
                      width: 150,
                      child: Text(
                        remarks,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    )),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderInputRemarksPage(
                    fieldText: '订单备注', inputType: TextInputType.text,content: remarks,)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              remarks = value;
            });
          });
        });
  }

  Widget _buildCommitButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '提交订单',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  onPressed: onSubmit)),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 242, 242, 1),
      ),
    );
  }

  //合作方式
  void _showTypeSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('清加工'),
                  onTap: () async {
                    setState(() {
                      machiningType = MachiningType.LIGHT_PROCESSING;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('包工包料'),
                  onTap: () async {
                    setState(() {
                      machiningType = MachiningType.LABOR_AND_MATERIAL;
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //是否开具发票选项
  void _showIsInvoiceSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('开发票'),
                  onTap: () async {
                    setState(() {
                      isInvoice = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不开发票'),
                  onTap: () async {
                    setState(() {
                      isInvoice = false;
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  void onSubmit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('确定提交？'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                  '确定',
                style: TextStyle(
                  color:Colors.black
                ),
              ),
              onPressed: onSure,
            ),
          ],
        );
      },
    );
  }

  void onSure() async {
    bool isSubmit = false;
    List<PurchaseOrderEntryModel> entries = new List();
    purchaseOrder.purchaser = widget.quoteModel.requirementOrder.belongTo;
    //加工方式
    purchaseOrder.machiningType = machiningType;
    //是否需要发票
    purchaseOrder.invoiceNeeded = isInvoice;
    //生产总数
    purchaseOrder.totalQuantity = _totalQuantity;
    //备注
    purchaseOrder.remarks = remarks;
    //附件
    purchaseOrder.attachments = mediaList;
    //预计交货时间
    purchaseOrder.expectedDeliveryDate = widget.quoteModel.expectedDeliveryDate;
    //添加订单行
    if (productModel != null &&
        productModel.variants != null &&
        productModel.variants.length > 0) {
      for (int i = 0; i < productModel.variants.length; i++) {
        PurchaseOrderEntryModel entryModel = new PurchaseOrderEntryModel();
        entryModel.product = productModel.variants[i];
        entryModel.product.thumbnail = productModel.thumbnail;
        entryModel.product.thumbnails = productModel.thumbnails;
        entryModel.product.images = productModel.images;
        _items.forEach((color, items) {
          items.forEach((item) {
            if (productModel.variants[i].color.code == color.code &&
                productModel.variants[i].size.code == item.size.code) {
              entryModel.quantity = int.parse(item.quantityController.text == ''
                  ? '0'
                  : item.quantityController.text);
            }
          });
        });
        entries.add(entryModel);
      }
    }

    //单价
    if (price != null) {
      purchaseOrder.unitPrice = double.parse(price);
    }else{
      purchaseOrder.unitPrice = widget.quoteModel.unitPrice;
    }
    purchaseOrder.entries = entries;

    if (earnestMoney != null) {
      //定金
      purchaseOrder.deposit = double.parse(earnestMoney);
    }
    purchaseOrder.salesApplication = SalesApplication.ONLINE;

    try {
      //非空验证
      if(purchaseOrder.entries == null || purchaseOrder.entries.length <= 0){
        isSubmit = _showValidateMsg(context, '请选择产品');
      }
      else if(purchaseOrder.totalQuantity == null || purchaseOrder.totalQuantity <= 0){
        isSubmit = _showValidateMsg(context, '请输入生产数量');
      }
      else if(purchaseOrder.unitPrice == null || purchaseOrder.unitPrice <= 0){
        isSubmit = _showValidateMsg(context, '请输入生产单价');
      }
      else if(purchaseOrder.deposit == null || purchaseOrder.deposit <= 0){
        isSubmit = _showValidateMsg(context, '请输入定金');
      }
      else if(purchaseOrder.machiningType == null){
        isSubmit = _showValidateMsg(context, '请选择合作方式');
      }
      else if(purchaseOrder.invoiceNeeded == null){
        isSubmit = _showValidateMsg(context, '请选择是否开具发票');
      }else{
        isSubmit = true;
      }

      if(isSubmit){
        String response = await PurchaseOrderRepository()
            .onlinePurchaseOrder(widget.quoteModel.code, purchaseOrder);
        if (response != null && response != '') {
          //根据code查询明
          PurchaseOrderModel model =
          await PurchaseOrderRepository().getPurchaseOrderDetail(response);
          if (model != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => PurchaseOrderDetailPage(
                      order: model,
                    )),
                ModalRoute.withName('/'));
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //非空提示
  bool _showValidateMsg(BuildContext context,String message){
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context,String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text('提示',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('${message}'),
            ),
          ],
        );
      },
    );
  }
}
