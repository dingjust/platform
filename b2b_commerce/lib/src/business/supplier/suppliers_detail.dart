import 'package:b2b_commerce/src/business/search/suppliers_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SuppliersDetail extends StatelessWidget {
  final SupplierModel supplierModel;

  SuppliersDetail({Key key, @required this.supplierModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('供应商管理'),
      ),
      body: Container(
        child: _buildFactoryInfo(context),
      ),
    );
  }

  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            title: Text('供应商名'),
            trailing: Text(supplierModel.factory.name,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('合作单数'),
            trailing: Text(supplierModel.orderCount.toString(),
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('联系人'),
            trailing: Text(supplierModel.factory.contactAddress.fullname,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('手机号码'),
            trailing: Text(supplierModel.factory.contactAddress.cellphone,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('地址'),
            trailing: Text(
                supplierModel.factory.contactAddress.region.name +
                    supplierModel.factory.contactAddress.city.name +
                    supplierModel.factory.contactAddress.cityDistrict.name +
                    supplierModel.factory.contactAddress.line1,
                style: TextStyle(
                  fontSize: 16,
                )),
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
