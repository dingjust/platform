import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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

  //外接订单数据TODO: model构建
  SalesProductionOrderModel order;

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
          children: [_buildInputRow(), Divider(), _buildBody()],
        ),
      ),
      bottomNavigationBar: _buildBottomBtn(),
    );
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

  ///主体
  Widget _buildBody() {
    if (checkCode == 1 && order != null) {
      return _OrderInfo(order);
    } else {
      // 没有内容显示
      return Container(
        height: 100,
        child: Center(
          child: Text('$checkResult'),
        ),
      );
    }
  }

  Widget _buildBottomBtn() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      child: RaisedButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '确认导入',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () async {
            // _onSubmit();
          }),
    );
  }

  ///检索
  void _onCheck() async {
    //TODO:接口调用
    Function cancelFunc =
        BotToast.showLoading(clickClose: true, crossPage: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      checkCode = 1;
      // checkResult = '获取失败，未找到相关记录！';
      order = SalesProductionOrderModel.fromJson(mock['data']);
    });
    cancelFunc();
  }
}

class _OrderInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const _OrderInfo(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Text('订单号：${order.code}')),
              Expanded(
                  flex: 1,
                  child: Text(
                    '合作商：${order.originCooperator.name}',
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
          Divider(),
          for (final t in order.taskOrderEntries ?? []) _buildProductRow(t)
        ],
      ),
    ));
  }

  Widget _buildProductRow(ProductionTaskOrderModel entry) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.grey[100],
      child: Row(
        children: [
          ImageFactory.buildThumbnailImage(entry.product.thumbnail),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${entry.product.name}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '货号：${entry.product.skuID}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ))),
          Text('交期：${DateFormatUtil.formatYMD(entry.deliveryDate)}')
        ],
      ),
    );
  }
}

const mock = {
  "code": 1,
  "msg": null,
  "resultCode": 0,
  "data": {
    "code": "TSPO00000GZ6",
    "invoiceNeeded": false,
    "haveDeposit": false,
    "auditNeeded": false,
    "sendAuditNeeded": false,
    "originCooperator": {"name": "时尚品牌"},
    "taskOrderEntries": [
      {
        "id": 8796748578145,
        "invoiceNeeded": false,
        "product": {
          "skuID": "5222121",
          "name": "产品3",
          "images": [
            {
              "id": 8811314577438,
              "name": "微信图片_20200604184853.jpg",
              "url": "/resource/h5b/h98/8811314610206.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "thumbnail": {
            "id": 8811314577438,
            "name": "微信图片_20200604184853.jpg",
            "url": "/resource/h5b/h98/8811314610206.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "thumbnails": [
            {
              "id": 8811314577438,
              "name": "微信图片_20200604184853.jpg",
              "url": "/resource/h5b/h98/8811314610206.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "details": []
        },
        "progressInit": false,
        "deliveryDate": 1603296000000
      },
      {
        "id": 8796748610913,
        "invoiceNeeded": false,
        "product": {
          "skuID": "002222",
          "name": "产品2",
          "images": [
            {
              "id": 8811314380830,
              "name": "59049110cc90529e.jpg",
              "url": "/resource/he4/h9d/8811314413598.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "thumbnail": {
            "id": 8811314380830,
            "name": "59049110cc90529e.jpg",
            "url": "/resource/he4/h9d/8811314413598.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "thumbnails": [
            {
              "id": 8811314380830,
              "name": "59049110cc90529e.jpg",
              "url": "/resource/he4/h9d/8811314413598.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "details": []
        },
        "progressInit": false,
        "deliveryDate": 1603987200000
      },
      {
        "id": 8796748643681,
        "invoiceNeeded": false,
        "product": {
          "skuID": "0001",
          "name": "样衣1",
          "images": [
            {
              "id": 8807709573150,
              "name": "0d6f2ac087947bbc.jpg",
              "url": "/resource/h73/h4e/8807709605918.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "thumbnail": {
            "id": 8807709573150,
            "name": "0d6f2ac087947bbc.jpg",
            "url": "/resource/h73/h4e/8807709605918.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "thumbnails": [
            {
              "id": 8807709573150,
              "name": "0d6f2ac087947bbc.jpg",
              "url": "/resource/h73/h4e/8807709605918.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            }
          ],
          "details": []
        },
        "progressInit": false,
        "deliveryDate": 1603209600000
      }
    ]
  }
};
