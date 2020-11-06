import 'package:b2b_commerce/src/my/contract/pdf_reader.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';

///合同工具类
class ContractHelper {
  static open(
      {@required BuildContext context, @required ContractModel model}) async {
    Function cancelFunc = BotToast.showLoading(
        clickClose: false, allowClick: false, crossPage: false);

    SearchResultModel resultModel =
        await ContractRepository().getContractPdfMedia(model.code);
    if (resultModel.code == 0) {
      cancelFunc.call();
      BotToast.showText(text: '${resultModel.msg}');
      return false;
    }
    MediaModel pdf = resultModel.data;
    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fileName = pdf.name;
    String filePath = "$dir/$fileName";
    var dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.idleTimeout = new Duration(seconds: 0);
    };
    Response response = await dio.download(pdf.actualUrl, filePath);
    cancelFunc.call();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PdfReaderWidget(
              pathPDF: filePath,
              contractModel: model,
            )));
  }
}
