import 'package:b2b_commerce/src/business/search/suppliers_search.dart';
import 'package:b2b_commerce/src/business/supplier/suppliers_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

final List<SupplierModel> suppliers = <SupplierModel>[
  SupplierModel.fromJson({
    'code': 'S100001',
    'name': '广州迷你裙制衣厂',
    'orderCount': 50,
    'address': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    },
  }),
  SupplierModel.fromJson({
    'code': 'S100002',
    'name': '广州超短裙制衣厂',
    'orderCount': 60,
    'address': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    }
  }),
  SupplierModel.fromJson({
    'code': 'S100003',
    'name': '广州卫衣制衣厂',
    'orderCount': 60,
    'address': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    }
  }),
  SupplierModel.fromJson({
    'code': 'S100004',
    'name': '广州毛衣制衣厂',
    'orderCount': 60,
    'address': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    }
  }),
  SupplierModel.fromJson({
    'code': 'S100005',
    'name': '广州羽绒制衣厂',
    'orderCount': 60,
    'address': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    }
  }),
  SupplierModel.fromJson({
    'code': 'S100005',
    'name': '广州羽绒制衣厂',
    'orderCount': 60,
    'address': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    }
  }),
  SupplierModel.fromJson({
    'code': 'S100005',
    'name': '广州羽绒制衣厂',
    'orderCount': 60,
    'address': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    }
  }),
];

class SuppliersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('供应商管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
                context: context, delegate: SuppliersSearchDelegate()),
          ),
        ],
      ),
      body: Container(
        child: SuppliersList(),
      ),
    );
  }
}

class SuppliersList extends StatelessWidget {
  SuppliersList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: suppliers.map((sup) {
        return SuppliersItem(sup);
      }).toList(),
    );
  }
}

class SuppliersItem extends StatelessWidget {
  SupplierModel supplierModel;

  SuppliersItem(this.supplierModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: _buildList(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuppliersDetail(supplierModel: supplierModel),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return ListTile(
      title: Text(
        supplierModel.name,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      subtitle: Text('合作单数：' + supplierModel.orderCount.toString(),
          style: TextStyle(fontSize: 18, color: Colors.orange)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
                supplierModel.address.city.name +
                supplierModel.address.cityDistrict.name,
            style: TextStyle(fontSize: 16, color: Colors.black26),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}
