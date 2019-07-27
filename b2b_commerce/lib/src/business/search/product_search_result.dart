import 'dart:convert';

import 'package:b2b_commerce/src/_shared/products/apparel_product_item.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_search_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:services/src/order/PageEntry.dart';

class ProductSearchResultPage extends StatefulWidget{
  ProductSearchResultPage({
    Key key,
    @required this.searchModel,
  }) : super(key: key);

  SearchModel searchModel;

  _ProductSearchResultPageState createState() => _ProductSearchResultPageState();
}

class _ProductSearchResultPageState extends State<ProductSearchResultPage> {
  final GlobalKey _globalKey = GlobalKey<_ProductSearchResultPageState>();
  List<String> historyKeywords;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ApparelProductBLoC>(
      key: _globalKey,
      bloc: ApparelProductBLoC.instance,
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      onClick();
                    },
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300], width: 0.5),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '${widget.searchModel.keyword}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ApparelProductSearchList(
            keyword: widget.searchModel.keyword,
          ),
        ),
        onWillPop: (){
          Navigator.of(context).pop();
//          ApparelProductBLoC().filterByStatuses('ALL');
          return Future.value(false);
        },
      ),
    );
  }

  void onClick(){
    Navigator.pop(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: LocalStorage.get(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY),
            outsideDismiss: false,
            loadingText: '加载中。。。',
            entrance: '',
          );
        }
    ).then((value){
      if (value != null && value != '') {
        List<dynamic> list = json.decode(value);
        historyKeywords = list.map((item) => item as String).toList();

      } else {
        historyKeywords = [];
      }
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchModelPage(
            searchModel: SearchModel(
              historyKeywords: historyKeywords,
              keyword: widget.searchModel.keyword,
              searchModelType: SearchModelType.PRODUCT,
              route: GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY
            ),
          ),
        ),
      );
    });
  }

}


class ProductListView extends StatelessWidget {
  String keyword;

  ScrollController _scrollController = new ScrollController();

  ProductListView({Key key, @required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ApparelProductBLoC>(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.getDatasLoadingMore(keyword: keyword);
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.grey[200],
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            StreamBuilder<PageEntry>(
                stream: bloc.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<PageEntry> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getDatas(keyword: keyword);
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.data.data.length <= 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          child: Image.asset(
                            'temp/logo2.png',
                            package: 'assets',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Container(child: Text('您当前未有产品')),
                        Container(
                          child: Text('请点击右下角创建产品'),
                        ),
                        Container(
                          child: FlatButton(
                            color: Color.fromRGBO(255, 214, 12, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyHelpPage()));
                            },
                            child: Text('如何创建产品？'),
                          ),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.data.map((item) {
                        return ApparelProductItem(
                          item: item,
                          onPrdouctUpdating: () => _onProudctUpdating(item,context),
                          onProductShlefing: () => _onProductShlefing(item,context),
                          onPrdouctProduction: () => _onProudctProduction(item,context),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }),
            StreamBuilder<bool>(
              stream: bloc.bottomStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ScrolledToEndTips(
                  hasContent: snapshot.data,
                  scrollController: _scrollController,
                );
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0);
              },
            ),
          ],
        ));
  }
  void _onProudctUpdating(ApparelProductModel product,BuildContext context) {
    ProductRepositoryImpl().detail(product.code).then((product) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BLoCProvider(
            bloc: ApparelProductBLoC.instance,
            child: ApparelProductFormPage(
              item: product,
            ),
          ),
        ),
      );
    });
  }

  void _onProudctProduction(ApparelProductModel product,BuildContext context) {
    RequirementOrderModel orderModel =
    RequirementOrderModel(details: RequirementInfoModel(), attachments: []);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
              product: product,
              isCreate: true,
              order: orderModel,
            )));
  }

  void _onProductShlefing(ApparelProductModel product,BuildContext context) {
    if (product.approvalStatus == ArticleApprovalStatus.approved) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().off(product.code),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((value) {
        bool result = false;
        if (value != null && value != '') {
          result = false;
        } else {
          result = true;
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '下架成功',
                failTips: '下架失败',
                callbackResult: result,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
//        if (widget.keyword == null) {
//          ApparelProductBLoC.instance.clearProductsMap();
//          ApparelProductBLoC.instance.filterByStatuses(widget.status);
//        } else {
//          ApparelProductBLoC.instance.clearProductsMap();
//          ApparelProductBLoC.instance.getData(widget.keyword);
//        }
      });
    } else if (product.approvalStatus == ArticleApprovalStatus.unapproved) {
      if (product.variants == null || product.variants.isEmpty) {
        ShowDialogUtil.showSimapleDialog(context, '颜色尺码为空不可上架');
        return;
      }
      if (product.maxPrice == null ||
          product.minPrice == null ||
          product.price == null) {
        ShowDialogUtil.showSimapleDialog(context, '产品价格为空不可上架');
        return;
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().on(product.code),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((value) {
        bool result = false;
        if (value != null && value != '') {
          result = false;
        } else {
          result = true;
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '上架成功',
                failTips: '上架失败',
                callbackResult: result,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
//        if (widget.keyword == null) {
//          ApparelProductBLoC.instance.clearProductsMap();
//          ApparelProductBLoC.instance.filterByStatuses(widget.status);
//        } else {
//          ApparelProductBLoC.instance.clearProductsMap();
//          ApparelProductBLoC.instance.getData(widget.keyword);
//        }
      });
    }
  }
}