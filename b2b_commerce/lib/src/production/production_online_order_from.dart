import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/production/offline_order_quantity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  FocusNode _priceFocusNode = FocusNode();
  TextEditingController _priceController = TextEditingController();
  FocusNode _earnestMoneyFocusNode = FocusNode();
  TextEditingController _earnestMoneyController = TextEditingController();
  FocusNode _remarksFocusNode = FocusNode();
  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    _product = productModel;
    price = widget.quoteModel.unitPrice.toString();
//    if (widget.quoteModel.attachments != null) {
//      mediaList = widget.quoteModel.attachments;
//    } else {
//      mediaList = [];
//    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('创建生产订单'),
          centerTitle: true,
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: (){
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
                        confirmAction: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              }
          ),
        ),
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
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
//          _buildCommitButton(context),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          height: 50,
          child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '提交订单',
                style: TextStyle(
                  color: Colors.black,

                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () async {
                onSure();
              }),
        ),
      ),
      onWillPop: (){
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
                confirmAction: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              );
            }
        );
      },
    );
  }

  Widget _buildBrandInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                widget.quoteModel.requirementOrder.belongTo == null ||
                    widget.quoteModel.requirementOrder.belongTo.profilePicture == null?
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image:AssetImage(
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
                          
                          color: Colors.black
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                fontSize: 16,
                                
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
              productModel.thumbnail != null?
              Container(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                    imageUrl: '${productModel.thumbnail.previewUrl()}',
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
              ):
              Container(
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
            leading: Wrap(
              children: <Widget>[
                Text('生产数量',style: TextStyle(fontSize: 16,)),
                Text(' *',style: TextStyle(fontSize: 16,color: Colors.red,)),
              ],
            ),
            trailing: _totalQuantity == null || _totalQuantity <= 0
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
                    _totalQuantity.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        
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
    _priceController.text = price;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 3),
      child: Column(
        children: <Widget>[
          TextFieldComponent(
            focusNode: _priceFocusNode,
            controller: _priceController,
            leadingText: Text('订单报价',style: TextStyle(fontSize: 16,),),
            hideDivider: true,
            prefix: '￥',
            inputFormatters: [
              DecimalInputFormat(),
            ],
            isRequired: true,
            onChanged: (value){
              setState(() {
                price = value;
                totalPrice = double.parse(price) * _totalQuantity;
              });
            },
          ),
          Container(
            padding: EdgeInsets.only(right: 20,top: 15,bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text('合计：',
                      style: TextStyle(
                          fontSize: 16,
                          
                          color: Colors.grey)),
                ),
                Container(
                  child: Text(totalPrice == null ? '${0.00}' : '￥ ${totalPrice}',
                      style: TextStyle(
                          fontSize: 20,
                          
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
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 3),
      child: TextFieldComponent(
        focusNode: _earnestMoneyFocusNode,
        controller: _earnestMoneyController,
        leadingText: Text('定金',style: TextStyle(fontSize: 16,),),
        hintText: '请输入定金（数字）',
        hideDivider: true,
        prefix: '￥',
        inputFormatters: [
          DecimalInputFormat(),
        ],
        isRequired: true,
        onChanged: (value){
          setState(() {
            earnestMoney = value;
          });
        },
      ),
    );
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
                
              ),
            ),
            trailing: widget.quoteModel == null || widget.quoteModel.expectedDeliveryDate == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              '${DateFormatUtil.formatYMD(widget.quoteModel.expectedDeliveryDate)}',
              style: TextStyle(
                  fontSize: 16,
                  
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
            leading: Wrap(
              children: <Widget>[
                Text('合作方式',style: TextStyle(fontSize: 16,)),
                Text(' *',style: TextStyle(fontSize: 16,color: Colors.red,)),
              ],
            ),
            trailing: machiningType == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
                    MachiningTypeLocalizedMap[machiningType],
                    style: TextStyle(
                        fontSize: 16,
                        
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
            leading: Wrap(
              children: <Widget>[
                Text('是否开具发票',style: TextStyle(fontSize: 16,)),
                Text(' *',style: TextStyle(fontSize: 16,color: Colors.red,)),
              ],
            ),
            trailing: isInvoice == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
                    isInvoice == true ? '开发票' : '不开发票',
                    style: TextStyle(
                        fontSize: 16,
                        
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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
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
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
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

  Widget _buildCommitButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '提交订单',
                    style: TextStyle(
                      color: Colors.black,
                      
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: onSure)),
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
      else if(purchaseOrder.unitPrice == null || purchaseOrder.unitPrice < 0){
        isSubmit = _showValidateMsg(context, '请输入订单报价');
      }
      else if(purchaseOrder.deposit == null || purchaseOrder.deposit < 0){
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
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.CONFIRM_DIALOG,
                contentText2: '是否提交？',
                isNeedConfirmButton: true,
                isNeedCancelButton: true,
                dialogHeight: 200,
                confirmAction: (){
                  Navigator.of(context).pop();
                  onSubmit(purchaseOrder);
                },
              );
            }
        );


      }
    } catch (e) {
      print(e);
    }
  }

  void onSubmit(PurchaseOrderModel purchaseOrder) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: PurchaseOrderRepository()
                .onlinePurchaseOrder(widget.quoteModel.code, purchaseOrder),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: 'createPurchaseOrder',
          );
        }
    ).then((value){
      bool result = false;
      if(value!=null){
        result = true;
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '创建生产订单失败',
              successTips: '创建生产订单成功',
              callbackResult: result,
              confirmAction: (){
                Navigator.of(context).pop();
                getPurchaseOrderDetail(value);
              },
            );
          }
      );

    });
  }



  void getPurchaseOrderDetail(String code) async{
    if(code != null && code != ''){
      PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(code);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              PurchaseOrderDetailPage(order: model)
          ), ModalRoute.withName('/'));
    }

  }

  //非空提示
  bool _showValidateMsg(BuildContext context,String message){
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context,String message) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            outsideDismiss: true,
          );
        }
    );
  }
}
