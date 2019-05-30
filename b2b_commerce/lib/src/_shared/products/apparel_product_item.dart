import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    return InkWell(
      onLongPress: isSelectOption ? null : onPrdouctDeleting,
      onTap: isSelectOption ? (){
        if(isSelectOption){
          Navigator.pop(context,item);
        }
      } : onPrdouctUpdating,
      child: Card(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        elevation: 0,
        child: Column(
          children: <Widget>[
            _buildProduct(context),
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
          item.thumbnail != null?
          Container(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: '${item.thumbnail.previewUrl()}',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    SpinKitRing(
                      color: Colors.black12,
                      lineWidth: 2,
                      size: 30,
                    ),
                errorWidget: (context, url, error) =>
                    SpinKitRing(
                      color: Colors.black12,
                      lineWidth: 2,
                      size: 30,
                    )
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ) :
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(
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
                    '${item.name==null?'':item.name}',
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
                      '货号：${item.skuID==null?'':item.skuID}',
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
          Offstage(
            offstage: isSelectOption,
            child: _buildButtons(context),
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
