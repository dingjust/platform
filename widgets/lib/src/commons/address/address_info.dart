import 'package:flutter/material.dart';
import 'package:models/models.dart';

///地址信息显示区
class AddressInfoBlock extends StatelessWidget {
  final AddressModel model;

  final VoidCallback onTap;

  const AddressInfoBlock({Key key, this.model, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
                title: model != null
                    ? Row(
                        children: <Widget>[
                          Text('${model?.fullname ?? ''}'),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text('${model?.cellphone ?? ''}'),
                          )
                        ],
                      )
                    : _buildNoData(),
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
      ),
    );
  }

  Widget _buildNoData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '选择地址',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
