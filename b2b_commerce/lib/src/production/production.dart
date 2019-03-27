import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionItem extends StatelessWidget {
  const ProductionItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(order.code);

        if (model != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductionProgressesPage(
                order: model,
              ))
          );
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            _buildContent(context),
            _buildBottom(),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildCompanyName(BuildContext context){
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if(bloc.isBrandUser){
      if((order.belongTo != null && order.belongTo.name != null) || order.companyOfSeller != null){
        return Text(
          '${order.belongTo != null && order.belongTo.name != null?order.belongTo.name:order.companyOfSeller}',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        );
      }else{
        return Text(
          ' ',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        );
      }
    }else{
      if((order.purchaser != null && order.purchaser.name != null)|| order.companyOfSeller != null){
        return Text(
          '${order.purchaser != null && order.purchaser.name != null?order.purchaser.name:order.companyOfSeller}',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        );
      }else{
        return Text(
          ' ',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        );
      }
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _buildCompanyName(context),
              ),
              Expanded(
                child:
                   order.delayed == true ?
                Text(
                  '已延期',
                  style: TextStyle(
                    color:Colors.red,
                    fontSize: 16,
                  ),
                ):Container(),
              ),
              Text(
                '${order.salesApplication == null ? '' : SalesApplicationLocalizedMap[order.salesApplication]}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    int sum = 0;
    order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
        color: Color.fromRGBO(250, 250, 250, 1),
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: order.product == null || order.product.thumbnail.url == null?
                    AssetImage(
                      'temp/picture.png',
                      package: "assets",
                    ):
                    NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${order.product.thumbnail.url}'),
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: order.product == null ||  order.product.name == null?
                            Container():
                            Text(
                              '${order.product.name}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                '货号：${order.product == null? '' : order.product.skuID}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            )),
                         order.product == null ||  order.product.category == null?
                        Container() :
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 243, 243, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "${order.product.category.name} ${sum}件",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 133, 148, 1)),
                          ),
                        )
                      ],
                    ))
            ),
            Container(
              width: 80,
              height: 80,
              child: ProductionCircleStep(
                size: 25,
                currentPhase: order.currentPhase,
                thickness: 3,
                fontColor: Color.fromRGBO(50, 50, 50, 1),
                fontSize: 13,
              ),
            )
          ],
        ));
  }

  Widget _buildBottom() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child:Align(
        alignment: Alignment.topLeft,
        child: Text(
          '最近更新时间：' + DateFormatUtil.format(order.modifiedtime),
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14),
        ),
      )
    );
  }
}
