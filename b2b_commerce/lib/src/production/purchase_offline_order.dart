import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class PurchaseOfflineOrder extends StatefulWidget {

  _PurchaseOfflineOrderState createState() => _PurchaseOfflineOrderState();
}

class _PurchaseOfflineOrderState extends State<PurchaseOfflineOrder> {
  String address;
  String processingType;
  String isInvoice;
  String remarks;
  String processCount;
  String price;
  String deliveryDate;


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
//                _buildTop(context),
                _buildCenter(context),
                _buildBottom(context),
                _buildCommitButton(context),
              ],
            ))
    );
  }

  Widget _buildTop(BuildContext context) {
    return Container(
      color: Colors.white,
      child:  Column(
          children: <Widget>[

          ],
      ),
    );
  }

  Widget _buildCenter(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
          children: <Widget>[
            _buildProduct(context),
            Divider(
              height: 0,
            ),
            _buildCooperationModes(context),
            Divider(
              height: 0,
            ),
            _buildExpectPrice(context),
            Divider(
              height: 0,
            ),
            _buildDeliveryDate(context),
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
          _buildRemarks(context),
        ],
      ),
    );
  }

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
            trailing:
//            price == null || price == ''
//                ?
            Icon(Icons.keyboard_arrow_right)
//                : Text(price,
//              style: TextStyle(
//                  fontSize: 16,
//                  fontWeight: FontWeight.w500,
//                  color: Colors.grey
//              ),
//            ),
          ),
        ),
        onTap: () {
//          _neverPrice(context);
        });
  }

//加工数量
  Widget _buildProcessCount(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '加工数量',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: processCount == null || processCount == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(processCount,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _neverProcessCount(context);
        });
  }

  //价格
  Widget _buildExpectPrice(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '价格',
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
          _neverPrice(context);
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
              trailing: deliveryDate == null || deliveryDate == ''
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(deliveryDate,
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
                : Text(address,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          address = '';
          setState(() {
            address = address;
          });
          AddressPicker.showAddressPicker(
            context,
            selectProvince: (province) {
              address += province['name'];
            },
            selectCity: (city) {
              address += city['name'];
            },
            selectArea: (area) {
              address += area['name'];
              setState(() {
                address = address;
              });
            },
          );
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
            trailing: processingType == null || processingType == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              processingType,
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
            trailing: isInvoice == null || isInvoice == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(
              isInvoice,
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
            Text(
              '请输入留言备注',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            )
                :
            Text(
              remarks,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _neverOrderRemarks(context);
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
                  color: Color(0xFFFF9516),
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
                  onPressed: () {})),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 242, 242, 1),
      ),
    );
  }

  //加工数量
  Future<void> _neverProcessCount(BuildContext context) async {
    TextEditingController inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入加工数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入加工数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    processCount = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //价格
  Future<void> _neverPrice(BuildContext context) async {
    TextEditingController inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入加工数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入加工数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    price = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
        deliveryDate = DateFormatUtil.formatYMD(_picked);
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
                      processingType = '清加工';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('包工包料'),
                  onTap: () async {
                    setState(() {
                      processingType = '包工包料';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //订单备注
  Future<void> _neverOrderRemarks(BuildContext context) async {
    TextEditingController inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('备注'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入订单备注',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    remarks = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
                      isInvoice = '开发票';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不开发票'),
                  onTap: () async {
                    setState(() {
                      isInvoice = '不开发票';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

}