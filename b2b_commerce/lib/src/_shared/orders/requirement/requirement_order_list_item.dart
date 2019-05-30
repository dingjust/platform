import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../../business/orders/requirement_order_detail.dart';
import '../../widgets/image_factory.dart';
import '../../widgets/text_factory.dart';

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

  static Map<RequirementOrderStatus, Color> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Color(0xFFFFD600),
    RequirementOrderStatus.COMPLETED: Colors.green,
    RequirementOrderStatus.CANCELLED: Colors.grey,
  };

  Widget _buildSummary(int totalQuotesCount) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('已报价 $totalQuotesCount',
              style: const TextStyle(color: Colors.red))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onOrderDetails() async {
      // 根据code查询明
      RequirementOrderModel detail = await RequirementOrderRepository()
          .getRequirementOrderDetail(model.code);

      List<QuoteModel> quotes =
          await RequirementOrderRepository().getRequirementOrderQuotes(
        code: detail.code,
        page: 0,
        size: 1,
      );

      if (detail != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                RequirementOrderDetailPage(
                  order: detail,
                  quotes: quotes,
                  onRequirementCancle: onRequirementCancle,
                ),
          ),
        );
      }
    }

    return GestureDetector(
      onTap: _onOrderDetails,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            _buildSummary(model.totalQuotesCount),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('需求订单号：${model.code}',
                    style: const TextStyle(fontSize: 16)),
              ),
              Text(
                RequirementOrderStatusLocalizedMap[model.status],
                style:
                    TextStyle(color: _statusColors[model.status], fontSize: 18),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              '发布时间: ${DateFormatUtil.format(model.creationTime)}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    Widget _buildProductName(String productName) {
      if (productName == null) {
        return TextFactory.buildEmptyText();
      }

      return Text(productName,
          style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis);
    }

    Widget _buildProductSkuID(String productSkuID) {
      if (productSkuID == null) {
        return Container();
      }

      return Container(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('货号：$productSkuID',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      );
    }

    Widget _buildCategoriesAndQuantity({
      String majorCategory = '',
      String category = '',
      int expectedMachiningQuantity = 0,
    }) {
      return Container(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 243, 243, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$majorCategory   $category   $expectedMachiningQuantity件",
          style: const TextStyle(
              fontSize: 15, color: const Color.fromRGBO(255, 133, 148, 1)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImageForList(model.details.pictures,
              fit: BoxFit.cover),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildProductName(model.details.productName),
                  _buildProductSkuID(model.details.productSkuID),
                  _buildCategoriesAndQuantity(
                    majorCategory: model.details.majorCategoryName(),
                    category: model.details.category?.name,
                    expectedMachiningQuantity:
                        model.details.expectedMachiningQuantity,
                  )
                ],
              ),
            ),
          )
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
