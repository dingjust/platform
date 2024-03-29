import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

/// 我的客服
class MyClientServicesPage extends StatefulWidget {
  _MyClientServicesPageState createState() => _MyClientServicesPageState();
}

class _MyClientServicesPageState extends State<MyClientServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('联系客服'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _buildTelephone(context),
            const Divider(height: 5),
            _buildWechat(context),
            // const Divider(height: 5),
            // _buildQQ(context),
            const Divider(height: 5),
            _buildQRCode(),
            _btn()
            // _buildTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTelephone(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: const Text(
            '客服电话',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          trailing: const Text(
            '020-81682620',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      onTap: () {
        _selectActionButton('020-81682620');
      },
    );
  }

  Widget _buildWechat(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: Text(
            '客服微信',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          trailing: const Text(
            'yiy80088',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildQQ(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: const Text(
            '客服QQ',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          trailing: Text(
            '1498868394',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      onTap: () {
        copyToClipboard('1498868394');
      },
    );
  }

  Widget _buildQRCode() {
    return GestureDetector(
      onLongPress: () {
        _savedImage();
      },
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Image.asset('temp/QRCode.png', package: 'assets')),
    );
  }

  Widget _buildTips(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Center(
        child: Text(
          '上班时间：工作日 9:00 - 18:00',
          style: const TextStyle(fontSize: 16),
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
              leading: const Icon(Icons.phone),
              title: const Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
                    leading: const Icon(Icons.message),
                    title: const Text('发送短信'),
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
    Clipboard.setData(ClipboardData(text: text));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            successTips: '复制成功',
            callbackResult: true,
            confirmAction: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  _savedImage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          content: Text(
            '是否保存图片?',
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('确定'),
              onPressed: () async {
                // ByteData bytes =
                // await rootBundle.load('packages/assets/temp/QRCode.png');
                // ImagePickerSaver.saveFile(fileData: bytes.buffer.asUint8List())
                //     .then((v) {
                //   Navigator.pop(context);
                // });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _btn() {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            //TODO:通过接口获取客服链接
            WechatServiceImpl.instance.customerServiceChat('ww7f13cc3ef52db52c',
                'https://work.weixin.qq.com/kfid/kfc261eb8463e6fde59');
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF07c160))),
          child: Text('联系客服')),
    );
  }
}
