import 'dart:io';

import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/delivery_address_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_invoice_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_proofing_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_provide_sample_product_field.dart';
import 'package:b2b_commerce/src/business/orders/form/machining_type_field.dart';
import 'package:b2b_commerce/src/business/orders/form/max_expected_price_field.dart';
import 'package:b2b_commerce/src/business/orders/form/remarks_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../home/requirement/requirement_publish_success.dart';
import '../apparel_products.dart';
import 'form/category_field.dart';
import 'form/expected_machining_quantity.dart';
import 'form/major_category_field.dart';
import 'form/pictures_field.dart';
import 'form/product_field.dart';
import 'form/production_areas_field.dart';

class RequirementOrderFrom extends StatefulWidget {
  ApparelProductModel product;

  RequirementOrderFrom({this.product});

  _RequirementOrderFromState createState() => _RequirementOrderFromState();
}

class _RequirementOrderFromState extends State<RequirementOrderFrom> {
  RequirementOrderModel model =
      RequirementOrderModel(details: RequirementInfoModel());
  List<CategoryModel> _categorySelected = [];
  bool _isShowMore = true;

  DateTime selectDate = DateTime.now();

  @override
  void initState() {
    if (widget.product != null) {
      model.details.category = widget.product.category;
      if (widget.product?.category != null) {
        _categorySelected = [widget.product.category];
      }
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('需求发布'),
        elevation: 0.5,
        brightness: Brightness.light,
        centerTitle: true,
        actions: <Widget>[
          /*IconButton(
                icon: Icon(Icons.play_for_work),
                color: Color.fromRGBO(255, 149, 22, 1),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequirementImportProduct(),
                      ),
                    )),*/
          GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Center(
                  child: Text(
                    '导入商品',
                    style: TextStyle(color: Color.fromRGBO(255, 149, 22, 1)),
                  ),
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApparelProductsPage(
                          isRequirement: true,
                          item: widget.product,
                        ),
                  ),
                );

                //TODO：导入商品后的一系列操作
                widget.product = result;
                if (result != null) {
                  model.details.productName = widget.product.name;
                  model.details.productSkuID = widget.product.skuID;
                  _categorySelected = [widget.product.category];
                }

                model.details.category =
                    _categorySelected.length > 0 ? _categorySelected[0] : null;
//                if (model.details.pictures != null) {
//                  model.details.pictures.forEach((media) {
//                    //缓存图片并获取缓存图片
////                      CacheManager.getInstance().then((cacheManager){
////                        cacheManager.getFile(media.url).then((file){
////                          _normalImages.add(file);
////                        });
////                      });
//                    DefaultCacheManager().getSingleFile(media.url).then((file) {
//                      setState(() {
//                        _normalImages.add(file);
//                      });
//                    });
//                  });
//                }
              })
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _buildBody(context),
//            _buildCommitButton(context),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 16,
          child: ActionChip(
            shape:
            StadiumBorder(side: BorderSide(color: Color(0xffFF9516))),
            labelPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/2.8,vertical: 8),
            backgroundColor: Color(0xffFF9516),
            label: Text('确定发布'),
            labelStyle: TextStyle(color: Colors.white,fontSize: 20),
            onPressed: () async{
              model.entries = [
                RequirementOrderEntryModel(
                    product: widget.product, order: model)
              ];
//                print('${_normalImages}');
//                print(
//                    '${model.code},${model.details.majorCategory},${model.details.category}');
//                print(
//                    '${model.details.expectedMachiningQuantity},${model.details.maxExpectedPrice},${model.details.expectedDeliveryDate},${model.details.contactPerson},${model.details.contactPhone}');
//                print(
//                    '${model.details.region},${model.details.productiveOrientations},${model.details.machiningType},${model.details.proofingNeeded},${model.details.samplesNeeded}');
//                print(
//                    '${model.details.invoiceNeeded},${model.remarks},${model.details.isToRequirementPool}');


              await RequirementOrderRepository().publishNewRequirement(model);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublishRequirementSuccessDialog(
                    model: model,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: <Widget>[
//            _buildPic(context),
            PicturesField(widget.product  ),
            Offstage(
              offstage: widget.product == null,
              child: ProductField(widget.product),
            ),
            CategoryField(model, widget.product),
            new Divider(height: 0),
            MajorCategoryField(model),
            new Divider(height: 0),
            ExpectedMachiningQuantityField(model),
            new Divider(height: 0),
            MaxExpectedPriceField(model),
            new Divider(height: 0),
            ExpectedDeliveryDateField(model),
            new Divider(height: 0),
            ContactWayField(model),
            new Divider(height: 0),
            DeliveryAddressField(model),
//            _isShowMore ? Container() : new Divider(height: 0),
            _buildHideBody(context),
//            _buildHideTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHideBody(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            ProductionAreasField(model),
            new Divider(height: 0),
            MachiningTypeField(model),
            new Divider(height: 0),
            IsProofingField(model),
            new Divider(height: 0),
            IsProvideSampleProductField(model),
            new Divider(height: 0),
            IsInvoiceField(model),
            new Divider(height: 0),
            RemarksField(model),
          ],
        ),
      ),
    );
  }

  //是否展开更多
  Widget _buildHideTips(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(''),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '继续完善需求信息，更加精准匹配工厂',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    '更多条件',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF9516),
                    ),
                  ),
                  Icon(
                    _isShowMore
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Color(0xFFFF9516),
                    size: 28,
                  ),
                ],
              )),
          decoration: BoxDecoration(
            color: Color.fromRGBO(242, 242, 242, 1),
          ),
        ),
        onTap: () {
          setState(() {
            _isShowMore = !_isShowMore;
          });
        });
  }

  //确认发布按钮
  Widget _buildCommitButton(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '确定发布',
                style: TextStyle(
                  color: Color.fromRGBO(36, 38, 41, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () async {
                model.entries = [
                  RequirementOrderEntryModel(
                      product: widget.product, order: model)
                ];
//                print('${_normalImages}');
//                print(
//                    '${model.code},${model.details.majorCategory},${model.details.category}');
//                print(
//                    '${model.details.expectedMachiningQuantity},${model.details.maxExpectedPrice},${model.details.expectedDeliveryDate},${model.details.contactPerson},${model.details.contactPhone}');
//                print(
//                    '${model.details.region},${model.details.productiveOrientations},${model.details.machiningType},${model.details.proofingNeeded},${model.details.samplesNeeded}');
//                print(
//                    '${model.details.invoiceNeeded},${model.remarks},${model.details.isToRequirementPool}');

                String code = await RequirementOrderRepository()
                    .publishNewRequirement(model);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PublishRequirementSuccessDialog(
                          model: model,
                        ),
                  ),
                );
              },
            ),
          ),
//          Container(
//            margin: EdgeInsets.all(0),
//            padding: EdgeInsets.all(0),
//            width: 200,
//            child: Center(
//              child: CheckboxListTile(
//                title: Text(
//                  '发布到需求池',
//                  style: TextStyle(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 14,
//                      color: Colors.grey),
//                ),
//                value: model.details.isToRequirementPool,
//                onChanged: (T) {
//                  setState(() {
//                    model.details.isToRequirementPool =
//                        !model.details.isToRequirementPool;
//                  });
//                },
//              ),
//            ),
//          )
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 242, 242, 1),
      ),
    );
  }
}
