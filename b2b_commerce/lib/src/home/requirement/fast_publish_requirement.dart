import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class FastPublishRequirement extends StatefulWidget {
  _FastPublishRequirementState createState() => _FastPublishRequirementState();
}

class _FastPublishRequirementState extends State<FastPublishRequirement> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _requirementNumController = TextEditingController();

  /// 期望交货时间
  DateTime expectedDeliveryDate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  B2BIcons.left_quotation,
                  color: Color.fromRGBO(255, 234, 234, 1),
                  size: 12,
                ),
                Text(
                  '   急速发布需求   ',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Icon(
                  B2BIcons.right_quotation,
                  color: Color.fromRGBO(255, 234, 234, 1),
                  size: 12,
                )
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '点击选择分类',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                  autofocus: false,
                  controller: _requirementNumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      hintText: '填写需求数量',
                      border: InputBorder.none),
                  // 校验数量
                  validator: (v) {
                    return int.parse(v) > 0 ? null : '数量大于0';
                  }),
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    expectedDeliveryDate != null
                        ? Text(
                            '${DateFormatUtil.format(expectedDeliveryDate)}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          )
                        : Text(
                            '预计交货时间',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PublishRequirementSuccessDialog(
                                      model: RequirementOrderModel.fromJson({
                                        "code": "34938475200045",
                                        "status": "PENDING_QUOTE",
                                        "totalQuantity": 10,
                                        "totalPrice": 300,
                                        "expectedDeliveryDate":
                                            DateTime.now().toString(),
                                        "creationtime":
                                            DateTime.now().toString(),
                                        "remarks": "确定前请先与我厂沟通好样衣事宜，谢谢",
                                        "entries": [
                                          {
                                            "product": {
                                              "code": "NA89852509",
                                              "name": "山本风法少女长裙复古气质秋冬款",
                                              "skuID": "NA89852509",
                                              "majorCategory": {
                                                "name": "女装-T恤"
                                              },
                                              "supercategories": [
                                                {"name": "针织"}
                                              ],
                                              "thumbnail":
                                                  "https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp",
                                            },
                                            "basePrice": 100.00,
                                            "entryNumber": 500,
                                          },
                                        ],
                                        "attachments": [
                                          {
                                            'url':
                                                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                            'mediaType': 'webp'
                                          },
                                          {
                                            'url':
                                                'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
                                            'mediaType': 'pdf'
                                          },
                                          {
                                            'url':
                                                'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
                                            'mediaType': 'docx'
                                          },
                                          {
                                            'url':
                                                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                            'mediaType': 'webp'
                                          },
                                          {
                                            'url':
                                                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                            'mediaType': 'webp'
                                          },
                                          {
                                            'url':
                                                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                            'mediaType': 'webp'
                                          },
                                        ]
                                      }),
                                    ),
                                fullscreenDialog: true,
                              ));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Color.fromRGBO(255, 149, 22, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: Text(
                          '直接发布',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    setState(() {
      expectedDeliveryDate = picked;
    });
  }
}
