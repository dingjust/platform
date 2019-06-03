import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class InvoiceTitleFormPage extends StatefulWidget {
  final bool isCreate;
  final InvoiceTitleModel invoiceTitle;

  InvoiceTitleFormPage({this.invoiceTitle,this.isCreate = false,});

  @override
  InvoiceTitleFormState createState() => InvoiceTitleFormState();
}

class InvoiceTitleFormState extends State<InvoiceTitleFormPage> {
  GlobalKey _invoiceTitleForm = GlobalKey<FormState>();
  TextEditingController _companyController;
  TextEditingController _taxNumController;
  TextEditingController _phoneController;
  TextEditingController _adressController;
  TextEditingController _bankOfDepositController;
  TextEditingController _bankAccountController;
  FocusNode _companyFocusNode = FocusNode();
  FocusNode _taxNumberFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _adressFocusNode = FocusNode();
  FocusNode _bankOfDepositFocusNode = FocusNode();
  FocusNode _bankAccountFocusNode = FocusNode();
  bool _isDefault;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isDefault = widget?.invoiceTitle?.defaultTitle ?? false;
    _companyController =
        TextEditingController(text: widget?.invoiceTitle?.company);
    _adressController =
        TextEditingController(text: widget?.invoiceTitle?.address);
    _phoneController = TextEditingController(text: widget?.invoiceTitle?.phone);
    _taxNumController =
        TextEditingController(text: widget?.invoiceTitle?.taxNumber);
    _bankAccountController =
        TextEditingController(text: widget?.invoiceTitle?.bankAccount);
    _bankOfDepositController =
        TextEditingController(text: widget?.invoiceTitle?.bankOfDeposit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(widget.isCreate ? '新建发票抬头':'编辑发票抬头'),
        actions: <Widget>[
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '保存',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () => _onSumbit(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _invoiceTitleForm,
          autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFieldComponent(
                  focusNode: _companyFocusNode,
                  controller: _companyController,
                  leadingText: Text('公司名称',style: TextStyle(fontSize: 16,)),
                  hintText: '请输入公司名称',
                ),
                TextFieldComponent(
                  focusNode: _taxNumberFocusNode,
                  controller: _taxNumController,
                  leadingText: Text('税号',style: TextStyle(fontSize: 16,)),
                  hintText: '15-20位（企业报销时必填）',
                ),
                TextFieldComponent(
                  focusNode: _adressFocusNode,
                  controller: _adressController,
                  leadingText: Text('单位地址',style: TextStyle(fontSize: 16,)),
                  hintText: '请输入单位地址',
                ),
                TextFieldComponent(
                  focusNode: _phoneFocusNode,
                  controller: _phoneController,
                  leadingText: Text('电话号码',style: TextStyle(fontSize: 16,)),
                  hintText: '请输入电话号码',
                ),
                TextFieldComponent(
                  focusNode: _bankOfDepositFocusNode,
                  controller: _bankOfDepositController,
                  leadingText: Text('开户银行',style: TextStyle(fontSize: 16,)),
                  hintText: '请输入开户银行',
                ),
                TextFieldComponent(
                  focusNode: _bankAccountFocusNode,
                  controller: _bankAccountController,
                  leadingText: Text('银行账户',style: TextStyle(fontSize: 16,)),
                  hintText: '请输入银行账户',
                ),
                ListTile(
                  title: Text('默认抬头'),
                  trailing: Switch(
                    activeColor: Colors.pink,
                    value: _isDefault,
                    onChanged: (v){
                      setState(() {
                        _isDefault = !_isDefault;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSumbit(){
    if(_companyController.text == ''){
      ShowDialogUtil.showValidateMsg(context, '请填写公司名称');
      return;
    }
    if(_taxNumController.text == ''){
      ShowDialogUtil.showValidateMsg(context, '请填写税号');
      return;
    }
    if(_adressController.text == ''){
      ShowDialogUtil.showValidateMsg(context, '请填写单位地址');
      return;
    }
    if(_phoneController.text == ''){
      ShowDialogUtil.showValidateMsg(context, '请填写电话号码');
      return;
    }
    if(_bankOfDepositController.text == ''){
      ShowDialogUtil.showValidateMsg(context, '请填写开户银行');
      return;
    }
    if(_bankAccountController.text == ''){
      ShowDialogUtil.showValidateMsg(context, '请填写银行账户');
      return;
    }
    widget.invoiceTitle.company = _companyController.text;
    widget.invoiceTitle.phone = _phoneController.text;
    widget.invoiceTitle.address = _adressController.text;
    widget.invoiceTitle.bankAccount = _bankAccountController.text;
    widget.invoiceTitle.bankOfDeposit = _bankOfDepositController.text;
    widget.invoiceTitle.taxNumber = _taxNumController.text;
    widget.invoiceTitle.defaultTitle = _isDefault;

    if(widget.isCreate){
      InvoiceTitleRepositoryImpl().create(widget.invoiceTitle).then((result){
        ShowDialogUtil.showResultMsg(context, '创建发票抬头成功', '创建发票抬头失败', result).then((_){
          Navigator.pop(context);
        });
      });
    }else{
      InvoiceTitleRepositoryImpl().update(widget.invoiceTitle).then((result){
        ShowDialogUtil.showResultMsg(context, '编辑发票抬头成功', '编辑发票抬头失败', result).then((_){
          Navigator.pop(context);
        });
      });
    }

  }
}
