import 'package:flutter_qq/flutter_qq.dart';

class QQService {
  void share() async {
    // await FlutterQqBridge.registerQq('101581747', '101581747');
    // var res = await FlutterQqBridge.shareToQQ(ShareQqContent(
    //   title: '钉单',
    //   summary: 'oijdoiqjojoi',
    //   targetUrl: 'https://www.nbyjy.net/RequirementSharePage.html',
    //   imageUrl:
    //       'https://g-search1.alicdn.com/img/bao/uploaded/i4/i3/3007768105/O1CN01L17zjm29k8dmymWM3_!!0-item_pic.jpg_460x460Q90.jpg_.webp',
    //   appName: '钉单',
    // ));
    // print(res);
    FlutterQq.registerQQ('101581747');

    _handleShareToQQ();
  }

  Future<Null> _handleShareToQQ() async {
    ShareQQContent shareContent = new ShareQQContent(
      title: "钉单",
      targetUrl: "https://www.nbyjy.net/RequirementSharePage.html",
      summary: "测试summary",
      imageUrl:
      "https://g-search1.alicdn.com/img/bao/uploaded/i4/i3/3007768105/O1CN01L17zjm29k8dmymWM3_!!0-item_pic.jpg_460x460Q90.jpg_.webp",
    );
    try {
      var qqResult = await FlutterQq.shareToQQ(shareContent);
      var output;
      if (qqResult.code == 0) {
        output = "分享成功";
      } else if (qqResult.code == 1) {
        output = "分享失败" + qqResult.message;
      } else {
        output = "用户取消";
      }
      print(output);
    } catch (error) {
      print("flutter_plugin_qq_example:" + error.toString());
    }
  }
}
