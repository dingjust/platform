import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'package:b2b_commerce/src/business/products/brand/apparel_product_brand_form.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ApparelProductsBrandPage extends StatefulWidget {
  ApparelProductsBrandPage();

  _ApparelProductsBrandPageState createState() =>
      _ApparelProductsBrandPageState();
}

class _ApparelProductsBrandPageState extends State<ApparelProductsBrandPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //清除缓存
    ApparelProductBLoC.instance.clearProductsMap();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ApparelProductBLoC>(
      bloc: ApparelProductBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('产品管理'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                B2BIcons.search,
                size: 20,
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistorySearch(
                              hintText: '请输入编码，名称，货号搜索',
                              historyKey:
                                  GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
                            )));
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.grey[100],
          child: ApparelProductList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Provider.of<CertificationStatusHelper>(context, listen: false)
                .oncheckProfile(
                context: context,
                onJump: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ApparelProductBrandFormPage(
                                item:
                                ApparelProductBLoC.instance.newProduct,
                                isCreate: true,
                                enabled: true,
                              ))).then((val) {});
                });
          },
        ),
      ),
    );
  }
}
