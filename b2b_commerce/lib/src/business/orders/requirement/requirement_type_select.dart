import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class RequirementTypeSelectPage extends StatelessWidget {
  const RequirementTypeSelectPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '需求发布',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 150),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: OutlineButton(
                    onPressed: () => onPublish(context),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Image.asset(
                          'temp/index/find_factory.png',
                          package: 'assets',
                          fit: BoxFit.fitWidth,
                          width: 120,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('我要找工厂'),
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: OutlineButton(
                    onPressed: () {},
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Image.asset(
                          'temp/index/find_order.png',
                          package: 'assets',
                          fit: BoxFit.fitWidth,
                          width: 120,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('我要抢订单'),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      )),
    );
  }

  void onPublish(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => RequirementOrderFormState(),
            ),
          ],
          child: Consumer(
            builder: (context, RequirementOrderFormState state, _) =>
                RequirementOrderForm(
              formState: state,
            ),
          ),
        ),
      ),
    );
  }
}
