import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../../../business/orders/requirement_order_detail.dart';
import '../../widgets/image_factory.dart';

/// 关闭生产订单
typedef void RequirementOrderCancleCallback();

class RequirementOrderItem extends StatelessWidget {
  const RequirementOrderItem({
    Key key,
    @required this.model,
    this.onRequirementCancle,
  }) : super(key: key);

  final RequirementOrderModel model;

  final RequirementOrderCancleCallback onRequirementCancle;

  Widget _buildSummary() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Text(
              '${DateFormatUtil.formatYMD(model.creationTime)}',
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff222222),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            RequirementOrderStatusLocalizedMap[model.status],
            style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onOrderDetails() async {
      if (model.code != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RequirementOrderDetailPage(
              model.code,
              onRequirementCancle: onRequirementCancle,
            ),
          ),
        );
      }
    }

    return GestureDetector(
      onTap: _onOrderDetails,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          children: <Widget>[
            _buildSummary(),
            _buildEntries()
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildEntries() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImageForList(model.details.pictures,
              fit: BoxFit.cover),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildRow1(model.details.productName),
                  _buildRow2(),
                  _buildRow3()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow1(String productName) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(productName ?? '',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildCategories({
    String majorCategory = '',
    String category = '',
  }) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
      child: Text(
        "$majorCategory $category ${model.details.expectedMachiningQuantity}件",
        style: const TextStyle(
            fontSize: 13,
            color: const Color(0xff666666),
            fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRow2() {
    return Container(
      margin: EdgeInsets.only(top: 2, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildCategories(
              majorCategory: model.details.majorCategoryName(),
              category: model.details.category?.name,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow3() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Text('已报价 ${model.totalQuotesCount}',
                  style: const TextStyle(
                      color: Color(0xFFFF4D4F),
                      fontSize: 14,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class ItemPicture extends StatelessWidget {
  final RequirementOrderModel order;

  const ItemPicture({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _pictureWidget;

    //TODO 审核标签
    if (order.details.pictures == null || order.details.pictures.isEmpty) {
      _pictureWidget = Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(243, 243, 243, 1)),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  B2BIcons.noPicture,
                  color: Color.fromRGBO(200, 200, 200, 1),
                  size: 60,
                ),
              ),
              order.labels != null && order.labels.isNotEmpty
                  ? Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5)),
                            color: Color.fromRGBO(255, 214, 12, 1)),
                        child: Center(
                          child: Text(
                            '${order.labels[0].name}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ));
    } else {
      _pictureWidget = Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: NetworkImage('${order.details.pictures[0].previewUrl()}'),
              fit: BoxFit.cover,
            )),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            order.labels != null && order.labels.isNotEmpty
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(5)),
                          color: Color.fromRGBO(255, 214, 12, 1)),
                      child: Center(
                        child: Text(
                          '${order.labels[0].name}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      );
    }
    return _pictureWidget;
  }
}
