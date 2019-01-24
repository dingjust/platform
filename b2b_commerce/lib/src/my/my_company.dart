import 'package:b2b_commerce/src/my/company/my_company_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

BrandModel brandModel = BrandModel.fromJson({
  'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
  'uid': 'BB123456',
  'name': '草帽商店',
  'starLevel': 5,
  'email': 'monkey.D.luffy@163.com',
  'phone': '020-12345678',
  'contactPerson': 'luffy',
  'contactPhone': '13123456789',
  'address': {
    'fullname': "张三",
    'cellphone': '13123456789',
    'region': {'isocode': 'R123', 'name': '广东省'},
    'city': {'code': 'C123', 'name': '广州市'},
    'cityDistrict': {'code': 'D123', 'name': '海珠区'},
    'line1': '广州大道南',
  },
  'brand': '草帽海贼团',
  'cooperativeBrand': '红心海贼团',
  'scaleRange': 'SR005',
  'ageRanges': ['16-22', '23-30'],
  'priceRange1s': ['1000-3999', '4999-9999'],
  'priceRange2s': ['5999-9999', '10000-19999'],
  'styles': [
    {'code': '1001', 'name': '潮流'},
    {
      'code': '1002',
      'name': '古典',
    },
  ],
  'categories': [
    {
      'code': '1001',
      'name': '卫衣',
    },
    {
      'code': '1002',
      'name': '毛衣',
    },
  ],
  'registrationDate': DateTime.now().toString(),
  'taxNumber': '41553315446687844',
  'bankOfDeposit': '中国工商银行',
  'certificate': [
    {
      'url':
          'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType': 'jpg',
    },
    {
      'url':
          'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType': 'jpg',
    },
    {
      'url':
          'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType': 'jpg',
    },
  ],
});

FactoryModel factoryModel = FactoryModel.fromJson({
  'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
  'uid': 'BB123456',
  'name': '草帽工厂',
  'starLevel': 5,
  'email': 'monkey.D.luffy@163.com',
  'phone': '020-12345678',
  'cooperationModes': ['FOB'],
  'developmentCapacity': true,
  'monthlyCapacityRanges': 'MCR003',
  'latheQuantity': 5,
  'contactPerson': 'luffy',
  'contactPhone': '13123456789',
  'address': {
    'fullname': "张三",
    'cellphone': '13123456789',
    'region': {'isocode': 'R123', 'name': '广东省'},
    'city': {'code': 'C123', 'name': '广州市'},
    'cityDistrict': {'code': 'D123', 'name': '海珠区'},
    'line1': '广州大道南',
  },
  'categories': [
    {
      'code': '1001',
      'name': '卫衣',
    },
    {
      'code': '1002',
      'name': '毛衣',
    },
  ],
  'cooperativeBrand': '红心海贼团',
  'scaleRange': 'SR005',
  'registrationDate': DateTime.now().toString(),
  'taxNumber': '41553315446687844',
  'bankOfDeposit': '中国工商银行',
  'certificate': [
    {
      'url':
          'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType': 'jpg',
    },
    {
      'url':
          'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType': 'jpg',
    },
    {
      'url':
          'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType': 'jpg',
    },
  ],
});

/// 认证信息
class MyCompanyPage extends StatefulWidget {
  _MyCompanyPageState createState() => _MyCompanyPageState();
}

class _MyCompanyPageState extends State<MyCompanyPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('认证信息'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: '编辑',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCompanyFormPage()),
                );
              },
            ),
          ],
        ),
        body: Container(
          child:
              bloc.isBrandUser ? _buildBrand(context) : _buildFactory(context),
        ));
  }

  Widget _buildBrand(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildBrandTop(context),
        _buildBrandInfo(context),
        _buildBrandAuthentication(context),
      ],
      padding: const EdgeInsets.all(10.0),
    );
  }

  Widget _buildFactory(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildFactoryTop(context),
        _buildFactoryInfo(context),
        _buildFactoryAuthentication(context),
      ],
      padding: const EdgeInsets.all(10.0),
    );
  }

  //品牌头部展示，头像及公司名
  Widget _buildBrandTop(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                brandModel.profilePicture,
              ),
              radius: 50.0,
            ),
            Container(
              color: Colors.white,
              child: Text(
                brandModel.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //品牌端信息
  Widget _buildBrandInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text('联系人'),
            trailing: Text(brandModel.contactPhone),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('联系电话'),
            trailing: Text(brandModel.contactPhone),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('经营地址'),
            trailing: Text(brandModel.address.region.name +
                brandModel.address.city.name +
                brandModel.address.cityDistrict.name +
                brandModel.address.line1),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('座机号码'),
            trailing: Text(brandModel.phone),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('邮箱地址'),
            trailing: Text(brandModel.email),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('品牌名称'),
            trailing: Text(brandModel.name),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('合作品牌'),
            trailing: Text(brandModel.cooperativeBrand),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('产业规模'),
            trailing: Text(ScaleRangesLocalizedMap[brandModel.scaleRange]),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('风格')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children:
                        _buildItemsByEntityList(context, brandModel.styles),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('擅长品类')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children:
                        _buildItemsByEntityList(context, brandModel.categories),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('年龄段')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children:
                        _buildItemsByStringList(context, brandModel.ageRanges),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('价格段（春夏）')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByStringList(
                        context, brandModel.priceRange1s),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('价格段（秋冬）')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByStringList(
                        context, brandModel.priceRange2s),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('品牌等级')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children:
                        _buildItemsStarIcon(context, brandModel.starLevel),
                  ),
                ),
              ],
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

  //品牌端认证信息
  Widget _buildBrandAuthentication(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              "认证信息",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("注册时间"),
            trailing:
                Text('${DateFormatUtil.format(brandModel.registrationDate)}'),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("税号"),
            trailing: Text(brandModel.taxNumber),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("开户行"),
            trailing: Text(brandModel.bankOfDeposit),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '认证证件',
                    )
                  ],
                ),
                Attachments(
                  list: brandModel.certificate,
                )
              ],
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

//工厂头像及名称
  Widget _buildFactoryTop(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                factoryModel.profilePicture,
              ),
              radius: 50.0,
            ),
            Container(
              color: Colors.white,
              child: Text(
                factoryModel.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //工厂端信息
  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text('联系人'),
            trailing: Text(factoryModel.contactPerson),
          ),
          Divider(
            height: 5,
          ),
          GestureDetector(
              child: ListTile(
                  leading: Text('联系电话'),
                  trailing: Text(factoryModel.contactPhone)),
              onTap: () {
                _selectActionButton('${factoryModel.contactPhone}');
              }),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('经营地址'),
            trailing: Text(factoryModel.address.region.name +
                factoryModel.address.city.name +
                factoryModel.address.cityDistrict.name +
                factoryModel.address.line1),
          ),
          Divider(
            height: 5,
          ),
          GestureDetector(
              child: ListTile(
                leading: Text('座机号码'),
                trailing: Text(factoryModel.phone),
              ),
              onTap: () {
                _selectActionButton('${factoryModel.phone}');
              }),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('邮箱地址'),
            trailing: Text(factoryModel.email),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('合作品牌'),
            trailing: Text(factoryModel.cooperativeBrand),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('产业规模'),
            trailing: Text(ScaleRangesLocalizedMap[factoryModel.scaleRange]),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('月均产能'),
            trailing: Text(MonthlyCapacityRangesLocalizedMap[
                factoryModel.monthlyCapacityRanges]),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('优势品类')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByEntityList(
                        context, factoryModel.categories),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('合作方式')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByStringList(
                        context, factoryModel.cooperationModes),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('开发能力'),
            trailing:
                Text(factoryModel.developmentCapacity == true ? '是' : '否'),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //工厂端认证信息
  Widget _buildFactoryAuthentication(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              "认证信息",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("注册时间"),
            trailing:
                Text('${DateFormatUtil.format(factoryModel.registrationDate)}'),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("车位数量"),
            trailing: Text(factoryModel.latheQuantity.toString()),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("税号"),
            trailing: Text(factoryModel.taxNumber),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("开户行"),
            trailing: Text(factoryModel.bankOfDeposit),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '认证证件',
                    )
                  ],
                ),
                Attachments(
                  list: factoryModel.certificate,
                )
              ],
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

  List<Widget> _buildItemsByEntityList(
      BuildContext context, List<dynamic> _list) {
    List<Widget> _widget = new List();
    if (_list.isNotEmpty) {
      for (int i = 0; i < _list.length; i++) {
        _widget.add(Container(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Text(_list[i].name),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(5),
          ),
        ));
      }
    }
    return _widget;
  }

  List<Widget> _buildItemsByStringList(
      BuildContext context, List<String> _list) {
    List<Widget> _widget = new List();
    if (_list.isNotEmpty) {
      for (int i = 0; i < _list.length; i++) {
        _widget.add(Container(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Text(_list[i]),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(5),
          ),
        ));
      }
    }
    return _widget;
  }

  List<Widget> _buildItemsStarIcon(BuildContext context, int starLevel) {
    List<Widget> _widget = new List();
    for (int i = 0; i < starLevel; i++) {
      _widget.add(Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      ));
    }
    return _widget;
  }

  void _selectActionButton(String tel) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('发送短信'),
              onTap: () async {
                var url = 'sms:' + tel;
                await launch(url);
              },
            ),
          ],
        );
      },
    );
  }
}
