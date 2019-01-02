import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'apparel_product_attributes_input.dart';
import 'apparel_product_prices_input.dart';
import 'apparel_product_privacy_select.dart';
import 'apparel_product_stock_input.dart';
import 'apparel_product_variants_input.dart';

class ApparelProductFormPage extends StatelessWidget {
  ApparelProductFormPage({this.item});

  final ApparelProductModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('创建/更新商品'),
      ),
      body: Container(
        color: Colors.grey[200],
        child: EditableApparelProductForm(item),
      ),
    );
  }
}

class EditableApparelProductForm extends StatelessWidget {
  EditableApparelProductForm(this.item);

  final ApparelProductModel item;

  final bool _postageFree = false;

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '产品名称',
              hintText: '请输入产品名称，必填',
            ),
          ),
        ),
        ListTile(
          title: TextField(
            decoration: InputDecoration(
              labelText: '产品货号',
              hintText: '请输入产品货号，必填',
            ),
          ),
        ),
        ListTile(
          title: TextField(
            decoration: InputDecoration(
              labelText: '品牌',
              hintText: '请输入品牌，必填',
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      '选择大类',
                      <EnumModel>[
                        EnumModel('R001', '针织'),
                        EnumModel('R002', '其他'),
                      ],
                    ),
              ),
            );
          },
          child: ListTile(
            title: Text('选择大类'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      '选择小类',
                      <EnumModel>[
                        EnumModel('R001', '针织'),
                        EnumModel('R002', '其他'),
                      ],
                    ),
              ),
            );
          },
          child: ListTile(
            title: Text('选择小类'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductPricesInputPage(),
              ),
            );
          },
          child: ListTile(
            title: Text('价格'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        ListTile(
          title: TextField(
            decoration: InputDecoration(
              labelText: '重量',
              hintText: '请输入重量，必填',
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductVariantsInputPage(),
              ),
            );
          },
          child: ListTile(
            title: Text('颜色/尺码'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductStockInputPage(),
              ),
            );
          },
          child: ListTile(
            title: Text('库存'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductAttributesInputPage(),
              ),
            );
          },
          child: ListTile(
            title: Text('属性'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductPrivacySelectPage(),
              ),
            );
          },
          child: ListTile(
            title: Text('隐私保护'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            title: Text('是否免邮'),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            trailing: Switch(
              value: _postageFree,
              activeColor: Colors.pink,
              onChanged: (bool val) {
                /* setState(() {
                  _postageFree = val;
                });*/
              },
            ),
          ),
        ),
      ],
    );
  }
}
