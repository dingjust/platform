import 'package:b2b_commerce/src/business/doc/doc_signature_detail_page.dart';
import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';

///签署文档工具类
class DocSignatureHelper {
  static Future<bool> open(
      {@required BuildContext context,
      @required DocSignatureModel model,
      bool disable = false}) async {
    Function cancelFunc = BotToast.showLoading(
        clickClose: false, allowClick: false, crossPage: false);

    String dir = (await getApplicationDocumentsDirectory()).path;
    String fileName = model.docPdf.name;
    String filePath = "$dir/$fileName";

    String downUrl = Apis.docSignaturePreview(model.code);

    Response response = await http$.download(downUrl, filePath);

    cancelFunc.call();
    int contentLength = 0;
    contentLength = int.parse(response.headers.map['content-length'][0]);
    if (contentLength > 0) {
      bool result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              DocSignatureDetailPage(
                pathPDF: filePath,
                doc: model,
                title: '电子对账单详情',
                disable: disable,
              )));
      return result;
    } else {
      BotToast.showText(text: 'PDF下载失败');
    }
    return false;
  }

  static Future<bool> sign(
      {@required BuildContext context,
      @required String sealCode,
      @required String docCode}) async {
    Function cancelFunc = BotToast.showLoading(
        clickClose: false, allowClick: false, crossPage: false);

    Response response;
    try {
      response = await http$
          .get(Apis.docSignatureSign(docCode), data: {'sealCode': sealCode});
    } on DioError catch (e) {
      print(e);
    }

    cancelFunc.call();
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code == 1) {
        bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebviewPage(
                    url: response.data['data'],
                    needRedirectContractList: false,
                  )),
        );
        if (result != null && result) {
          return true;
        }
        return false;
      } else {
        BotToast.showText(text: '${baseResponse.msg}');
      }
    } else {
      BotToast.showText(text: '签署失败');
    }
    return false;
  }
}
