import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SampleProductHistoryItemPage extends StatelessWidget {
  SampleBorrowReturnHistoryModel item;

  SampleProductHistoryItemPage({this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text('借方：' + item.relatedParty)),
                  item.state == SampleProductReturnState.NO_RETURN
                      ? Text(
                          '未还',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          '已还',
                          style: TextStyle(
                            color: Color.fromRGBO(255,214,12, 1),
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                ],
              ),
              Text('联系方式：'+item.contactWay),
              Row(
                children: <Widget>[
                  Text('借出时间：' + DateFormatUtil.formatYMD(item.creationDate)),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text('借出数量：' + item.quantity.toString()),
                  ),
                ],
              ),
              item.state == SampleProductReturnState.NO_RETURN
                  ? Text('预计归还时间：' +
                      DateFormatUtil.formatYMD(item.expectedReturnDate))
                  : Text('归还时间：' + DateFormatUtil.formatYMD(item.returnedDate)),
              Text('备注：' + item.remake),
            ],
          ),
        ),
      ),
    );
  }
}
