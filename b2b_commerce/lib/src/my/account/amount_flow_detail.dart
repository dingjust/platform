import 'package:b2b_commerce/src/my/account/bill_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class AmountFlowDetailPage extends StatefulWidget {
  final String code;

  const AmountFlowDetailPage({Key key, this.code}) : super(key: key);

  @override
  _AmountFlowDetailPageState createState() => _AmountFlowDetailPageState();
}

class _AmountFlowDetailPageState extends State<AmountFlowDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('交易明细'),
        elevation: 0.5,
      ),
      body: FutureBuilder<AmountFlowModel>(
        builder:
            (BuildContext context, AsyncSnapshot<AmountFlowModel> snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '提现',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: snapshot.data.amountFlowType ==
                                  AmountFlowType.OUTFLOW
                              ? Text(
                                  '-￥${snapshot.data.amount}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  '+￥${snapshot.data.amount}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.grey[400],
                    ),
                  ),
                  _buildDetailRow('类型',
                      '${AmountFlowTypeLocalizedMap[snapshot.data.amountFlowType]}'),
                  _buildDetailRow('时间',
                      '${DateFormatUtil.format(snapshot.data.creationtime)}'),
                  _buildDetailRow('剩余总额', '￥12222222'),
                  _buildDetailRow('交易单号', '${snapshot.data.order.code}'),
                  _buildDetailRow('备注', '${snapshot.data.remark}'),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        initialData: null,
        future: _getData(),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: DetailRow(
        label: label,
        value: value,
      ),
    );
  }

  Future<AmountFlowModel> _getData() {
    return Future.delayed(const Duration(seconds: 1), () {
      return AmountFlowModel(
          code: 'B000000001',
          amount: 1200020,
          account: '988288882881892',
          order: OrderModel(code: '120000002'),
          creationtime: DateTime.now(),
          remark: '备注23333',
          amountStatus: AmountStatus.AUDITING,
          amountFlowType: AmountFlowType.INFLOW);
    });
  }
}
