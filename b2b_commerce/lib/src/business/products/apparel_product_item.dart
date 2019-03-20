import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../orders/requirement_order_from.dart';

class ApparelProductItem extends StatefulWidget {
  ApparelProductItem(this.item,
      {this.isRequirement = false, this.isSelectItem = false});

  final ApparelProductModel item;
  final bool isRequirement;
  final bool isSelectItem;

  ApparelProductItemState createState() => ApparelProductItemState();
}

class ApparelProductItemState extends State<ApparelProductItem> {
  bool _isRecommend;
  String _approvalStatusText;

  @override
  void initState() {
    _isRecommend = widget.item.isRecommend;

    if (widget.item.approvalStatus == ArticleApprovalStatus.APPROVED) {
      _approvalStatusText = '下架';
    } else if (widget.item.approvalStatus == ArticleApprovalStatus.UNAPPROVED) {
      _approvalStatusText = '上架';
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isRequirement) Navigator.pop(context, widget.item);
        // if(widget.isSelectItem) 
      },
      child: Card(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        elevation: 0,
        child: Column(
          children: <Widget>[
            _buildProduct(context),
            Offstage(
              offstage: widget.isRequirement,
              child: _buildButtons(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: widget.item.thumbnail != null
                      ? NetworkImage(
                          '${GlobalConfigs.IMAGE_BASIC_URL}${widget.item.thumbnail.url}')
                      : AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        ),
                  fit: BoxFit.cover,
                )),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.item.name,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：' + widget.item.skuID,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${widget.item?.category?.name}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  ),
//                  Row(
//                    children: <Widget>[
//                      Text('￥', style: TextStyle(color: Color.fromRGBO(255,214,12, 1))),
//                      Expanded(
//                          child: Text(
//                        widget.item.price.toString(),
//                        style: TextStyle(
//                          fontSize: 20,
//                          color: Color.fromRGBO(255,214,12, 1),
//                          fontWeight: FontWeight.w600,
//                        ),
//                      )),
//                      _isRecommend
//                          ? GestureDetector(
//                              onTap: () {
//                                setState(() {
//                                  _isRecommend = !_isRecommend;
//                                });
//                              },
//                              child: Container(
////                                padding: EdgeInsets.only(right: 0),
//                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
//                                child: Icon(
//                                  Icons.done,
//                                  color: Colors.white,
//                                ),
//                              ),
//                            )
//                          : GestureDetector(
//                              onTap: () {
//                                setState(() {
//                                  _isRecommend = !_isRecommend;
//                                });
//                              },
//                              child: Container(
//                                height: 24,
////                                padding: EdgeInsets.only(right: 5),
//                                decoration: BoxDecoration(
//                                  border: Border.all(
//                                    color: Colors.grey,
//                                  ),
//                                  shape: BoxShape.circle,
//                                ),
//                                child: Icon(
//                                  Icons.done,
//                                  color: Colors.white,
//                                ),
//                              ),
//                            ),
//                      Text(
//                        '推款',
//                        style: TextStyle(fontSize: 18),
//                      )
//                    ],
//                  ),
//                  Row(
//                    children: <Widget>[
//                      Container(
//                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
//                        decoration: BoxDecoration(
//                          color: Color.fromRGBO(255,214,12, 1)[50],
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        child: Text(
//                          '实际库存 ' + widget.item.stockLevel.available.toString(),
//                          style: TextStyle(
//                            color: Color.fromRGBO(255,214,12, 1),
//                            fontSize: 12,
//                          ),
//                        ),
//                      ),
//                      Container(
//                        margin: EdgeInsets.only(left: 10),
//                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
//                        decoration: BoxDecoration(
//                          color: Color.fromRGBO(255,214,12, 1)[50],
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        child: Text(
//                          '平台库存 ' + widget.item.stockLevel.available.toString(),
//                          style: TextStyle(
//                            color: Color.fromRGBO(255,214,12, 1),
//                            fontSize: 12,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Text(
//                    '销量' + widget.item.salesVolume.toString(),
//                    style: TextStyle(color: Colors.grey, fontSize: 16),
//                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (!widget.isSelectItem) {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ActionChip(
              shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
              labelPadding: EdgeInsets.symmetric(horizontal: 15),
              backgroundColor: Colors.white,
              label: Text('删除'),
              labelStyle: TextStyle(color: Colors.grey),
              onPressed: () async {
                await ProductRepositoryImpl().delete(widget.item.code);
                ApparelProductBLoC.instance.filterByStatuses();
              },
            ),
            ActionChip(
              shape: StadiumBorder(
                  side: BorderSide(color: Color.fromRGBO(255, 214, 12, 1))),
              labelPadding: EdgeInsets.symmetric(horizontal: 15),
              backgroundColor: Colors.white,
              label: Text('编辑'),
              labelStyle: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
              onPressed: () {
                ProductRepositoryImpl()
                    .detail(widget.item.code)
                    .then((product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BLoCProvider(
                            bloc: ApparelProductBLoC.instance,
                            child: ApparelProductFormPage(
                              item: product,
                            ),
                          ),
                    ),
                  );
                });
              },
            ),
//          ActionChip(
//            shape: StadiumBorder(side: BorderSide(color: Color.fromRGBO(255,214,12, 1))),
//            labelPadding: EdgeInsets.symmetric(horizontal: 15),
//            backgroundColor: Colors.white,
//            label: Text(_approvalStatusText),
//            labelStyle: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
//            onPressed: () {},
//          ),
            ActionChip(
              labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              backgroundColor: Color.fromRGBO(255, 214, 12, 1),
              label: Text('生产'),
              labelStyle: TextStyle(color: Colors.black),
              onPressed: () {
                // TODO: 带到商品，跳到需求页面
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequirementOrderFrom(
                              product: widget.item,
                            )));
              },
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
