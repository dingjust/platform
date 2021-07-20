import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class ProfileAboutPage extends StatefulWidget {
  @override
  _ProfileAboutPageState createState() => _ProfileAboutPageState();
}

class _ProfileAboutPageState extends State<ProfileAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text('关于钉单'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: AppProfile(
                      name: '钉单',
                      version: '${AppBLoC.instance?.packageInfo?.version}'),
                ),
                AppActions()
              ],
            )),
            AppProtocols(context),
            AppCopyright()
          ],
        ),
      ),
    );
  }
}

class AppProfile extends StatelessWidget {
  AppProfile({@required this.name, @required this.version});

  final String name;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset(
            'temp/login_logo.png',
            package: 'assets',
            width: 80.0,
            height: 80.0,
          ),
          Text(this.name),
          Text(this.version),
        ],
      ),
    );
  }
}

class AppActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // ListTile(
        //   trailing: Icon(Icons.chevron_right),
        //   title: const Text('功能介绍'),
        //   leading: const Icon(Icons.shopping_basket),
        //   onTap: () {},
        // ),
        ListTile(
          trailing: Icon(Icons.chevron_right),
          title: const Text('版本更新'),
          leading: const Icon(Icons.shopping_basket),
          onTap: () {
            //TODO版本检测
            AppVersionHelper appVersionHelper =
                Provider.of<AppVersionHelper>(context, listen: false);
            appVersionHelper.checkVersion(
                context, AppBLoC.instance?.packageInfo?.version, 'nbyjy',
                showNowMessage: true);
          },
        )
      ],
    );
  }
}

class AppProtocols extends StatelessWidget {
  final BuildContext context;

  const AppProtocols(this.context, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            onTap: showServiceProtocol,
            child: Container(
              child: Text(
                '《钉单平台服务协议》',
                style: TextStyle(color: Colors.blue),
              ),
            )),
        GestureDetector(
          onTap: showPayProtocol,
          child: Text(
            '《钉单平台货款代收代付服务协议》',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        GestureDetector(
          onTap: showPrivacyProtocol,
          child: Text(
            '《隐私政策声明》',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  void showPayProtocol() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/paymentProtocol.txt"),
            initialData: null,
            builder: (context, snapshot) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            '钉单货款代收代付服务协议',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  void showServiceProtocol() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/serviceProtocol.txt"),
            initialData: null,
            builder: (context, snapshot) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            '钉单平台服务协议',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  void showPrivacyProtocol() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/privacyProtocol.txt"),
            initialData: null,
            builder: (context, snapshot) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            '隐私政策声明',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}

class AppCopyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
            child: Text('© 2019-2020 宁波衣加衣供应链管理有限公司 版权所有',
                style: TextStyle(color: Colors.grey, fontSize: 12))));
  }
}
