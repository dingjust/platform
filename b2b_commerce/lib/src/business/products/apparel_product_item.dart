import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductItem extends StatefulWidget {
  ApparelProductItem(this.item);

  final ApparelProductModel item;

  ApparelProductItemState createState() => ApparelProductItemState();
}

class ApparelProductItemState extends State<ApparelProductItem> {
  bool _isRecommend;
  String _approvalStatusText;

  @override
  void initState() {
    _isRecommend = widget.item.isRecommend;

    if(widget.item.approvalStatus == ArticleApprovalStatus.APPROVED){
      _approvalStatusText = '下架';
    }else if(widget.item.approvalStatus == ArticleApprovalStatus.UNAPPROVED){
      _approvalStatusText = '上架';
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      elevation: 0,
      child: Column(
        children: <Widget>[
          _buildProduct(),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildProduct() {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: widget.item.thumbnail != null
                      ? NetworkImage(widget.item.thumbnail)
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
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '货号：' + widget.item.skuID,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text('￥', style: TextStyle(color: Colors.orange)),
                      Expanded(
                          child: Text(
                        widget.item.price.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                      _isRecommend
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isRecommend = !_isRecommend;
                                });
                              },
                              child: Container(
//                                padding: EdgeInsets.only(right: 0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isRecommend = !_isRecommend;
                                });
                              },
                              child: Container(
                                height: 24,
//                                padding: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      Text('推款',style: TextStyle(fontSize: 18),)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '实际库存 ' + widget.item.stockLevel.available.toString(),
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '平台库存 ' + widget.item.stockLevel.available.toString(),
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '销量' + widget.item.salesVolume.toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ActionChip(
            labelPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 1),
            backgroundColor: Colors.orange,
            label: Text('生产'),
            labelStyle: TextStyle(color: Colors.white),
            onPressed: () {},
          ),
          ActionChip(
            shape: StadiumBorder(side: BorderSide(color: Colors.orange)),
            labelPadding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Colors.white,
            label: Text('编辑'),
            labelStyle: TextStyle(color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApparelProductFormPage(item: widget.item,)),
              );
            },
          ),
          ActionChip(
            shape: StadiumBorder(side: BorderSide(color: Colors.orange)),
            labelPadding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Colors.white,
            label: Text(_approvalStatusText),
            labelStyle: TextStyle(color: Colors.orange),
            onPressed: () {},
          ),
          ActionChip(
            shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
            labelPadding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Colors.white,
            label: Text('删除'),
            labelStyle: TextStyle(color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
