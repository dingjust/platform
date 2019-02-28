import 'package:b2b_commerce/main.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class PublishRequirementSuccessDialog extends StatefulWidget {
  final RequirementOrderModel model;

  const PublishRequirementSuccessDialog({Key key, this.model})
      : super(key: key);

  _PublishRequirementSuccessDialogState createState() =>
      _PublishRequirementSuccessDialogState();
}

class _PublishRequirementSuccessDialogState
    extends State<PublishRequirementSuccessDialog> {
  bool _isSelected = true;

  //TODO:调用接口查询推荐工厂
  List<FactoryModel> factories = <FactoryModel>[
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日4',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日3',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日2',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        name: '广州旭日1',
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        starLevel: 4,
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        name: '广州旭日0',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: ListView(
          children: <Widget>[
            _buildTitle(),
            _buildOrderInfo(),
//            _buildCheckLine(),
            _buildButtonGroup(),
            _buildRecommend()
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(18, 0, 0, 10),
                      child: Icon(
                        B2BIcons.publish_requirement_success,
                        size: 60,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      '需求发布成功!',
                      style: TextStyle(fontSize: 20, color: Colors.orange),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildOrderInfo() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                RequirementOrderDetailPage(order: widget.model)));
      },
      child: Container(
        child: Column(
          children: _buildEntries() ?? [],
        ),
      ),
    );
  }

  List<Widget> _buildEntries() {
    return widget.model?.entries
        ?.map((entry) => Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            color: Colors.grey[50],
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '需求订单号：${widget.model.code}',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: entry.product.thumbnail != null
                                ? NetworkImage(entry.product.thumbnail)
                                : AssetImage(
                                    'temp/picture.png',
                                    package: "assets",
                                  ),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            entry.product.name != null
                                ? Text(
                                    entry.product.name,
                                    style: TextStyle(fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    '暂无产品',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ),
                            entry.product.skuID != null
                                ? Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      '货号：' + entry.product.skuID,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  )
                                : Container(),
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.yellow[50],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${entry.product.superCategories.first.name}   ${entry.product.majorCategory.name}   ${entry.entryNumber}件",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.orange),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '预计交货日期：${DateFormatUtil.format(widget.model.expectedDeliveryDate)}',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '备注 ：${widget.model.remarks}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
              ],
            )))
        ?.toList();
  }

  Widget _buildCheckLine() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (v) {
                    setState(() {
                      _isSelected = v;
                    });
                  },
                  value: _isSelected,
                ),
                Text(
                  '将需求信息发到需求池',
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButtonGroup() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MyApp()));
                  },
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    '回到首页',
                    style: TextStyle(color: Colors.orange, fontSize: 14),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    '邀请更多工厂',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRecommend() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RichText(
                  text: TextSpan(
                      text: '———',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: '工厂推荐',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(text: '———')
                      ]),
                ),
              )
            ],
          ),
          Column(
            children: factories
                .map((item) => FactoryItem(
                      model: item,
                      showButton: true,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
