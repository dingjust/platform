import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CooperatorFormValidated {

  static const TextStyle infoTextStyle = TextStyle(fontSize: 16);

  static validated(CooperatorModel form) {
    if (form.name == null || form.name.trim() == '') {
      _showDialog('请填写或选择合作商！');
    } else if (form.contactPerson == null || form.contactPerson.trim() == '') {
      _showDialog('请填写联系人！');
    } else if (form.contactPhone == null || form.contactPhone.trim() == '') {
      _showDialog('请填写联系方式！');
    } else if (form.category == null) {
      _showDialog('请选择身份类型！');
    } else if (form.address == null ||
        form.address.city == null ||
        form.address.cityDistrict == null ||
        form.address.region == null ||
        form.address.line1 == null ||
        form.address.line1.trim() == '') {
      _showDialog('请完善所在区域信息！');
    }
  }

  static void _showDialog(String text) {
    BotToast.showEnhancedWidget(
      onlyOne: true,
      duration: null,
      clickClose: true,
      backgroundColor: Colors.black38,
      allowClick: false,
      toastBuilder: (cancelFunc) => AlertDialog(
        content: Container(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text('提示'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: infoTextStyle,
                    )),
                ],
              ),
              Row(
                children: [
                  Expanded(child: FlatButton(
                    onPressed: cancelFunc, child: Text('返回'),
                  ))
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
