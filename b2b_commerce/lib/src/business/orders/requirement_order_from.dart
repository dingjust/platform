import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_invoice_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_proofing_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_provide_sample_product_field.dart';
import 'package:b2b_commerce/src/business/orders/form/machining_type_field.dart';
import 'package:b2b_commerce/src/business/orders/form/max_expected_price_field.dart';
import 'package:b2b_commerce/src/business/orders/form/remarks_field.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:flutter/material.dart';
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

// TODO: change to RequirementOrderForm
class RequirementOrderFrom extends StatefulWidget {
  String factoryUid;
  ApparelProductModel product;

  RequirementOrderModel order;

  RequirementOrderFrom({this.product, this.order,this.factoryUid,});

  _RequirementOrderFromState createState() => _RequirementOrderFromState();
}

class _RequirementOrderFromState extends State<RequirementOrderFrom> {
  RequirementOrderModel model;
  bool _isShowMore = true;
  DateTime selectDate = DateTime.now();

  @override
  void initState() {
    if (widget.order != null) {
      model = widget.order;
      if (model.attachments == null) {
        model.attachments = [];
      }
      if (model.details.pictures == null) {
        model.details.pictures = [];
      }
    } else {
      model = RequirementOrderModel(
          details: RequirementInfoModel(), attachments: []);
    }

    if (widget.product != null) {
      model.details.category = widget.product.category;
      if (widget.product?.category != null) {}
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
                    style: TextStyle(color: Colors.black),
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
                  setState(() {
                    model.details.pictures = widget.product.images;
                    model.details.productName = widget.product.name;
                    model.details.productSkuID = widget.product.skuID;
                    if (widget.product.category != null) {
                      model.details.category = widget.product.category;
                    }
                  });
                }
              })
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _buildBody(context),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 16,
          child: ActionChip(
            labelPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 2.8,
                vertical: 8),
            backgroundColor: Color.fromRGBO(255, 214, 12, 1),
            label: Text(widget.order != null ? '修改需求' : '确定发布'),
            labelStyle: TextStyle(color: Colors.black, fontSize: 20),
            onPressed: () {
              widget.order != null ? onUpdate() : onPublish(widget.factoryUid);
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
            PicturesField(
              model: model,
            ),
            Offstage(
              offstage: widget.product == null,
              child: ProductField(widget.product),
            ),
            CategoryField(
              model,
              product: widget.product,
            ),
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
//            _isShowMore ? Container() : new Divider(height: 0),
            _buildHideBody(context),
//            _buildHideTips(context),
            Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '附件',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                EditableAttachments(
                  list: model.attachments,
                  maxNum: 5,
                )
              ],
            )
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

  /// 发布
  void onPublish(String factoryUid) async {
    print(factoryUid);
    String code = await RequirementOrderRepository().publishNewRequirement(
        model, factoryUid, factoryUid != null ? true : false);
    if (code != null && code != '') {
      model.code = code;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => PublishRequirementSuccessDialog(
                  model: model,
                ),
          ),
          ModalRoute.withName('/'));
    }
  }

  ///完善信息
  void onUpdate() async {
    String code = await RequirementOrderRepository().updateRequirement(model);
    if (code != null) {
      //根据code查询明
      RequirementOrderModel model =
          await RequirementOrderRepository().getRequirementOrderDetail(code);

      List<QuoteModel> quotes = await RequirementOrderRepository()
          .getRequirementOrderQuotes(code: model.code, page: 0, size: 1);

      if (model != null && quotes != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => RequirementOrderDetailPage(
                    order: model,
                    quotes: quotes,
                  ),
            ),
            ModalRoute.withName('/'));
      }
    } else {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('更新失败'),
          );
        },
      );
    }
  }
}
