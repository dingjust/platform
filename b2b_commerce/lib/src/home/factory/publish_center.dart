import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class PublishCenterPage extends StatefulWidget {
  @override
  _PublishCenterPageState createState() => _PublishCenterPageState();
}

class _PublishCenterPageState extends State<PublishCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildDefaultAppBar(
        '发布中心',
        actions: <Widget>[],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 75,
                  height: 100,
                  child: ImageNumButton(
                    width: 65,
                    height: 90,
                    image: B2BImage.material(),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ProductionOfflineOrder(),
                      //   ),
                      // );
                    },
                    title: '发包/转片',
                  ),
                ),
                Container(
                  width: 75,
                  height: 100,
                  child: ImageNumButton(
                    width: 65,
                    height: 90,
                    image: B2BImage.free_capacity2(),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.ROUTE_MY_CAPACITY);
                    },
                    title: '发布空闲产能',
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
