import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/purchase_orders.dart';
import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:b2b_commerce/src/production/offline_order_factroy_input.dart';
import 'package:b2b_commerce/src/production/offline_order_input_page.dart';
import 'package:b2b_commerce/src/production/offline_order_input_remarks.dart';
import 'package:b2b_commerce/src/production/offline_order_quantity.dart';
import 'package:b2b_commerce/src/production/production_earnest_money.dart';
import 'package:b2b_commerce/src/production/production_unique_code.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class ProductionOfflineOrder extends StatefulWidget {

  final ApparelProductModel product;

  Map<ColorModel, List<SizeQuantityItem>> colorSizeQuantityList;

  ProductionOfflineOrder({this.product , this.colorSizeQuantityList});

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
  bool isInvoice;
  String remarks;
  FactoryModel factory = new FactoryModel();
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
  bool isSave = false;
  PurchaseOrderModel purchaseOrder = new PurchaseOrderModel();

  @override
  void initState() {
    _product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('创建线下订单'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
            child: ListView(
              children: <Widget>[
                _buildCenter(context),
                _buildBottom(context),
                _buildCommitButton(context),
              ],
            ))
    );
  }

  Widget _buildCenter(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildFactory(context),
          Divider(
            height: 0,
          ),
          _buildProduct(context),
          Divider(
            height: 0,
          ),
          _buildProcessCount(context),
          Divider(
            height: 0,
          ),
          _buildExpectPrice(context),
          Divider(
            height: 0,
          ),
          _buildDeliveryDate(context),
          Divider(
            height: 0,
          ),
          _buildEarnestMoney(context),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
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
          _buildAddress(context),
          Divider(
            height: 0,
          ),
          _buildDetailAddress(context),
          Divider(
            height: 0,
          ),
          _buildRemarks(context),
        ],
      ),
    );
  }

  //商品
  Widget _buildProduct(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '商品',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            trailing: productName == null || productName == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Container(
              width: 150,
              child: Text(
                productName,
                textAlign:TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),
              ),
            )
          ),
        ),
        onTap: () async {
          dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ApparelProductsPage(
                    isRequirement: true,
                    item: _product,
                  ),
            ),
          );
          if (result != null) {
            productName = result.name;
            productModel = result;

            if (productModel.variants != null) {
              List<ColorModel> colors = List();
              List<SizeModel> sizes = List();
              //把每个款的颜色记录下,并去重
              for (int i = 0; i < productModel.variants.length; i++) {
                colors.add(productModel.variants[i].color);
              }
              for (int i = 0; i < colors.length - 1; i ++) {
                for (int j = colors.length - 1; j > i; j --) {
                  if (colors[j].code.contains(colors[i].code)) {
                    colors.removeAt(j);
                  }
                }
              }

              //尺码
              for (int i = 0; i < productModel.variants.length; i++) {
                sizes.add(productModel.variants[i].size);
              }
              for (int i = 0; i < sizes.length - 1; i ++) {
                for (int j = sizes.length - 1; j > i; j --) {
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
                    SizeQuantityItem item = _newItems[itemColor]
                        .firstWhere(
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
                  _items[color] =
                      sizes.map((size) => SizeQuantityItem(size: size))
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
          child: ListTile(
            leading: Text(
              '生产数量',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: _totalQuantity == null || _totalQuantity < 0
                ? Icon(Icons.keyboard_arrow_right)
                : Text(_totalQuantity.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: ()  {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OfflineOrderQuantityInputPage(
                items: _items,
              ),
            ),
          ).then((result){
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

  //生产工厂
  Widget _buildFactory(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '生产工厂',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: factory == null || factory.name == null
                ? Icon(Icons.keyboard_arrow_right)
                : Container(
              width: 150,
              child: Text(
                factory.name,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),
              ),
            )
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderFactroyInput(model: factory,)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              factory = value;
            });
          });
        }
    );
  }

  //价格
  Widget _buildExpectPrice(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '生产单价',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: price == null || price == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(price,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderInputPage(fieldText: '生产单价',inputType: TextInputType.number)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              price = value;
            });
          });
        });
  }

  //交货日期
  Widget _buildDeliveryDate(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '交货日期',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
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
                            color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis
                    ),
                  )
              )),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            trailing: earnestMoney == null || earnestMoney == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(earnestMoney,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductionEarnestMoney(),
            ),
          ).then((value) {
            setState(() {
              earnest = value;
            });
          });
        });
  }

  //送货地址
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
            trailing: address == null || address == ''
                ? Icon(Icons.keyboard_arrow_right)
                :
            Container(
              width: 150,
              child: Text(
                address,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),
              ),
            )
          ),
        ),
        onTap: () {
          address = '';
          setState(() {
            address = address;
          });
          AddressPicker(cacel:(){
            Navigator.pop(context);
          }).showAddressPicker(
            context,
            selectProvince: (province) {
              address += province['name'];
              addressModel.region = RegionModel.fromJson(province);
            },
            selectCity: (city) {
              address += city['name'];
              addressModel.city = CityModel.fromJson(city);
            },
            selectArea: (area) {
              address += area['name'];
              addressModel.cityDistrict = DistrictModel.fromJson(area);
              setState(() {
                address = address;
              });
            },
          );
        });
  }

  //详细地址
  Widget _buildDetailAddress(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '详细地址',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: addressModel.line1 == null || addressModel.line1 == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(addressModel.line1,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderInputPage(fieldText: '详细地址',inputType: TextInputType.text)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              addressModel.line1 = value;
            });
          });
        });
  }

  //加工类型
  Widget _buildCooperationModes(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '加工类型',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: machiningType == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              MachiningTypeLocalizedMap[machiningType],
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
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
          child: ListTile(
            leading: Text(
              '是否开具发票',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: isInvoice == null
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              isInvoice == true ? '开发票' : '不开发票',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _showIsInvoiceSelect();
        });
  }

  //订单备注
  Widget _buildRemarks(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '订单备注',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: remarks == null || remarks == '' ?
              Icon(Icons.keyboard_arrow_right)
                :
            Container(
              width: 150,
              child: Text(
                remarks,
                textAlign:TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),
              ),
            )
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderInputRemarksPage(fieldText: '订单备注',inputType: TextInputType.text)),
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
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '确认',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  onPressed: () async {

                    List<PurchaseOrderEntryModel> entries = new List();
                    //联系人填写
                    purchaseOrder.companyOfSeller = factory.name;
                    purchaseOrder.contactPersonOfSeller = factory.contactPerson;
                    purchaseOrder.contactOfSeller = factory.contactPhone;
                    //收货地址
                    purchaseOrder.deliveryAddress = addressModel;
                    //收货日期
                    purchaseOrder.expectedDeliveryDate = deliveryDate;
                    //加工方式
                    purchaseOrder.machiningType = machiningType;
                    //是否需要发票
                    purchaseOrder.invoiceNeeded = isInvoice;
                    //生产总数
                    purchaseOrder.totalQuantity = _totalQuantity;
                    //备注
                    purchaseOrder.remarks = remarks;
                    //添加订单行
                    if(productModel != null && productModel.variants != null && productModel.variants.length > 0){
                      for(int i = 0; i < productModel.variants.length; i++){
                        PurchaseOrderEntryModel entryModel = new PurchaseOrderEntryModel();
                        entryModel.product = productModel.variants[i];
                        entryModel.product.thumbnail = productModel.thumbnail;
                        entryModel.product.thumbnails = productModel.thumbnails;
                        entryModel.product.images = productModel.images;
                        _items.forEach((color, items) {
                          items.forEach((item) {
                            if(productModel.variants[i].color.code == color.code){
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
                    if(price != null){
                      purchaseOrder.unitPrice = double.parse(price);
                    }
                    purchaseOrder.entries = entries;

                    if(earnest != null){
                      //定金
                      if(earnest.earnestMoney != null){
                        purchaseOrder.deposit = double.parse(earnest.earnestMoney);
                      }
                      purchaseOrder.depositPaid = earnest.isEarnestPayment;
                      purchaseOrder.depositPaidDate = earnest.estimatePaymentDate;
                      //尾款
                      if(earnest.tailMoney != null){
                        purchaseOrder.balance = double.parse(earnest.tailMoney);
                      }
                      purchaseOrder.balancePaid = earnest.isTailPayment;
                      purchaseOrder.balancePaidDate = earnest.tailPaymentDate;
                    }
                    purchaseOrder.salesApplication = SalesApplication.BELOW_THE_LINE;

                    try{
                      await PurchaseOrderRepository().offlinePurchaseOrder(purchaseOrder);
                      setState(() {
                        isSave = true;
                      });
                    }catch(e){
                      print(e);
                    }
                    _showSaveTips(context);

                  })
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 242, 242, 1),
      ),
    );
  }

  //打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999));

    if (_picked != null) {
      print(_picked);
      setState(() {
        deliveryDate = _picked;
      });
    }
  }

  //加工类型
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
                      isInvoice =  true;
                      
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

  //保存后是否成功提示
  Future<void> _showSaveTips(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
            child: Text(
              isSave == true? '创建线下单成功！':'创建线下单失败，请核对输入内容！',
              style: TextStyle(
                fontSize: 22,
              ),
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                isSave == true?
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PurchaseOrderDetailPage(order: purchaseOrder)
                  ),
                ):null;
              },
            ),
          ],
        );
      },
    );
  }

}