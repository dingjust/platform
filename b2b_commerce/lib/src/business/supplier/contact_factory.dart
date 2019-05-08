import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// 我的客服
class ContactFactoryPage extends StatefulWidget {
  _ContactFactoryPageState createState() => _ContactFactoryPageState();
}

class _ContactFactoryPageState extends State<ContactFactoryPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('联系工厂'),
      ),
      body: Container(
          child: ListView(
            children: <Widget>[
              _buildTelephone(context),
              Divider(
                height: 0,
              ),
              _buildWechar(context),
              Divider(
                height: 0,
              ),
              _buildQQ(context),
              Divider(
                height: 0,
              ),
              _buildEmail(context),
            ],
          )
      ),
    );
  }

  Widget _buildTelephone(BuildContext context){
    return GestureDetector(
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(
              '电话',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            trailing:
            Text('020-12345678',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap:() {
          _selectActionButton('020-12345678');
        });
  }

  Widget _buildWechar(BuildContext context){
    return GestureDetector(
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(
              '微信',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            trailing:
            Text('13123465789',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap : () {
          copyToClipboard('13123465789');
        });
  }

  Widget _buildQQ(BuildContext context){
    return GestureDetector(
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(
              'QQ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            trailing:
            Text('2995225588',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap : () {
          copyToClipboard('2995225588');
        });
  }

  Widget _buildEmail(BuildContext context){
    return GestureDetector(
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(
              '邮箱',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            trailing:
            Text('2995225588@qq.com',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap : () {
          copyToClipboard('2995225588@qq.com');
        });
  }

//拨打电话或发短信
  void _selectActionButton(String tel) async {
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

  copyToClipboard(final String text) {
    if (text == null) return;
    Clipboard.setData(
        ClipboardData(text: text)
    );
    ShowDialogUtil.showSimapleDialog(context, '复制成功');
  }


}
