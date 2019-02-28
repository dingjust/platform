import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'form/minor_category_field.dart';
import 'form/name_field.dart';
import 'form/sku_id_field.dart';
import 'form/brand_field.dart';
import 'form/prices_field.dart';
import 'form/gram_weight_field.dart';
import 'form/color_size_stock_field.dart';
import 'form/attributes_field.dart';
import 'form/privacy_field.dart';
import 'form/postage_free_field.dart';
import 'form/normal_picture_field.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({Key key, @required this.item,this.isCreate = false})
      : super(key: const Key('__apparelProductFormPage__'));

  final ApparelProductModel item;
  final bool isCreate;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductFormPage> {
  final GlobalKey<FormState> _apparelProductForm = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    var bloc = BLoCProvider.of<ApparelProductBLoC>(context);
//    debugPrint(bloc.currentProduct.toString());
//    return StreamBuilder(
//        stream: bloc.detailStream,
//        initialData: bloc.currentProduct,
//        builder: (BuildContext context,
//            AsyncSnapshot<ApparelProductModel> snapshot) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('编辑商品'),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: Color(0xffFF9516)),
            ),
            onPressed: (){
//              print(widget.item.normalFiles);
////              print(widget.item.name);
////              print(widget.item.skuID);
////              print(widget.item.minorCategory?.name);
////              print(widget.item.brand);
////              print(widget.item.price);
////              print(widget.item.gramWeight);
////              if(widget.item.variants != null){
////                print('color'+widget.item?.variants[0]?.color?.name.toString());
////                print('size'+widget.item?.variants[0]?.size?.name.toString());
////              }
////              print(widget.item.attributes.styles[0]);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          NormalPictureField(widget.item,widget.isCreate),
//            DetailPictureField(widget.item),
          NameField(widget.item),
          SkuIDField(widget.item),
          MinorCategoryField(widget.item),
          ColorSizeStockField(widget.item),
          BrandField(widget.item),
          PricesField(widget.item),
          GramWeightField(widget.item),
          AttributesField(widget.item),
//            PrivacyField(widget.item),
//            PostageFreeField(widget.item),
          /*Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ActionChip(
                    backgroundColor: Colors.red,
                    labelPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                    labelStyle: TextStyle(fontSize: 16),
                    label: Text('发布商品'),
                    onPressed: () {
                      // TODO:默认下架
                    },
                  ),
                ),
                Expanded(
                  child: ActionChip(
                    backgroundColor: Colors.orange,
                    labelPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                    labelStyle: TextStyle(fontSize: 16),
                    label: Text('直接上架'),
                    onPressed: () {
                      // TODO:直接上架
                    },
                  ),
                )
              ],
            ),
          ),*/
        ],
      ),
    );
//        }
//        );
  }
}
