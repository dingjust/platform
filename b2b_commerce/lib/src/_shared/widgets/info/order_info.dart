import 'package:flutter/material.dart';

///订单状态卡片
class OrderStateCard extends StatelessWidget {
  final String val;

  final String val2;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  const OrderStateCard(
      {Key key,
      this.val,
      this.val2,
      this.padding = const EdgeInsets.symmetric(vertical: 12),
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text('${val ?? ''}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222))),
          Container(
            height: 6,
            width: 72,
            decoration: BoxDecoration(
                color: Color(0xFFFED800),
                borderRadius: BorderRadius.circular(4)),
          ),
          val2 != null
              ? Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text('${val2 ?? ''}',
                      style: TextStyle(fontSize: 13, color: Color(0xFF222222))),
                )
              : Container()
        ],
      ),
    );
  }
}

///备注卡片
class RemarkCard extends StatelessWidget {
  final String val;

  const RemarkCard(this.val, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (val == null || val == '') {
      return Container();
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              margin: EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '备注',
                      style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$val',
                      style: TextStyle(color: Color(0xFF222222), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
