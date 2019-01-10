import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class QuoteItem extends StatelessWidget {
  const QuoteItem({Key key, @required this.model}) : super(key: key);

  final QuoteModel model;

  static Map<String, MaterialColor> _statusColors = {
    "ADOPT": Colors.green,
    "REFUSE": Colors.red
  };

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[_buildHeader(), _buildMain()],
        ));
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("报价单号：${model.code}"),
          Text("报价时间：${DateFormatUtil.format(model.creationTime)}")
        ],
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: InkWell(
        onTap: () {
          print('ssss');
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 140,
                  child: Text(
                    model.belongTo.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Stars(
                              starLevel: 5,
                              color: Color.fromRGBO(255, 183, 0, 1)),
                          Text(
                            model.state,
                            style: TextStyle(color: _statusColors[model.state]),
                          )
                        ],
                      ),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '报价：${model.totalPrice}',
                  style: TextStyle(color: Colors.red,fontSize: 16),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        model.deliveryAddress.regionCityAndDistrict,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: '历史接单',
                      style: TextStyle(color: Colors.black54),
                      children: <TextSpan>[
                        TextSpan(
                            text: '214', style: TextStyle(color: Colors.red)),
                        TextSpan(
                            text: '单,报价成功率',
                            style: TextStyle(color: Colors.black54)),
                        TextSpan(
                            text: '34%', style: TextStyle(color: Colors.red))
                      ]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
