import 'package:flutter/material.dart';
import 'package:models/models.dart';

class InvoiceTitleFormPage extends StatefulWidget {
  final InvoiceTitleModel invoiceTitle;

  InvoiceTitleFormPage({this.invoiceTitle});

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
        centerTitle: true,
        title: Text('编辑发票抬头'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
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
                TextFormField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    labelText: '公司名称',
                  ),
                ),
                TextFormField(
                  controller: _taxNumController,
                  decoration: InputDecoration(
                    labelText: '税号',
                    hintText: '15-20位（企业报销时必填）',
                  ),
                ),
                TextFormField(
                  controller: _adressController,
                  decoration: InputDecoration(
                    labelText: '单位地址',
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: '电话号码',
                  ),
                ),
                TextFormField(
                  controller: _bankOfDepositController,
                  decoration: InputDecoration(
                    labelText: '开户银行',
                  ),
                ),
                TextFormField(
                  controller: _bankAccountController,
                  decoration: InputDecoration(
                    labelText: '银行账户',
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
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
