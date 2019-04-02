import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import '../../widgets/image_factory.dart';
import '../../widgets/text_factory.dart';

import '../../../business/orders/requirement_order_detail.dart';

class RequirementOrderItem extends StatelessWidget {
  const RequirementOrderItem({
    Key key,
    @required this.model,
  }) : super(key: key);

  final RequirementOrderModel model;

  static Map<RequirementOrderStatus, Color> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Color(0xFFFFD600),
    RequirementOrderStatus.COMPLETED: Colors.green,
    RequirementOrderStatus.CANCELLED: Colors.grey,
  };

  Widget _buildSummary(int totalQuotesCount) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[Text('已报价 $totalQuotesCount', style: const TextStyle(color: Colors.red))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onOrderDetails() async {
      // 根据code查询明
      RequirementOrderModel detail = await RequirementOrderRepository().getRequirementOrderDetail(model.code);

      List<QuoteModel> quotes = await RequirementOrderRepository().getRequirementOrderQuotes(
        code: detail.code,
        page: 0,
        size: 1,
      );

      if (model != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RequirementOrderDetailPage(order: model, quotes: quotes),
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
                child: Text('需求订单号：${model.code}', style: const TextStyle(fontSize: 16)),
              ),
              Text(
                RequirementOrderStatusLocalizedMap[model.status],
                style: TextStyle(color: _statusColors[model.status], fontSize: 18),
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

      return Text(productName, style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis);
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
        child: Text('货号：$productSkuID', style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
          style: const TextStyle(fontSize: 15, color: const Color.fromRGBO(255, 133, 148, 1)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImageForList(model.details.pictures, fit: BoxFit.cover),
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
                    expectedMachiningQuantity: model.details.expectedMachiningQuantity,
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
