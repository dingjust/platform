import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import '../../../business/orders/proofing_order_detail.dart';
import '../../widgets/image_factory.dart';

/// 取消订单
typedef void ProofingCancelingCallback();

/// 修改订单
typedef void ProofingUpdatingCallback();

/// 确认发货
typedef void ProofingConfirmDeliveredCallback();

/// 确认收货
typedef void ProofingConfirmReceivedCallback();

/// 去支付
typedef void ProofingPayingCallback();

class ProofingOrderItem extends StatelessWidget {
  const ProofingOrderItem(
      {Key key,
      @required this.model,
      this.onProofingCanceling,
      this.onProofingUpdating,
      this.onProofingConfirmDelivered,
      this.onProofingConfirmReceived,
      this.onProofingPaying})
      : super(key: key);

  final ProofingModel model;

  final ProofingCancelingCallback onProofingCanceling;
  final ProofingUpdatingCallback onProofingUpdating;
  final ProofingConfirmDeliveredCallback onProofingConfirmDelivered;
  final ProofingConfirmReceivedCallback onProofingConfirmReceived;
  final ProofingPayingCallback onProofingPaying;

  static Map<ProofingStatus, Color> _statusColors = {
    ProofingStatus.PENDING_PAYMENT: Colors.red,
    ProofingStatus.PENDING_DELIVERY: const Color(0xFFFFD600),
    ProofingStatus.SHIPPED: const Color(0xFFFFD600),
    ProofingStatus.COMPLETED: Colors.green,
    ProofingStatus.CANCELLED: Colors.grey
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 查询明细
        ProofingModel detailModel = await ProofingOrderRepository().proofingDetail(model.code);

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProofingOrderDetailPage(model: detailModel)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            _buildSummary(context),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: '￥',
                  style: const TextStyle(fontSize: 16, color: Color.fromRGBO(255, 45, 45, 1)),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${model.totalPrice}',
                      style: const TextStyle(fontSize: 20, color: Color.fromRGBO(255, 45, 45, 1)),
                    ),
                  ],
                ),
              ),
              Text(
                ProofingStatusLocalizedMap[model.status],
                style: TextStyle(color: _statusColors[model.status], fontSize: 18),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // TODO 公司信息字段后续待修改
                Container(
                  width: 200,
                  child: Text(
                    '${model.supplier.name}',
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('${DateFormatUtil.format(model.creationTime)}', style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    // 计算总数
    int sum = 0;
    model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });

    Widget _buildProductName(String name) {
      return Text(name, style: const TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis);
    }

    Widget _buildProductSkuID(String skuID) {
      if (skuID == null) {
        return Container();
      }

      return Container(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('货号：$skuID', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      );
    }

    Widget _buildCategoryAndCount(String category, int sum) {
      return Container(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 243, 243, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$category   $sum 件",
          style: const TextStyle(fontSize: 15, color: const Color.fromRGBO(255, 133, 148, 1)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImage(model.product?.thumbnail, size: 25),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildProductName(model.product.name),
                  _buildProductSkuID(model.product.skuID),
                  _buildCategoryAndCount(model.product.category?.name, sum)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    Widget _buildCancelButton(BuildContext context) {
      return FlatButton(
        onPressed: onProofingCanceling,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromRGBO(255, 70, 70, 1),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: const Text('取消订单', style: const TextStyle(color: Colors.white, fontSize: 18)),
      );
    }

    Widget _buildPayButton(BuildContext context) {
      return FlatButton(
        onPressed: onProofingPaying,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromRGBO(255, 214, 12, 1),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: Text('  去支付  ', style: const TextStyle(color: const Color.fromRGBO(36, 38, 41, 1), fontSize: 18)),
      );
    }

    Widget _buildConfirmReceivedButton(BuildContext context) {
      return FlatButton(
        onPressed: onProofingConfirmReceived,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xFFFFD600),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          '确认收货',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      );
    }

    Widget _buildUpdateButton(BuildContext context) {
      return FlatButton(
        onPressed: onProofingUpdating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: const Color.fromRGBO(255, 45, 45, 1)),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          '修改订单',
          style: const TextStyle(color: const Color.fromRGBO(255, 45, 45, 1), fontSize: 18),
        ),
      );
    }

    Widget _buildConfirmDeliveryButton(BuildContext context) {
      return FlatButton(
        onPressed: onProofingConfirmDelivered,
        color: const Color(0xFFFFD600),
        child: Text(
          '确认发货',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
      );
    }

    bool _isBrand() {
      return UserBLoC.instance.currentUser.type == UserType.BRAND;
    }

    List<Widget> buttons;
    // 品牌端显示
    if (_isBrand()) {
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = <Widget>[
          _buildCancelButton(context),
          _buildPayButton(context),
        ];
      } else if (model.status == ProofingStatus.SHIPPED) {
        buttons = <Widget>[
          // _buildTrackingButton(context),
          Container(),
          _buildConfirmReceivedButton(context),
        ];
      } else {
        return Container();
      }
    } else {
      //工厂端显示
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = [Container(), _buildUpdateButton(context)];
      } else if (model.status == ProofingStatus.PENDING_DELIVERY) {
        buttons = <Widget>[Container(), _buildConfirmDeliveryButton(context)];
      } else {
        return Container();
      }
    }

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: buttons,
              ),
            ),
          ),
        )
      ],
    );
  }
}
