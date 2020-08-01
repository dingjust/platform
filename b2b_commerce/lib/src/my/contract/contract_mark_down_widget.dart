import 'dart:async';

import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/my/contract/pdf_reader.dart';
import 'package:b2b_commerce/src/my/contract/seal_select_widget.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractMarkDownWidgetPage extends StatefulWidget {
  ContractModel model;

  ContractMarkDownWidgetPage({this.model});

  _ContractMarkDownWidgetPageState createState() =>
      _ContractMarkDownWidgetPageState();
}

class _ContractMarkDownWidgetPageState
    extends State<ContractMarkDownWidgetPage> {
  SealModel sealModel = SealModel();
  List<SealModel> sealList;
  final StreamController _streamController =
  StreamController<double>.broadcast();

  initSeal() async {
    sealList = await ContractRepository()
        .getSealList({'type': ''}, {'page': '0', 'size': '100'});
  }

  @override
  void initState() {
    super.initState();
    initSeal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('合同详情'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Container(
          child: Markdown(data: widget.model.content),
        ),
        bottomNavigationBar: Container(
          color: Colors.white10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '去签署',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () {
              _previewFile();
//              Navigator.push(context,MaterialPageRoute(builder: (context) =>PdfReaderWidget(model:widget.model)));
//              SealModel sealModel = SealModel();
//              SealSelectWidget(cacel: () {
//                Navigator.pop(context);
//              },rightData: sealList,code: widget.model.code).showPicker(
//                context,c
//                selectType: (seal) {
//                  setState(() {
//                    sealModel = seal;
//                  });
//                  print(sealModel.code);
////                  if(seal != null && seal.code != null){
////                    flowContract(null);
////                  }
//                },
//              );
            },
          ),
        ));
  }

  //文件下载打开
  _previewFile() async {
    SearchResultModel resultModel =
    await ContractRepository().getContractPdfMedia(widget.model.code);
    MediaModel pdf = resultModel.data;
//    final url = "http://africau.edu/images/default/sample.pdf";
    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    print(pdf.name);
    String fileName = pdf.name;
    String filePath = "$dir/$fileName";
    var dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.idleTimeout = new Duration(seconds: 0);
    };

    try {
      Response response = await dio.download(pdf.actualUrl, filePath,
          onReceiveProgress: (received, total) {
            print((received / total * 100).toStringAsFixed(0) + "%");
            _streamController.sink.add(received / total);
          });
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
    print(filePath);
    //打开文件
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PdfReaderWidget(pathPDF: filePath)),
    );
  }

  flowContract(SealModel sealModel) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ContractRepository()
                .flowContract(widget.model.code, sealModel.code),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if (certification.data != null) {
//          _launchURL(certification.data);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewPage(url: certification.data)),
          );
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: certification.msg,
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '签署失败',
                callbackResult: false,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
      }
    });
  }

  Widget _buildSelectSealItem() {
    return GestureDetector(
      onTap: () {
        SealSelectWidget(
            cacel: () {
              Navigator.pop(context);
            },
            rightData: sealList)
            .showPicker(
          context,
          selectType: (seal) {
            setState(() {
              sealModel = seal;
            });
            print(sealModel.code);
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: 80,
              height: 80,
              child: Image.asset(
                'temp/select_seal.png',
                package: 'assets',
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: RichText(
                text: TextSpan(
                    text: sealModel != null && sealModel.name != null
                        ? '${sealModel.name}'
                        : '选择印章模板',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          )),
                    ]),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 3, color: Colors.black38)),
      ),
    );
  }
}
