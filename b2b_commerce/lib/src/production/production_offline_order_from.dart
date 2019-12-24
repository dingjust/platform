import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/products/product_select.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:b2b_commerce/src/production/offline_contacts_input.dart';
import 'package:b2b_commerce/src/production/offline_order_factroy_input.dart';
import 'package:b2b_commerce/src/production/offline_order_quantity.dart';
import 'package:b2b_commerce/src/production/production_earnest_money.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'offline_order/offline_order_cooperator_input.dart';

class ProductionOfflineOrder extends StatefulWidget {
  final ApparelProductModel product;

  Map<ColorModel, List<SizeQuantityItem>> colorSizeQuantityList;

  ProductionOfflineOrder({this.product, this.colorSizeQuantityList});

  _ProductionOfflineOrderState createState() => _ProductionOfflineOrderState();
}

class _ProductionOfflineOrderState extends State<ProductionOfflineOrder> {
  AddressModel addressModel = AddressModel(
    region: null,
    fullname: null,
    cellphone: null,
    city: null,
    cityDistrict: null,
    line1: null,
  );
  PurchaseOrderEntryModel entryModel = new PurchaseOrderEntryModel();
  String address;
  MachiningType machiningType;
  bool isInvoice = false;
  String remarks;
  CompanyModel company = new CompanyModel();
  String price;
  DateTime deliveryDate;
  String orderStatus;
  String statusCode;
  String processingCount;
  String productName;
  String earnestMoney;
  String detailAddress;
  ApparelProductModel _product;
  Map<ColorModel, List<SizeQuantityItem>> colorSizeList = Map();
  Map<ColorModel, List<SizeQuantityItem>> _items = Map();
  Map<ColorModel, List<SizeQuantityItem>> _newItems;
  Map<ColorModel, List<SizeQuantityItem>> sizeQuantityList;
  int _totalQuantity;
  ApparelProductModel productModel = new ApparelProductModel();
  List<ApparelSizeVariantProductModel> variants;
  EarnestMoney earnest = new EarnestMoney();
  PurchaseOrderModel purchaseOrder = new PurchaseOrderModel();
  String userType;
  FocusNode _priceFocusNode = FocusNode();
  TextEditingController _priceController = TextEditingController();
  FocusNode _remarksFocusNode = FocusNode();
  TextEditingController _remarksController = TextEditingController();

  ///合作商
  CooperatorModel cooperatorModel;

  ///选中账务方案
  CompanyPayPlanModel selectCompanyPayPlanModel;

  @override
  void initState() {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if (bloc.isBrandUser) {
      userType = 'brand';
    } else {
      userType = 'factory';
    }
    _product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('下单'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
            child: ListView(
              children: <Widget>[
                _buildCenter(context),
                Divider(
                  height: 0,
                ),
                _buildBottom(context),
//                _buildCommitButton(context),
              ],
            )),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '确认',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () async {
                onSubmit();
              }),
        ),
      ),
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

  Widget _buildCenter(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          productModel == null || productModel.name == null
              ? _buildSelectionProduct(context)
              : _buildProduct(context),
          Divider(
            height: 0,
          ),
          _buildCooperator(context),
          Divider(
            height: 0,
          ),
          _buildProcessCount(context),
          Divider(
            height: 0,
          ),
          _buildExpectPrice(context),
          _buildDeliveryDate(context),
          Divider(
            height: 0,
          ),
          // _buildEarnestMoney(context),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildCooperationModes(context),
          Divider(
            height: 0,
          ),
          _buildInvoice(context),
          Divider(
            height: 0,
          ),
          // userType == 'brand'
          //     ? _buildAddressPick(context)
          //     : _buildAddress(context),
          _buildAddressPick(context),
          Divider(
            height: 0,
            color: Colors.grey[200],
          ),
          _buildFinance(context),
          Divider(
            height: 0,
            color: Colors.grey[200],
          ),
          _buildOperator(context),
          Divider(
            height: 0,
            color: Colors.grey[200],
          ),
          _buildRemarks(context),
        ],
      ),
    );
  }

  //产品
  Widget _buildProduct(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              productModel.thumbnail != null
                  ? Container(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                    imageUrl: '${productModel.thumbnail.actualUrl}',
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          width: 80,
                          height: 80,
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
              )
                  : Container(
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
              builder: (context) => ProductSelectPage(),
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

  //没产品时选择产品
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
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductSelectPage(),
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

//生产数量
  Widget _buildProcessCount(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Wrap(
              children: <Widget>[
                Text('生产数量',
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
            });
          });
        });
  }

  ///合作商
  Widget _buildCooperator(BuildContext context) {
    String cooperatorName = '';

    if (cooperatorModel != null) {
      if (cooperatorModel.type == CooperatorType.ONLINE) {
        cooperatorName = cooperatorModel.partner.name;
      } else {
        cooperatorName = cooperatorModel.name;
      }
    }

    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '合作商',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${cooperatorName}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              )),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OfflineOrderCooperatorInput(
                      model: cooperatorModel,
                    )),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              if (value != null) {
                cooperatorModel = value;
              }
            });
          });
        });
  }

  //采购商家
  Widget _buildBrand(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '采购商家',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: company == null || company.name == null
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container(
                width: 150,
                child: Text(
                  company.name,
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
                builder: (context) =>
                    OfflineOrderFactroyInput(
                      model: company,
                      type: '品牌',
                    )),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              company = value;
            });
          });
        });
  }

  //价格
  Widget _buildExpectPrice(BuildContext context) {
    return TextFieldComponent(
      focusNode: _priceFocusNode,
      leadingText: Text(
        '订单报价',
        style: TextStyle(fontSize: 16),
      ),
      controller: _priceController,
      hintText: '请输入订单报价（数字）',
      prefix: '￥',
      inputFormatters: [
        DecimalInputFormat(),        
      ],
      dividerPadding: EdgeInsets.symmetric(
        horizontal: 0,
      ),
      onChanged: (value) {
        if (value.contains('.')) {
          int index = value.indexOf('.');
          if (value.length > index + 3) {
            setState(() {
              _priceController.text = value.substring(0, index + 3);
            });
          }
        }
        price = value;
      },
    );
  }

  //交货日期
  Widget _buildDeliveryDate(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Wrap(
                children: <Widget>[
                  Text('交货日期',
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
              trailing: deliveryDate == null
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(DateFormatUtil.formatYMD(deliveryDate),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ))),
        ),
        onTap: () {
          _showDatePicker();
        });
  }

  //定金尾款
  Widget _buildEarnestMoney(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '定金尾款',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: earnest == null ||
                earnest.earnestMoney == null ||
                earnest.earnestMoney == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              earnest.earnestMoney,
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
              builder: (context) =>
                  ProductionEarnestMoney(
                    earnest: earnest,
                  ),
            ),
          ).then((value) {
            setState(() {
              earnest = value;
            });
          });
        });
  }

  //送货地址（品牌）
  Widget _buildAddressPick(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '送货地址',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: address == null || address == ''
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container(
                width: 150,
                child: Text(
                  address,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              )),
        ),
        onTap: () {
          address = '';
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyAddressesPage(isJumpSource: true)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              addressModel = value;
              address = addressModel.region.name +
                  addressModel.city.name +
                  addressModel.cityDistrict.name;
            });
          });
        });
  }

  //送货地址（工厂）
  Widget _buildAddress(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '送货地址',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: addressModel == null || addressModel.region == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              addressModel.region.name +
                  addressModel.city.name +
                  addressModel.cityDistrict.name,
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
                builder: (context) =>
                    OfflineContactsInput(
                      model: addressModel,
                    )),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              if (value != null) addressModel = value;
            });
          });
        });
  }

  //合作方式
  Widget _buildCooperationModes(BuildContext context) {
    return Container(
      child: ListTile(
          leading: Wrap(
            children: <Widget>[
              Text('合作方式',
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
          trailing: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: MachiningType.values
                    .map((type) =>
                    ChoiceChip(
                        label: Text(MachiningTypeLocalizedMap[type]),
                        backgroundColor: Colors.grey[100],
                        selectedColor: Color.fromRGBO(255, 214, 12, 1),
                        selected: machiningType == type,
                        onSelected: (bool selected) {
                          setState(() {
                            machiningType = type;
                          });
                        }))
                    .toList(),
              ))),
    );
  }

//是否开具发票
  Widget _buildInvoice(BuildContext context) {
    return Container(
      child: ListTile(
          leading: Wrap(
            children: <Widget>[
              Text('是否开具发票',
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
          trailing: Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(isInvoice ? '开发票' : '不开发票',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                Switch(
                  value: isInvoice,
                  onChanged: (value) {
                    setState(() {
                      isInvoice = value;
                    });
                  },
                )
              ],
            ),
          )),
    );
  }

  //账务方案
  Widget _buildFinance(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Wrap(
                    children: <Widget>[
                      Text('账务方案',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                  trailing: Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${selectCompanyPayPlanModel?.name ?? ''}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      getFinanceString(),
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              )
            ],
          )),
      onTap: onFinanceSelect,
    );
  }

  //跟单员
  Widget _buildOperator(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '跟单员',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: Container(
                width: 300,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${UserBLoC.instance.currentUser.name}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                  ],
                ),
              )),
        ),
        onTap: () {});
  }

  //订单备注
  Widget _buildRemarks(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
          ),
        )
      ]),
    );
  }

  Widget _buildCommitButton(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.fromLTRB(20, 15, 20, 20),
              child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '确认',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () async {
                    onSubmit();
                  })),
        ],
      ),
    );
  }

  ///账务方案选择
  void onFinanceSelect() async {
    CompanyPayPlanResponse response = await PayPlanRepositoryImpl().all();

    setState(() {
      selectCompanyPayPlanModel = response.content[0];
    });

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          color: CupertinoColors.white,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: CupertinoColors.black,
              fontSize: 22.0,
            ),
            child: GestureDetector(
              // Blocks taps from propagating to the modal sheet and popping.
              onTap: () {},
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  backgroundColor: Colors.white, //选择器背景色
                  itemExtent: 30, //item的高度
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectCompanyPayPlanModel = response.content[index];
                    });
                  },

                  children: response.content
                      .map((payplan) => Text('${payplan.name}'))
                      .toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onSubmit() async {
    bool result = false;
    List<PurchaseOrderEntryModel> entries = new List();
    //联系人填写
    if (company != null) {
      if (company.name != null) {
        purchaseOrder.companyOfSeller = company.name;
      }
      if (company.name != null) {
        purchaseOrder.contactPersonOfSeller = company.contactPerson;
      }
      if (company.name != null) {
        purchaseOrder.contactOfSeller = company.contactPhone;
      }
    }
    //收货地址
    if (addressModel != null &&
        addressModel.region != null &&
        addressModel.city != null &&
        addressModel.cityDistrict != null) {
      purchaseOrder.deliveryAddress = addressModel;
    }
    //收货日期
    if (deliveryDate != null) {
      purchaseOrder.expectedDeliveryDate = deliveryDate;
    }

    //加工方式
    purchaseOrder.machiningType = machiningType;
    //是否需要发票
    purchaseOrder.invoiceNeeded = isInvoice;

    //生产总数
    if (_totalQuantity != null) {
      purchaseOrder.totalQuantity = _totalQuantity;
    }
    //备注
    if (remarks != null) {
      purchaseOrder.remarks = remarks;
    }
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

    //合作商
    purchaseOrder.cooperator = CooperatorModel(id: cooperatorModel.id);
    if (cooperatorModel.type == CooperatorType.ONLINE) {
      purchaseOrder.companyOfSeller = cooperatorModel.partner.name;
      purchaseOrder.contactPersonOfSeller =
          cooperatorModel.partner.contactPerson;
      purchaseOrder.contactOfSeller = cooperatorModel.partner.phone;
    } else {
      purchaseOrder.companyOfSeller = cooperatorModel.name;
      purchaseOrder.contactPersonOfSeller = cooperatorModel.contactPerson;
      purchaseOrder.contactOfSeller = cooperatorModel.contactPhone;
    }

    //账务
    // purchaseOrder.pay
    List<AbstractPayPlanItemModel> payItems = selectCompanyPayPlanModel
        .payPlanItems
        .map((item) =>
        AbstractPayPlanItemModel(
            payPercent: item.payPercent,
            triggerEvent: item.triggerEvent,
            moneyType: item.moneyType,
            triggerDays: item.triggerDays,
            triggerType: item.triggerType))
        .toList();

    OrderPayPlanModel orderPayPlanModel = OrderPayPlanModel(
        isHaveDeposit: selectCompanyPayPlanModel.isHaveDeposit,
        payPlanType: selectCompanyPayPlanModel.payPlanType,
        name: selectCompanyPayPlanModel.name,
        payPlanItems: payItems);

    purchaseOrder.payPlan = orderPayPlanModel;

    //单价
    if (price != null && double.parse(price) > 0) {
      purchaseOrder.unitPrice = ClassHandleUtil.removeSymbolRMBToDouble(price);
    } else {
      purchaseOrder.unitPrice = 0;
    }
    //添加订单行
    if (entries.length > 0 && entries.isNotEmpty) {
      purchaseOrder.entries = entries;
    }
    if (earnest != null) {
      //定金
      if (earnest.earnestMoney != null) {
        purchaseOrder.deposit =
            ClassHandleUtil.removeSymbolRMBToDouble(earnest.tailMoney);
      } else {
        purchaseOrder.deposit = 0;
      }
      purchaseOrder.depositPaid = earnest.isEarnestPayment;
      purchaseOrder.depositPaidDate = earnest.estimatePaymentDate;
      //尾款
      if (earnest.tailMoney != null) {
        purchaseOrder.balance =
            ClassHandleUtil.removeSymbolRMBToDouble(earnest.tailMoney);
      }
      purchaseOrder.balancePaid = earnest.isTailPayment;
      purchaseOrder.balancePaidDate = earnest.tailPaymentDate;
    }
    purchaseOrder.salesApplication = SalesApplication.BELOW_THE_LINE;

    bool isSubmit = false;
    try {
      //非空验证
      if (purchaseOrder.entries == null || purchaseOrder.entries.length <= 0) {
        isSubmit = _showValidateMsg(context, '请选择产品');
      } else if (purchaseOrder.totalQuantity == null ||
          purchaseOrder.totalQuantity <= 0) {
        isSubmit = _showValidateMsg(context, '请输入生产数量');
      } else if (purchaseOrder.expectedDeliveryDate == null) {
        isSubmit = _showValidateMsg(context, '请选择交货日期');
      } else if (purchaseOrder.machiningType == null) {
        isSubmit = _showValidateMsg(context, '请选择合作方式');
      } else if (purchaseOrder.invoiceNeeded == null) {
        isSubmit = _showValidateMsg(context, '请选择是否开具发票');
      } else {
        isSubmit = true;
      }
      if (isSubmit) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.CONFIRM_DIALOG,
                contentText2: '确定要创建线下订单吗？',
                outsideDismiss: false,
                dialogHeight: 180,
                isNeedConfirmButton: true,
                isNeedCancelButton: true,
                confirmAction: () {
                  Navigator.of(context).pop();
                  doSave(purchaseOrder);
                },
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  doSave(PurchaseOrderModel purchaseOrder) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: PurchaseOrderRepository()
                .createOfflinePurchaseOrder(purchaseOrder),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: 'createPurchaseOrder',
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
              failTips: '创建线下单失败',
              successTips: '创建线下单成功',
              callbackResult: result,
              confirmAction: () {
                Navigator.of(context).pop();
                getPurchaseOrderDetail(value);
              },
            );
          });
    });
  }

  void getPurchaseOrderDetail(String code) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => PurchaseOrderDetailPage(code: code)),
        ModalRoute.withName('/'));
    ProductionBLoC.instance.refreshData('');
    PurchaseOrderBLoC.instance.refreshData('ALL');
  }

  //打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    DateTime first = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: first,
        lastDate: DateTime(2999));

    if (_picked != null) {
      print(_picked);
      setState(() {
        deliveryDate = _picked;
      });
    }
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

  //非空提示
  bool _showValidateMsg(BuildContext context, String message) {
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context, String message) async {
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
        });
  }

  String getFinanceString() {
    if (selectCompanyPayPlanModel != null) {
      return selectCompanyPayPlanModel.isHaveDeposit
          ? ''
          : '无' +
          '定金+' +
          PayPlanTypeLocalizedMap[selectCompanyPayPlanModel.payPlanType];
    } else {
      return '';
    }
  }
}
