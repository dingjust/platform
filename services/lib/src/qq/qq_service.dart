import 'package:flutter_qq/flutter_qq.dart';

class QQService {
  factory QQService() => _getInstance();

  static QQService get instance => _getInstance();
  static QQService _instance;

  /// 初始化
  QQService._internal() {
    FlutterQq.registerQQ('101581747');
  }

  static QQService _getInstance() {
    if (_instance == null) {
      _instance = new QQService._internal();
    }
    return _instance;
  }

  void share(String url,
      {String title, String summary, String imageUrl}) async {
    _handleShareToQQ(url, title: title, summary: summary, imageUrl: imageUrl);
  }

  void shareQQzone(String url,
      {String title, String summary, String imageUrl}) async {
    _handleShareToQzone(url,
        title: title, summary: summary, imageUrl: imageUrl);
  }

  Future<QQShareStatus> _handleShareToQQ(String url,
      {String title, String summary, String imageUrl}) async {
    ShareQQContent shareContent = ShareQQContent(
      title: "$title",
      targetUrl: "$url",
      summary: "$summary",
      imageUrl: "$imageUrl",
    );
    try {
      var qqResult = await FlutterQq.shareToQQ(shareContent);
      if (qqResult.code == 0) {
        return QQShareStatus.SUCCESS;
      } else if (qqResult.code == 1) {
        return QQShareStatus.FAIL;
      } else {
        return QQShareStatus.CANCEL;
      }
    } catch (error) {
      print("flutter_plugin_qq_example:" + error.toString());
      return QQShareStatus.ERROR;
    }
  }

  Future<QQShareStatus> _handleShareToQzone(String url,
      {String title, String summary, String imageUrl}) async {
    ShareQzoneContent shareQzoneContent = ShareQzoneContent(
        title: "$title", targetUrl: "$url", summary: "$summary",
         imageUrl: "$imageUrl",
        imageUrls: ["$imageUrl"]);
    try {
      var qqResult = await FlutterQq.shareToQzone(shareQzoneContent);
      if (qqResult.code == 0) {
        return QQShareStatus.SUCCESS;
      } else if (qqResult.code == 1) {
        return QQShareStatus.FAIL;
      } else {
        return QQShareStatus.CANCEL;
      }
    } catch (error) {
      print("flutter_plugin_qq_example:" + error.toString());
      return QQShareStatus.ERROR;
    }
  }
}

enum QQShareStatus {
  ///成功
  SUCCESS,

  ///失败,
  FAIL,

  ///取消
  CANCEL,

  ///错误
  ERROR
}
