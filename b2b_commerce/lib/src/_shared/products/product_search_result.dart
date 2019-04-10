import 'package:b2b_commerce/src/_shared/products/apparel_product_item.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:b2b_commerce/src/production/production.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductSearchResultPage extends StatefulWidget {
  ProductSearchResultPage({Key key, this.keyword}) : super(key: key);

  _ProductSearchResultPageState createState() => _ProductSearchResultPageState();

  String keyword;
}

class _ProductSearchResultPageState extends State<ProductSearchResultPage> {
  GlobalKey _productBlocProviderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ApparelProductSearchResultBLoC>(
        key: _productBlocProviderKey,
        bloc: ApparelProductSearchResultBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('${widget.keyword}'),
            brightness: Brightness.dark,
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 10),
            color: Colors.grey[200],
            child: ProductListView(
              keyword: widget.keyword,
            ),
          ),
          floatingActionButton: ScrollToTopButton<ApparelProductSearchResultBLoC>(),
        ));
  }
}

class ProductListView extends StatefulWidget {
  String keyword;

  ScrollController scrollController = new ScrollController();

  ProductListView({Key key, @required this.keyword}) : super(key: key);

  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>{

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ApparelProductSearchResultBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore(widget.keyword);
      }
    });

    //监听滚动事件，打印滚动位置
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (widget.scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        widget.scrollController.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });



    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.grey[200],
        child: ListView(
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<List<ApparelProductModel>>(
                initialData: null,
                stream: bloc.stream,
                builder: (BuildContext context, AsyncSnapshot<List<ApparelProductModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getData(widget.keyword);
                    return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((product) {
                        return ApparelProductItem(
                          item: product,
                          onPrdouctDeleting: () => _onProudctDeleting(product),
                          onPrdouctUpdating: () => _onProudctUpdating(product),
                          onPrdouctProduction: () => _onProudctProduction(product),
                          onProductShlefing: () => _onProductShlefing(product),
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
                if (snapshot.data) {
                  widget.scrollController.animateTo(widget.scrollController.offset - 70,
                      duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                }

                return ScrolledToEndTips(hasContent: snapshot.data);
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(opacity: snapshot.data ? 1.0 : 0);
              },
            ),
          ],
        ));
  }

  void _onProudctDeleting(ApparelProductModel product){
    ShowDialogUtil.showAlertDialog(context, '是否要删除产品', () async {
      await ProductRepositoryImpl().delete(product.code);
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('删除产品成功'),
        duration: Duration(
          seconds: 2,
        ),
      ));
      ApparelProductSearchResultBLoC.instance.getData(widget.keyword);
    });
  }

  void _onProudctUpdating(ApparelProductModel product){
    ProductRepositoryImpl().detail(product.code).then((product) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BLoCProvider(
            bloc: ApparelProductBLoC.instance,
            child: ApparelProductFormPage(
              item: product,
              status: widget.keyword,
            ),
          ),
        ),
      );
    });
  }
  void _onProudctProduction(ApparelProductModel product){
    // TODO: 带到产品，跳到需求页面
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
              product: product,
            )));
  }
  void _onProductShlefing(ApparelProductModel product){
    //TODO:产品上下架
    if (product.approvalStatus ==
        ArticleApprovalStatus.approved) {
      ProductRepositoryImpl().off(product.code).then((a) {
        ApparelProductSearchResultBLoC.instance
            .getData(widget.keyword);
      });
    } else if (product.approvalStatus ==
        ArticleApprovalStatus.unapproved) {
      ProductRepositoryImpl().on(product.code).then((a) {
        ApparelProductSearchResultBLoC.instance
            .getData(widget.keyword);
      });
    }
  }
}
