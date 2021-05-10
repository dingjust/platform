import 'package:b2b_commerce/src/home/product/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CashProducts extends StatefulWidget {
  CashProducts({Key key}) : super(key: key);

  _CashProductsState createState() => _CashProductsState();
}

class _CashProductsState extends State<CashProducts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CashProductsListPage();
  }
}

class CashProductsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CashProductsState>(
      builder: (context, CashProductsState cashProductsState, _) => Container(
        child: cashProductsState.apparelProductModels != null
            ? CashProductsListView(
                cashProductsState: cashProductsState,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class CashProductsListView extends StatelessWidget {
  final CashProductsState cashProductsState;
  final ScrollController _scrollController = ScrollController();

  CashProductsListView({Key key, this.cashProductsState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        cashProductsState.showTopBtn = false;
      } else if (_scrollController.offset >= 500) {
        cashProductsState.showTopBtn = true;
      }
    });

    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        cashProductsState.loadMore();
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSlivers(),
            SliverToBoxAdapter(
              child:
              ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: cashProductsState.loadingMore ? 1.0 : 0,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildEnd(),
            )
          ],
        ),
        onRefresh: () async {
          cashProductsState.clear();
        },
      ),
      floatingActionButton: Opacity(
        opacity: cashProductsState.showTopBtn ? 1 : 0,
        child: FloatingActionButton(
          child: Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
          onPressed: () {
            _scrollController.animateTo(.0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSlivers() {
    if (cashProductsState.apparelProductModels != null &&
        cashProductsState.apparelProductModels.isNotEmpty) {
      List<RecommendProductItem> recommendProductItems =
      cashProductsState.apparelProductModels
          .map((product) =>
          RecommendProductItem(
            model: product,
            showAddress: true,
            onClick: () {
              //数据埋点=>工厂详情页点击“上架产品”进入看款详情
              UmengPlugin.onEvent('factory_detail_product_click',
                  properties: {'code': product.code ?? ''});
            },
          ))
          .toList();

      return SliverPadding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //Grid按两列显示
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.60,
          ),
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return recommendProductItems[index];
          }, childCount: cashProductsState.apparelProductModels.length),
        ),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      );
    }
  }

  Widget _buildEnd() {
    return cashProductsState.isEnd()
        ? Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('已经到底了')],
      ),
    )
        : Container();
  }
}
