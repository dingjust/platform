import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// 我的客服
class MyClientServicesPage extends StatefulWidget {
  _MyClientServicesPageState createState() => _MyClientServicesPageState();
}

class _MyClientServicesPageState extends State<MyClientServicesPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('我的客服'),
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
              _buildTips(context),
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
              '客服电话',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            trailing:
            Text('020-81682620',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap:() {
          _selectActionButton('020-81682620');
        });
  }

  Widget _buildWechar(BuildContext context){
    return GestureDetector(
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(
              '客服微信',
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
              '客服QQ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            trailing:
            Text('1498868394',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap : () {
          copyToClipboard('1498868394');
        });
  }

  Widget _buildEmail(BuildContext context){
    return GestureDetector(
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(
              '客服邮箱',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            trailing:
            Text('xiaoyongkuang@nbyjy.net',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap : () {
          copyToClipboard('xiaoyongkuang@nbyjy.net');
        });
  }

  Widget _buildTips(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Center(
        child: Text('上班时间：工作日 9:00 - 18:00',
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ),
    );
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
    _neverCopyContent(context);
  }

  Future<void> _neverCopyContent(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            '提示',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('复制成功'),
            ),
          ],
        );
      },
    );
  }

}
