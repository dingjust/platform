import 'package:b2b_commerce/src/business/orders/widget/form_divider.dart';
import 'package:b2b_commerce/src/business/orders/widget/form_row.dart';
import 'package:b2b_commerce/src/business/services/text_field_border_component_V2.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart';

class BankCardForm extends StatefulWidget {
  const BankCardForm({Key key}) : super(key: key);

  @override
  _BankCardFormState createState() => _BankCardFormState();
}

class _BankCardFormState extends State<BankCardForm> {
  TextEditingController nameController;
  FocusNode nameNode;
  TextEditingController bankController;
  FocusNode bankNode;
  TextEditingController noController;
  FocusNode noNode;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    nameNode = FocusNode();
    bankController = TextEditingController();
    bankNode = FocusNode();
    noController = TextEditingController();
    noNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            _buildTitle(),
            _buildInfo(),
            FormRow(
                title: '持卡人',
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: _buildName()),
            FormDivider(),
            FormRow(
                title: '开户行',
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: _buildBank()),
            FormDivider(),
            FormRow(
                title: '卡号',
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: _buildNo()),
            FormDivider(),
            _btn()
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '添加银行卡',
            style: TextStyle(fontSize: 22),
          )
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('请确保填写信息准确无误')],
      ),
    );
  }

  ///姓名
  Widget _buildName() {
    return Row(
      children: [
        Expanded(
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入持卡人姓名',
            controller: nameController,
            focusNode: nameNode,
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
          ),
        ),
      ],
    );
  }

  ///开户行
  Widget _buildBank() {
    return Row(
      children: [
        Expanded(
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入开户行（含支行名称）',
            controller: bankController,
            focusNode: bankNode,
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
          ),
        ),
      ],
    );
  }

  ///卡号
  Widget _buildNo() {
    return Row(
      children: [
        Expanded(
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入卡号',
            controller: noController,
            focusNode: noNode,
            inputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _btn() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: FlatButton(
        color: Color(0xFFFED800),
        height: 48,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          if (validate()) {
            submit();
          }
        },
        child: Text('添加'),
      ),
    );
  }

  bool validate() {
    if (nameController.text != '' &&
        bankController.text != '' &&
        noController.text != '') {
      return true;
    } else {
      BotToast.showText(text: '请填写有效信息', align: Alignment.center);
    }
    return false;
  }

  void submit() async {
    Function cancelFunc =
        BotToast.showLoading(clickClose: false, crossPage: false);
    BaseResponse response = await BankCardRepository.create({
      'bankName': bankController.text,
      'cardNumber': noController.text,
      'accountName': nameController.text
    });
    cancelFunc.call();
    if (response != null) {
      if (response.code == 1) {
        BotToast.showText(
            text: '添加成功', align: Alignment.center, crossPage: true);
        Navigator.of(context).pop(true);
      } else {
        BotToast.showText(text: '${response.msg}', align: Alignment.center);
      }
    } else {
      BotToast.showText(text: '未知错误', align: Alignment.center);
    }
  }
}
