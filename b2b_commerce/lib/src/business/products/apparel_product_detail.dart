import 'package:b2b_commerce/src/business/products/apparel_product_prices_input.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:b2b_commerce/src/business/products/form/stocks_field.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/attributes_field.dart';
import 'form/color_size_stock_field.dart';
import 'form/detail_picture_field.dart';
import 'form/minor_category_field.dart';
import 'form/normal_picture_field.dart';

class ApparelProductDetailPage extends StatefulWidget {
  ApparelProductDetailPage({
    Key key,
    @required this.item,
    this.status = 'ALL',
    this.keyword,
    this.enabled = false,
  }) : super(key: const Key('__ApparelProductDetailPage__'));

  ApparelProductModel item;
  final String status;
  final String keyword;
  final bool enabled;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductDetailPage> {
  bool _enabled = false;
  bool _isToRefreshList = false;

  @override
  void initState() {
    _enabled = widget.enabled;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context,_isToRefreshList);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('产品明细'),
          actions: <Widget>[
            Offstage(
              offstage: widget.item.approvalStatus == ArticleApprovalStatus.approved,
              child: IconButton(
                icon: Text('编辑'),
                onPressed: () async{
                  dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ApparelProductFormPage(
                    item: widget.item,
                    isCreate: false,
                  )));
                  if(result != null && result){
                    ApparelProductModel model = await ProductRepositoryImpl().detail(widget.item.code);
                    setState(() {
                      widget.item = model;
                      _isToRefreshList = true;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            NormalPictureField(
              widget.item,
              enabled: _enabled,
            ),
            DetailPictureField(
              widget.item,
              enabled: _enabled,
            ),
           _buildProductType(context),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('产品标题',style: TextStyle(fontSize: 16,),),
                  Text('${widget.item.name ?? ''}',style: TextStyle(fontSize: 16,color: Colors.grey,),),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('产品货号',style: TextStyle(fontSize: 16,),),
                  Text('${widget.item.skuID ?? ''}',style: TextStyle(fontSize: 16,color: Colors.grey,),),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: MinorCategoryField(
                widget.item,
                enabled: _enabled,
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
                    child: Text('颜色',style: TextStyle(fontSize: 16),),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('${colorInfo()}',style: TextStyle(fontSize: 16,color: Colors.grey,),textAlign: TextAlign.right,),
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
                    child: Text('尺码',style: TextStyle(fontSize: 16),),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('${sizeInfo()}',style: TextStyle(fontSize: 16,color: Colors.grey,),textDirection: TextDirection.rtl,),
                  )
                ],
              ),
            ),
            Offstage(
              offstage: !(widget.item.productType.contains(ProductType.SPOT_GOODS) || widget.item.productType.contains(ProductType.TAIL_GOODS)),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: GestureDetector(
                  behavior:HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StocksField(widget.item,enabled: false,)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '库存明细',
                                    style: TextStyle(color: Colors.black,fontSize: 16,)
                                ),
                              ]
                          ),
                        ),
                      ),
                      Text('库存总数量：${_colorTotalNum()}',style: TextStyle(color: Colors.grey,),),
                      Icon(Icons.chevron_right,color: Colors.blueGrey,),
                    ],
                  ),
                ),
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
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '面料成分',
                                style: TextStyle(color: Colors.black,fontSize: 16,)
                            ),
                          ]
                      ),
                    ),
                  ),
                  Expanded(flex: 3,child: Text('${fabricSelectText()}',style: TextStyle(color: Colors.grey,),textDirection: TextDirection.rtl,)),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('品牌',style: TextStyle(fontSize: 16,),),
                  Text('${widget.item.brand ?? ''}',style: TextStyle(fontSize: 16,color: Colors.grey,),),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      ApparelProductPricesInputPage(
                        widget.item,)));
                },
                child: ShowSelectTile(
                  leadingText: '价格明细',
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('重量',style: TextStyle(fontSize: 16,),),
                  Text('${widget.item.gramWeight ?? ''}',style: TextStyle(fontSize: 16,color: Colors.grey,),),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: AttributesField(
                widget.item,
                enabled: _enabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildProductType(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: '产品类型',
                            style: TextStyle(color: Colors.black,fontSize: 16,)
                        ),
                      ]
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: (context),
                        builder: (context) {
                          return MessageDialog(
                            title: Text(
                              '如何选择产品类型',
                              style: TextStyle(fontSize: 18),
                            ),
                            message: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                    '注：库存尾货不能和现货、期货同时选择',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black)),
                              ]),
                            ),
                            onCloseEvent: () {
                              Navigator.pop(context);
                            },
                            negativeText: '我知道了',
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 0),
                    child: Icon(
                      Icons.help,
                      color: Colors.red,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
              children: ProductType.values.where((v) => v != ProductType.DEFAULT_GOODS).map((type){
                return Row(
                  children: <Widget>[
                    Checkbox(
                      onChanged: (v) {
                        return;
                      },
                      activeColor: Colors.orange,
                      value: widget.item.productType.contains(type),
                    ),
                    Text(
                      ProductTypeLocalizedMap[type],
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(color: widget.item.productType.contains(type) ? Colors.black : Colors.grey),
                    )
                  ],
                );
              }).toList()
          )
        ],
      ),
    );
  }

  int _colorTotalNum() {
    int result = 0;
    widget.item.colorSizes?.forEach((colorSize) {
      colorSize.sizes.forEach((size){
        result += size.quality ?? 0;
      });
    });
    return result;
  }

  //格式化颜色(明细)
  String colorInfo() {
    String colorText = '';
    if(widget.item.colorSizes != null && widget.item.colorSizes.length > 0){
      colorText = widget.item.colorSizes.map((color)=>color.colorName).join('、');
    }

    return colorText;
  }

  //格式化尺码(明细)
  String sizeInfo() {
    String sizeText = '';
    if(widget.item.colorSizes != null && widget.item.colorSizes.length > 0){
      for(int i=0;i < widget.item.colorSizes.length;i++){
        if(sizeText == '' && widget.item.colorSizes[i].sizes != null && widget.item.colorSizes[i].sizes.length > 0){
          sizeText = widget.item.colorSizes[i].sizes.map((size) => size.name).join('、');
        }
      }
    }

    return sizeText;
  }

  //格式化选中的面料成分
  String fabricSelectText() {
    String text = '';
    if(widget.item.fabricCompositions != null){
      text = enumCodesToNames(widget.item.fabricCompositions, FabricCompositionEnum).join('、');
    }
    return text;
  }
}
