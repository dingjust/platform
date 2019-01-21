import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/detail_picture_field.dart';
import 'form/normal_picture_field.dart';
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

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({Key key, this.item})
      : super(key: const Key('__apparelProductFormPage__'));

  final ApparelProductModel item;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductFormPage> {
  final GlobalKey _apparelProductForm = GlobalKey<FormState>();

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
        centerTitle: true,
        title: Text('编辑商品'),
      ),
      body: Form(
        key: _apparelProductForm,
        autovalidate: false,
        child: ListView(
          children: <Widget>[
            NameField(widget.item),
            SkuIDField(widget.item),
            DetailPictureField(widget.item),

            NormalPictureField(widget.item),

            MinorCategoryField(widget.item),
            BrandField(widget.item),
            PricesField(widget.item),
            GramWeightField(widget.item),
            ColorSizeStockField(widget.item),
            AttributesField(widget.item),
            PrivacyField(widget.item),
            PostageFreeField(widget.item),
            Container(
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
            ),
          ],
        ),
      ),
    );
//        }
//        );
  }
}
