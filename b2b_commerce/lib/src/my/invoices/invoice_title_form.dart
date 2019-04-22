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
          IconButton(
            icon: Text('保存'),
            onPressed: () {
              widget.invoiceTitle.company = _companyController.text;
              widget.invoiceTitle.phone = _phoneController.text;
              widget.invoiceTitle.address = _adressController.text;
              widget.invoiceTitle.bankAccount = _bankAccountController.text;
              widget.invoiceTitle.bankOfDeposit = _bankOfDepositController.text;
              widget.invoiceTitle.taxNumber = _taxNumController.text;
              widget.invoiceTitle.defaultTitle = _isDefault;

              if(widget.isCreate){
                InvoiceTitleRepositoryImpl().create(widget.invoiceTitle);
              }else{
                InvoiceTitleRepositoryImpl().update(widget.invoiceTitle);
              }
              Navigator.pop(context);
            },
          )
        ],
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
}
