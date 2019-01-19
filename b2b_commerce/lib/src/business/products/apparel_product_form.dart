import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'apparel_product_attributes_input.dart';
import 'apparel_product_prices_input.dart';
import 'apparel_product_privacy_select.dart';
import 'apparel_product_stock_input.dart';
import 'apparel_product_variants_input.dart';
import 'form/detail_picture_field.dart';
import 'form/master_picture_field.dart';
import 'form/minor_category_field.dart';
import 'form/name_field.dart';
import 'form/sku_id_field.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({Key key, this.item}) :super(key: const Key('__apparelProductFormPage__'));

  final ApparelProductModel item;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductFormPage> {
  bool _postageFree = false;
  final GlobalKey _apparelProductForm = GlobalKey<FormState>();

  FocusNode _brandFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    _brandController.text = widget.item?.brand;
    _weightController.text = widget.item?.gramWeight?.toString();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ApparelProductBLoC>(context);
    debugPrint(bloc.currentProduct.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('编辑商品'),
      ),
      body: Container(
//        color: Colors.grey[200],
        child: Form(
          key: _apparelProductForm,
          autovalidate: false,
          child: ListView(
            children: <Widget>[
              MasterPictureField(widget.item),
              DetailPictureField(widget.item),
              NameField(widget.item),
              SkuIDField(widget.item),
              MinorCategoryField(widget.item),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.grey[400],
                ),
              ),
              TextFieldComponent(
                focusNode: _brandFocusNode,
                controller: _brandController,
                leadingText: '品牌',
                hintText: '请输入品牌，必填',
              ),
              InkWell(
                onTap: () async {
                  Map<String, double> priceMap = Map();
                  priceMap['price'] = widget.item?.price;
                  priceMap['suggestedPrice'] = widget.item?.suggestedPrice;
                  priceMap['price1'] = widget.item?.price1;
                  priceMap['price2'] = widget.item?.price2;
                  priceMap['price3'] = widget.item?.price3;

                  Map<String, double> result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductPricesInputPage(
                            priceMap: priceMap,
                          ),
                    ),
                  );

                  if (result != null && result.length > 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(result.toString()),
                          ),
                    );
                  }
                },
                child: ListTile(
                  title: Text('价格'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.grey[400],
                ),
              ),
              TextFieldComponent(
                focusNode: _weightFocusNode,
                controller: _weightController,
                inputType: TextInputType.number,
                leadingText: '重量',
                hintText: '请输入重量，必填',
              ),
              InkWell(
                onTap: () async {
                  dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductVariantsInputPage(),
                    ),
                  );

                  if (result != null && result.length > 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(result.toString()),
                          ),
                    );
                  }
                },
                child: ListTile(
                  title: Text('颜色/尺码'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.grey[400],
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.grey[400],
                ),
              ),
              InkWell(
                onTap: () {
//                  print(widget.item.attributes.styles);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductAttributesInputPage(
                            item: widget.item,
                          ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('属性'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.grey[400],
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
                  title: Text('款式保护'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.grey[400],
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
                      setState(() {
                        _postageFree = val;
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ActionChip(
                        backgroundColor: Colors.red,
                        labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                        labelStyle: TextStyle(fontSize: 16),
                        label: Text('发布商品'),
                        onPressed: () {
                          // print(_masterImages);
                        },
                      ),
                    ),
                    Expanded(
                      child: ActionChip(
                        backgroundColor: Colors.orange,
                        labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                        labelStyle: TextStyle(fontSize: 16),
                        label: Text('直接上架'),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
