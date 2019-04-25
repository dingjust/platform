import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class ApparelProductItem extends StatelessWidget {
  const ApparelProductItem({
    @required this.item,
    this.isSelectOption = false,
    this.status,
    this.onPrdouctDeleting,
    this.onPrdouctUpdating,
    this.onPrdouctProduction,
    this.onProductShlefing,
  });

  final ApparelProductModel item;
  final bool isSelectOption;
  final String status;

  final VoidCallback onPrdouctDeleting;
  final VoidCallback onPrdouctUpdating;
  final VoidCallback onPrdouctProduction;
  final VoidCallback onProductShlefing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSelectOption) Navigator.pop(context, item);
        // if(widget.isSelectOption)
      },
      child: GestureDetector(
        onLongPress: onPrdouctDeleting,
        child: Card(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          elevation: 0,
          child: Column(
            children: <Widget>[
              _buildProduct(context),
              Offstage(
                offstage: isSelectOption,
                child: _buildButtons(context),
              ),
            ],
          ),
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
                  image: item.thumbnail != null
                      ? NetworkImage('${item.thumbnail.previewUrl()}')
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
                    item.name,
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
                      '货号：' + item.skuID ?? '',
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
                      "${item?.category?.name ?? ''}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    String _approvalStatusText;
    if (item.approvalStatus == ArticleApprovalStatus.approved) {
      _approvalStatusText = '下架';
    } else if (item.approvalStatus == ArticleApprovalStatus.unapproved) {
      _approvalStatusText = '上架';
    }

    if (!isSelectOption) {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
//            ActionChip(
////              shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
////              labelPadding: EdgeInsets.symmetric(horizontal: 15),
////              backgroundColor: Colors.white,
////              label: Text('删除'),
////              labelStyle: TextStyle(color: Colors.grey),
////              onPressed: onPrdouctDeleting,
////            ),
            GestureDetector(
              child: Container(
                width: 60,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(child: Text('编辑')),
              ),
              onTap: onPrdouctUpdating,
            ),
//            ActionChip(
//              shape: StadiumBorder(side: BorderSide()),
//              labelPadding: EdgeInsets.symmetric(horizontal: 15),
//              backgroundColor: Colors.white,
//              label: Text('编辑'),
//              labelStyle: TextStyle(color: Colors.black),
//              onPressed: onPrdouctUpdating,
//            ),
            UserBLoC.instance.currentUser.type != UserType.FACTORY
                ? GestureDetector(
                    child: Container(
                      width: 60,
                      height: 25,
                      margin: EdgeInsets.only(right: 10,left: 10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 214, 12, 1),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text('发需求')),
                    ),
                    onTap: onPrdouctProduction,
                  )
                : GestureDetector(
                    child: Container(
                      width: 60,
                      height: 25,
                      margin: EdgeInsets.only(right: 10,left: 10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 214, 12, 1),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text(_approvalStatusText)),
                    ),
                    onTap: onProductShlefing,
                  ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
