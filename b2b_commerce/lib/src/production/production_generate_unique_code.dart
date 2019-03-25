import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class ProductionGenerateUniqueCodePage extends StatefulWidget {
  final PurchaseOrderModel model;

  ProductionGenerateUniqueCodePage({@required this.model});

  _ProductionGenerateUniqueCodePageState createState() =>
      _ProductionGenerateUniqueCodePageState();
}

class _ProductionGenerateUniqueCodePageState
    extends State<ProductionGenerateUniqueCodePage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String uniqueCode;

  SimpleAutoCompleteTextField textField;

  List<String> added = [];
  String currentText = "";
  bool showTextField = true;

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  void _handleShowTextFieldChanged(bool newValue) {
    setState(() {
      showTextField = true;
      Navigator.of(context).pop();
      _onlineInvite();
    });
  }

  @override
  void initState(){
    widget.model.uniqueCode != null && widget.model.uniqueCode != null ?
    uniqueCode = widget.model.uniqueCode : uniqueCode = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('生成唯一码'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView(
            children: <Widget>[
              _buildMain(context),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: GenerateUniqueCodeItem(
                  order: widget.model,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildMain(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: <Widget>[
          _buildMainHeader(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: 180,
                  child: FlatButton(
                    color: Color.fromRGBO(255,214,12, 1),
                    onPressed: () {
                      _smsInvite();
                    },
                    child: Text(
                      '短信邀请',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
//                Container(
//                  width: 180,
//                  child: FlatButton(
//                    color: Colors.white,
//                    onPressed: () {
//                      _onlineInvite();
//                    },
//                    child: Text(
//                      '线上邀请',
//                      style: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
//                    ),
//                    shape: RoundedRectangleBorder(
//                        side: BorderSide(width: 0.5, color: Color.fromRGBO(255,214,12, 1)),
//                        borderRadius: BorderRadius.all(Radius.circular(20))),
//                  ),
//                ),
//                Text(
//                  '线上已注册工厂用户',
//                  style: TextStyle(
//                      color: Color.fromRGBO(255, 45, 45, 1), fontSize: 12),
//                ),
//                Container(
//                  margin: EdgeInsets.only(top: 20),
//                  child: Text(
//                    '把唯一码发给工厂，工厂可以使用唯一码导入您创建的生产订单，通过线上反馈生产进度。',
//                    style: TextStyle(
//                        color: Color.fromRGBO(100, 100, 100, 1), fontSize: 12),
//                  ),
//                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          color: Color.fromRGBO(255, 45, 45, 1),
          onPressed: uniqueCode != null && uniqueCode != '' ? null : () async {
            String unique = await PurchaseOrderRepository().generateUniqueCode(widget.model.code);
            if(unique != null){
              setState(() {
                uniqueCode = unique;
              });
            }
          },
          child: Text(
            '生成',
            style: TextStyle(color: Colors.white),
          ),
          disabledColor : Color(0xffBC8F8F),
          disabledTextColor: Colors.black26,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
        ),
        uniqueCode != null && uniqueCode != ''
            ? Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    '${uniqueCode}',
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            : Container(),
        FlatButton(
          color: Colors.white,
          onPressed: () {
            if(uniqueCode != null && uniqueCode != ''){
              copyToClipboard(uniqueCode);
            }
          },
          child: Text(
            '复制',
            style: TextStyle(color: Color.fromRGBO(22, 141, 255, 1)),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0.5, color: Color.fromRGBO(22, 141, 255, 1)),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        )
      ],
    );
  }

  void _smsInvite() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '请输入对方的手机号码',
            style: TextStyle(
                fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _phoneController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      // hintText: '请输入',
                      prefix: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      '+86',
                      style: TextStyle(color: Colors.black),
                    ),
                  )),

                  // padding: EdgeInsets.all(0),
                ),
                Text(
                  '是否确认手机号并发送邀请？',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 149, 22, 1), fontSize: 14),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 50),
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '不，再看看',
                      style: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, color: Color.fromRGBO(255,214,12, 1)),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                Container(
                  width: 100,
                  child: FlatButton(
                    color: Color.fromRGBO(255,214,12, 1),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '是',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _onlineInvite() {
    showDialog(
      context: context,
      builder: (context) {
        return CompleteTextFieldDialog(
          currentText: currentText,
          showTextField: showTextField,
          textField: textField,
          onChanged: _handleShowTextFieldChanged,
        );
      },
    );
  }

  //复制
  void copyToClipboard(final String text) {
    if (text == null) return;
    Clipboard.setData(
        ClipboardData(text: text)
    );
    _neverCopyContent(context);
  }

  Future<void> _neverCopyContent(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('消息'),
          content: Text('复制成功'),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class GenerateUniqueCodeItem extends StatelessWidget {
  const GenerateUniqueCodeItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Column(
              children: _buildEntries(),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '工厂：${order.belongTo == null ? order.companyOfSeller : order.belongTo.name}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Text(
                '${PurchaseOrderStatusLocalizedMap[order.status]}',
                style: TextStyle(
                    color: Color.fromRGBO(86, 194, 117, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEntries() {
    return order.entries
        .map((entry) => Container(
              color: Color.fromRGBO(250, 250, 250, 1),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: order.product != null && order.product.thumbnail != null
                              ? NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${order.product.thumbnail.url}')
                              : AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${entry.product.name == null? '' : entry.product.name}',
                                style: TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '货号：${entry.product.skuID == null? '' : entry.product.skuID}' ,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(150, 150, 150, 1)),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '生产订单号：${order.code == null ? '' : order.code}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '报价时间：${order.creationTime == null ? '' : DateFormatUtil.formatYMD(order.creationTime)}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}

class CompleteTextFieldDialog extends StatelessWidget {
  CompleteTextFieldDialog(
      {Key key,
      this.textField,
      this.showTextField,
      this.currentText,
      this.onChanged})
      : super(key: key);

  final SimpleAutoCompleteTextField textField;

  bool showTextField;

  String currentText;

  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(true);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    // TODO: implement build
    return AlertDialog(
      title: Text(
        '请输入对方工厂名称',
        style: TextStyle(fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1)),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(239, 239, 239, 1),
                    borderRadius: BorderRadius.circular(5)),
                child: showTextField
                    ? textField
                    : GestureDetector(
                        onTap: _handleTap,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            currentText,
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      )),
            Text(
              '是否确认手机号并发送邀请？',
              style: TextStyle(
                  color: Color.fromRGBO(255, 149, 22, 1), fontSize: 14),
            )
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 100,
              margin: EdgeInsets.only(right: 50),
              child: FlatButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '不，再看看',
                  style: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.5, color: Color.fromRGBO(255,214,12, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
            Container(
              width: 100,
              child: FlatButton(
                color: Color.fromRGBO(255,214,12, 1),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '是',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ],
        )
      ],
    );
  }
}
