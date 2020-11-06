import 'package:flutter/material.dart';
import 'package:models/models.dart';

///地址信息显示区
class AddressInfoBlock extends StatelessWidget {
  final AddressModel model;

  const AddressInfoBlock({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              title: Row(
                children: <Widget>[
                  Text('${model?.fullname ?? ''}'),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('${model?.cellphone ?? ''}'),
                  )
                ],
              ),
              subtitle: Text('${model?.details ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
          ),
          SizedBox(
            child: Image.asset(
              'temp/common/address_under_line.png',
              package: 'assets',
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
