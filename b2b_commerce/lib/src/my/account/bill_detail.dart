import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BillDetailPage extends StatefulWidget {
  final String code;

  const BillDetailPage({Key key, this.code}) : super(key: key);

  @override
  _BillDetailPageState createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('账单明细'),
        elevation: 0.5,
      ),
      body: FutureBuilder<BillModel>(
        builder: (BuildContext context, AsyncSnapshot<BillModel> snapshot) {
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
                          child: snapshot.data.type == BillType.WITHDRAWAL
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
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                    child: DetailRow(
                      label: '银行卡',
                      value: '${snapshot.data.bankAccount}',
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.grey[400],
                    ),
                  ),
                  _buildDetailRow('状态', '审批中...'),
                  _buildDetailRow(
                      '类型', '${BillTypeLocalizedMap[snapshot.data.type]}'),
                  _buildDetailRow(
                      '时间', '${DateFormatUtil.format(snapshot.data.date)}'),
                  _buildDetailRow('剩余总额', '￥${snapshot.data.balance}'),
                  _buildDetailRow('交易单号', '${snapshot.data.order.code}'),
                  _buildDetailRow('备注', '${snapshot.data.remarks}'),
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

  Future<BillModel> _getData() {
    return Future.delayed(const Duration(seconds: 1), () {
      return BillModel(
          code: 'B000000001',
          amount: 1200020,
          balance: 200030000,
          bankAccount: '988288882881892',
          order: OrderModel(code: '120000002'),
          date: DateTime.now(),
          remarks: '备注23333',
          type: BillType.PAYMENT);
    });
  }
}

class DetailRow extends StatelessWidget {
  final String label;

  final String value;

  const DetailRow({Key key, this.label, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 80,
          child: Text(
            '$label',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        Text(
          '$value',
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
