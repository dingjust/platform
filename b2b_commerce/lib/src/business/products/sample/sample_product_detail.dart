import 'package:b2b_commerce/src/business/products/form/attributes_field.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'sample_product_form.dart';

class SampleProductDetailPage extends StatefulWidget {
  SampleProductDetailPage(
    this.code, {
    Key key,
  }) : super(key: const Key('SampleProductDetailPage'));

  final String code;

  _ApparelProductBrandFormState createState() =>
      _ApparelProductBrandFormState();
}

class _ApparelProductBrandFormState extends State<SampleProductDetailPage> {
  SampleProductModel model;

  bool _isToRefreshList = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _isToRefreshList);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('产品明细'),
          actions: <Widget>[
            IconButton(
                icon: Text('编辑'),
                onPressed: () async {
                  dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SampleProductFormPage(
                                item: model,
                                isCreate: false,
                                enabled: true,
                              )));
                  if (result != null && result) {
                    setState(() {
                      model = null;
                      _isToRefreshList = true;
                    });
                  }
                }),
          ],
        ),
        body: FutureBuilder<SampleProductModel>(
            initialData: null,
            future: _getData(),
            builder: (BuildContext context,
                AsyncSnapshot<SampleProductModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasError && snapshot.hasData) {
                  return _buildBody();
                } else {
                  return Center(
                    child: Text('查询失败，请稍后再试！'),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                '产品主图',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        EditableAttachments(
          list: model.images,
          editable: false,
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                '产品详情图',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        EditableAttachments(
          list: model.details,
          editable: false,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '产品标题',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${model.name ?? ''}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '产品货号',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${model.skuID ?? ''}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '产品品类',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '${productCategoryInfo()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '颜色',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${colorInfo()}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '尺码',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${sizeInfo()}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '面料成分',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        )),
                  ]),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                    '${fabricSelectText()}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textDirection: TextDirection.rtl,
                  )),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '品牌',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${model.brand ?? ''}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '重量',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${model.gramWeight ?? ''}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
//            Container(
//              color: Colors.white,
//              padding: EdgeInsets.all(15),
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    flex: 1,
//                    child: RichText(
//                      text: TextSpan(
//                          children: [
//                            TextSpan(
//                                text: '属性',
//                                style: TextStyle(color: Colors.black,fontSize: 16,)
//                            ),
//                          ]
//                      ),
//                    ),
//                  ),
//                  Expanded(flex: 3,child: Text('${attrbuteSelectText(model.attributes)}',style: TextStyle(color: Colors.grey,),textDirection: TextDirection.rtl,)),
//                ],
//              )
//            ),
        Container(
          color: Colors.white,
          child: AttributesField(
            model,
            enabled: false,
          ),
        ),
      ],
    );
  }

  Future<SampleProductModel> _getData() async {
    if (model == null) {
      SampleProductModel detailModel =
          await SampleProductRepository.getDetail(widget.code);
      model = detailModel;
    }
    return model;
  }

  //格式化产品分类(明细)
  String productCategoryInfo() {
    String text = '';
    if (model.category.parent != null) {
      text += model.category.parent.name;
      text += '-';
    }
    text += model.category?.name ?? '';

    return text;
  }

  //格式化颜色(明细)
  String colorInfo() {
    String colorText = '';
    if (model.colorSizes != null && model.colorSizes.length > 0) {
      colorText = model.colorSizes.map((color) => color.colorName).join('、');
    }

    return colorText;
  }

  //格式化尺码(明细)
  String sizeInfo() {
    String sizeText = '';
    if (model.colorSizes != null && model.colorSizes.length > 0) {
      for (int i = 0; i < model.colorSizes.length; i++) {
        if (sizeText == '' &&
            model.colorSizes[i].sizes != null &&
            model.colorSizes[i].sizes.length > 0) {
          sizeText =
              model.colorSizes[i].sizes.map((size) => size.name).join('、');
        }
      }
    }

    return sizeText;
  }

  //格式化选中的面料成分
  String fabricSelectText() {
    String text = '';
    if (model.attributes != null &&
        model.attributes.fabricCompositions != null) {
      text = enumCodesToNames(
              model.attributes.fabricCompositions, FabricCompositionEnum)
          .join('、');
    }
    return text;
  }

  //格式化选中的属性
  String attrbuteSelectText(ApparelProductAttributesModel attr) {
    String text = '';
    if (attr != null) {
      if (attr.styles != null && attr.styles.length > 0) {
        text += '风格--';
        text += enumCodesToNames(attr.styles, StyleEnum).join('、');
        text += '\n';
      }
      if (attr.editionType != null) {
        text += '版型--${enumMap(EditionTypeEnum, attr.editionType)}';
        text += '\n';
      }
      if (attr.pattern != null) {
        text += '款式--${enumMap(PatternEnum, attr.pattern)}';
        text += '\n';
      }
      if (attr.sleeveType != null) {
        text += '袖型--${enumMap(SleeveTypeEnum, attr.sleeveType)}';
        text += '\n';
      }
      if (attr.sleeveLength != null) {
        text += '袖长/裤腿--${enumMap(SleeveLengthEnum, attr.sleeveLength)}';
        text += '\n';
      }
      if (attr.decorativePatterns != null &&
          attr.decorativePatterns.length > 0) {
        text += '图案--';
        text += enumCodesToNames(attr.decorativePatterns, DecorativePatternEnum)
            .join('、');
        text += '\n';
      }
      if (attr.popularElements != null && attr.popularElements.length > 0) {
        text += '流行元素--';
        text += enumCodesToNames(attr.popularElements, PopularElementsEnum)
            .join('、');
        text += '\n';
      }
      if (attr.filler != null) {
        text += '填充物--${enumMap(FillerEnum, attr.filler)}';
        text += '\n';
      }
      if (attr.thickness != null) {
        text += '厚薄--${enumMap(ThicknessEnum, attr.thickness)}';
        text += '\n';
      }
      if (attr.season != null) {
        text += '季节--${enumMap(SeasonEnum, attr.season)}';
        text += '\n';
      }
      if (attr.taggable != null) {
        text += '吊牌--${attr.taggable ? '有' : '没有'}';
        text += '\n';
      }
      if (attr.placket != null) {
        text += '门襟--${enumMap(PlacketEnum, attr.placket)}';
        text += '\n';
      }
    }
    return text;
  }
}
