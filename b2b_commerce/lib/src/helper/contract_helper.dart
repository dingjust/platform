import 'package:b2b_commerce/src/my/contract/contract_detail_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';

///合同工具类
class ContractHelper {
  static Future<dynamic> open(
      {@required BuildContext context, ContractModel model}) async {
    Function cancelFunc = BotToast.showLoading(
        clickClose: false, allowClick: false, crossPage: false);
    SearchResultModel resultModel =
        await ContractRepository().getContractPdfMedia(model.code);
    if (resultModel?.code == 0) {
      cancelFunc.call();
      BotToast.showText(text: '${resultModel.msg}');
      return false;
    }
    MediaModel pdf = resultModel.data;
    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fileName = pdf.name;
    String filePath = "$dir/$fileName";
    // var dio = new Dio();

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   client.idleTimeout = new Duration(seconds: 0);
    // };

    // Response response = await dio.download(pdf.actualUrl, filePath);

    Response response;
    try {
      response = await http$.download(pdf.actualUrl, filePath);
    } catch (e) {
      print('[钉单]$e');
    }

    cancelFunc.call();
    if (response != null) {
      int contentLength = 0;
      contentLength = int.parse(response.headers.map['content-length'][0]);
      if (contentLength > 0) {
        return await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ContractDetailPage(
                  pathPDF: filePath,
                  contractModel: model,
                )));
      }
    } else {
      BotToast.showText(text: '合同下载失败', crossPage: true);
    }
  }
}
