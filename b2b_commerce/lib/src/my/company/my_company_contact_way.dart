import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:models/models.dart';

class MyCompanyContactWayPage extends StatelessWidget {
  dynamic company;
  MyCompanyContactWayPage(this.company);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('联系方式'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          Container(
              width: 80,
              child: ActionChip(
                label: Text('编辑'),
                onPressed: () {},
                backgroundColor: Color.fromRGBO(255, 214, 12, 1),
              )),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    '联系人',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                  trailing:
                  Text(company.contactPerson ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  enabled: company.contactPhone != null,
                  leading: Text(
                    '联系电话',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                  trailing: Text(company.contactPhone ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap:() {
                    _selectActionButton(company.contactPhone,context);
                  }
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                    enabled: company.address != null,
                  leading: Text(
                    '经营地址',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                  trailing:
                  Text(company.address ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap : () {
                    copyToClipboard(company.address,context);
                  }
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  enabled: company.phone != null,
                  leading: Text(
                    '座机号码',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                  trailing:
                  Text(company.phone ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap:() {
                    _selectActionButton(company.phone,context);
                  }
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  enabled: company.email != null,
                  leading: Text(
                    '邮箱地址',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                  trailing:
                  Text(company.email ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap : () {
                    copyToClipboard(company.email,context);
                  }
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                    enabled: company.qq != null,
                  leading: Text(
                    'QQ号',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                  trailing:
                  Text('',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap : () {
                    copyToClipboard(null,context);
                  }
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                    enabled: company.wechat != null,
                  leading: Text(
                    '微信号',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                  trailing:
                  Text('',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap : () {
                    copyToClipboard(null,context);
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //拨打电话或发短信
  void _selectActionButton(String tel,BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-')>-1?Container():ListTile(
              leading: Icon(Icons.message),
              title: Text('发送短信'),
              onTap: () async {
                var url = 'sms:' + tel;
                await launch(url);
              },
            ),
          ],
        );
      },
    );
  }

  copyToClipboard(final String text,BuildContext context) {
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
