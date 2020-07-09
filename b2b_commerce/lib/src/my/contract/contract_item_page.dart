
import 'dart:async';

import 'package:b2b_commerce/src/my/contract/pdf_reader.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractItemPage extends StatefulWidget {
  ContractModel model;

  ContractItemPage({this.model});
  _ContractItemPageState createState() => _ContractItemPageState();
}

class _ContractItemPageState extends State<ContractItemPage>{
  final StreamController _streamController =
  StreamController<double>.broadcast();

  static Map<ContractStatus, Color> _statusColors = {
    ContractStatus.INITIATE: Colors.red,
    ContractStatus.SIGN: Colors.yellow,
    ContractStatus.COMPLETE: Colors.green,
    ContractStatus.INVALID: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return RequestDataLoading(
                requestCallBack:
                ContractRepository().getContract(widget.model.code),
                outsideDismiss: false,
                loadingText: '请稍候。。。',
                entrance: '',
              );
            }).then((value) {
          if (value != null && value.data != null) {
//            ContractModel model = value.data;
            _previewFile();
//            Navigator.push(
//              context,
//              new MaterialPageRoute(
//                  builder: (context) =>
//                      ContractMarkDownWidgetPage(model : model)),
//            );
          }
        });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5,5,5,0),
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        child: Column(
          children: <Widget>[
            _buildHead(),
            _buildCenter(),
            _buildBottom(),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
      ),
    );
  }

  Widget _buildHead(){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                '${widget.model.title}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              '${ContractStatusLocalizedMap[widget.model.state]}',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: _statusColors[widget.model.state],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenter(){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                '合同编号：${widget.model.code}',
                style: TextStyle(
                  color: Colors.black26,
                ),
              ),
            ),
          ),
          Container(
            child:  Text(
              '${DateFormatUtil.formatYMD(widget.model.createTime)}',
              style: TextStyle(
                color: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(){
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              '${widget.model.partner}',
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //文件下载打开
  _previewFile() async {
    SearchResultModel resultModel = await ContractRepository().getContractPdfMedia(widget.model.code);
    MediaModel pdf = resultModel.data;
//    final url = "http://africau.edu/images/default/sample.pdf";
    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    // print(pdf.name);
    print(dir);
    String fileName = pdf.name;
    String filePath = "$dir/$fileName";
    var dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.idleTimeout = new Duration(seconds: 0);
    };

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            dio.download(pdf.actualUrl, filePath,
                onReceiveProgress: (received, total) {
                  print((received / total * 100).toStringAsFixed(0) + "%");
                  _streamController.sink.add(received / total);
                }),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((_){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PdfReaderWidget(pathPDF: filePath,contractModel: widget.model,)),
        );
//        Navigator.of(context)
//            .push(new MaterialPageRoute(builder: (_) {
//          return new Browser(
//            url: filePath,
//            title: "合同详情",
//          );
//        }));
    });
  }

}