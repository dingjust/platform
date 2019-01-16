/*
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SampleProductItem extends StatelessWidget {
  final SampleProductModel item;

  const SampleProductItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Map<SampleProductReturnState, Color> _colorState = {
      SampleProductReturnState.NO_RETURN: Colors.red,
      SampleProductReturnState.RETURNED: Colors.blue,
      SampleProductReturnState.ABNORMAL: Colors.red,
    };

    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      elevation: 0,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: item.thumbnail != null
                          ? NetworkImage(item.thumbnail)
                          : AssetImage(
                              'temp/picture.png',
                              package: "assets",
                            ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(fontSize: 15),
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                                SampleProductReturnStateLocalizedMap[
                                    item.state],
                                style: TextStyle(
                                  color: _colorState[item.state],
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '货号：' + item.skuID,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          '借出日期：' + item.lendDate.toString().substring(0, 10),
                          style: TextStyle(color: Colors.grey),
                        ),
                        item.state == SampleProductReturnState.RETURNED
                            ? Text(
                                '归还日期：' +
                                    item.returnedDate
                                        .toString()
                                        .substring(0, 10),
                                style: TextStyle(color: Colors.grey),
                              )
                            : Text(
                                '预计归还日期：' +
                                    item.expectedReturnDate
                                        .toString()
                                        .substring(0, 10),
                                style: TextStyle(color: Colors.grey),
                              ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '借方：' + item.debtor,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Text(
                              '借出数量：',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              item.lendQuantity.toString(),
                              style: TextStyle(color: Colors.orange),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
