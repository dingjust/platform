import 'package:b2b_commerce/src/my/company/my_company_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

BrandModel brandModel = BrandModel.fromJson({
  'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
  'uid': 'BB123456',
  'name': '草帽商店',
  'starLevel': 5,
  'email': 'monkey.D.luffy@163.com',
  'telephone': '020-12345678',
  'members': {
    'name': 'luffy',
    'phone': '13123456789',
  },
  'contactAddress': {
    'fullname': "张三",
    'cellphone': '13123456789',
    'region': {'isocode': 'R123', 'name': '广东省'},
    'city': {'code': 'C123', 'name': '广州市'},
    'cityDistrict': {'code': 'D123', 'name': '海珠区'},
    'line1': '广州大道南',
  },
  'brandName': '草帽海贼团',
  'cooperativeBrand': '红心海贼团',
  'scaleRange': 'SR005',
  'ageRanges':['16-22','23-30'],
  'priceRange1s':['1000-3999','4999-9999'],
  'priceRange2s' :['5999-9999','10000-19999'],
  'styles':[
    {
      'code':'1001',
      'name':'潮流'
    },
    {
      'code':'1002',
      'name':'古典',
    },
  ],
  'categories':[
    {
      'code':'1001',
      'name':'卫衣',
    },
    {
      'code':'1002',
      'name':'毛衣',
    },
  ],
  'registrationDate': DateTime.now().toString(),
  'taxNumber':'41553315446687844',
  'bankOfDeposit':'中国工商银行',
  'certificate':[
    {
      'url':'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType':'jpg',
    },
    {
      'url':'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType':'jpg',
    },
    {
      'url':'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
      'mediaType':'jpg',
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
      body: ListView(
        children: <Widget>[
          _buildTop(context),
          _buildInfo(context),
          _buildAuthentication(context),
        ],
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }

  //头部展示，头像及公司名
  Widget _buildTop(BuildContext context){
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
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
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
  Widget _buildInfo(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text('联系人'),
            trailing: Text(brandModel.members.name),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('联系电话'),
            trailing: Text(brandModel.members.phone),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('经营地址'),
            trailing: Text(brandModel.contactAddress.region.name +
                brandModel.contactAddress.city.name +
                brandModel.contactAddress.cityDistrict.name +
                brandModel.contactAddress.line1),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('座机号码'),
            trailing: Text(brandModel.telephone),
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
            trailing: Text(brandModel.brandName),
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
                Expanded(
                    child: Text('风格')
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByEntityList(context, brandModel.styles),
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
                Expanded(
                    child: Text('擅长品类')
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByEntityList(context, brandModel.categories),
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
                Expanded(
                    child: Text('年龄段')
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByStringList(context, brandModel.ageRanges),
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
                Expanded(
                    child: Text('价格段（春夏）')
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByStringList(context, brandModel.priceRange1s),
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
                Expanded(
                    child: Text('价格段（秋冬）')
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsByStringList(context, brandModel.priceRange2s),
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
                Expanded(
                    child: Text('品牌等级')
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: _buildItemsStarIcon(context, brandModel.starLevel),
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

  List<Widget> _buildItemsByEntityList(BuildContext context, List<dynamic> _list) {
    List<Widget> _widget = new List();
    if (_list.isNotEmpty) {
      for (int i = 0; i < _list.length; i++) {
        _widget.add(
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                  _list[i].name
              ),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(5),
              ),
            )
        );
      }
    }
    return _widget;
  }

  List<Widget> _buildItemsByStringList(BuildContext context, List<String> _list) {
    List<Widget> _widget = new List();
    if (_list.isNotEmpty) {
      for (int i = 0; i < _list.length; i++) {
        _widget.add(
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                  _list[i]
              ),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(5),
              ),
            )
        );
      }
    }
    return _widget;
  }

  List<Widget> _buildItemsStarIcon(BuildContext context, int starLevel) {
    List<Widget> _widget = new List();
      for (int i = 0; i < starLevel; i++) {
        _widget.add(
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            )
        );
    }
    return _widget;
  }

  //品牌端认证信息
  Widget _buildAuthentication(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              "认证信息",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18
              ),
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text("注册时间"),
            trailing: Text('${DateFormatUtil.format(brandModel.registrationDate)}'),
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

}
