import 'package:flutter/material.dart';

class ExternalSaleOrderImportPage extends StatefulWidget {
  @override
  _ExternalSaleOrderImportPageState createState() =>
      _ExternalSaleOrderImportPageState();
}

class _ExternalSaleOrderImportPageState
    extends State<ExternalSaleOrderImportPage> {
  TextEditingController _textEditingController;

  int checkCode = 0;
  String checkResult = '';

  @override
  void initState() {
    _textEditingController = TextEditingController(text: 'TJTspqC');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('导入唯一码'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [_buildInputRow(), _buildNoDataRow()],
          ),
        ));
  }

  ///输入行
  Widget _buildInputRow() {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: '请输入7位唯一码'),
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.circular(5)),
              )),
              Container(
                child: FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Text(
                      '检索',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    onPressed: _onCheck),
              ),
            ],
          ),
        ));
  }

  ///没有内容显示
  Widget _buildNoDataRow() {
    return Container(
      child: Center(
        child: Text('$checkResult'),
      ),
    );
  }

  ///订单信息行
  Widget _buildOrderInfo() {
    return Container();
  }

  ///检索
  void _onCheck() {}
}

const mock = {
  "code": 1,
  "msg": null,
  "resultCode": 0,
  "data": {
    "code": "TSPO00000G7C",
    "invoiceNeeded": false,
    "haveDeposit": false,
    "auditNeeded": false,
    "sendAuditNeeded": false,
    "originCooperator": {"name": "宁波衣加衣供应链管理有限公司"},
    "taskOrderEntries": [
      {
        "id": 8796715679073,
        "invoiceNeeded": false,
        "product": {
          "skuID": "333",
          "name": "iiui",
          "images": [
            {
              "id": 8808005697566,
              "name": "3.jpg",
              "url": "/resource/h27/hc1/8808005730334.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "thumbnail": {
            "id": 8808005697566,
            "name": "3.jpg",
            "url": "/resource/h27/hc1/8808005730334.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "thumbnails": [
            {
              "id": 8808005697566,
              "name": "3.jpg",
              "url": "/resource/h27/hc1/8808005730334.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "details": []
        },
        "progressInit": false,
        "deliveryDate": 1601395200000
      }
    ]
  }
};
