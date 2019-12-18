import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/production/production_offline_order_from.dart';
import 'package:b2b_commerce/src/production/production_unique_code.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class OrderCoordinationPage extends StatefulWidget {
  @override
  _OrderCoordinationPageState createState() => _OrderCoordinationPageState();
}

class _OrderCoordinationPageState extends State<OrderCoordinationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildDefaultAppBar(
        '订单协同',
        actions: <Widget>[],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 80),
              child: Center(
                child: FlatButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text('什么是订单协同'),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      Icon(
                        B2BIcons.question,
                        color: Colors.red,
                        size: 18,
                      )
                    ],
                  ),
                ),
              )),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 65,
                  height: 90,
                  child: ImageNumButton(
                    width: 65,
                    height: 90,
                    image: B2BImage.orderCoordination(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductionOfflineOrder(),
                        ),
                      );
                    },
                    title: '创建订单',
                  ),
                ),
                Container(
                  width: 65,
                  height: 90,
                  child: ImageNumButton(
                    width: 65,
                    height: 90,
                    image: B2BImage.uniqueImport(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductionUniqueCodePage(),
                        ),
                      );
                    },
                    title: '唯一码导入',
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 25,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
