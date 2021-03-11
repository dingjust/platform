import 'package:b2b_commerce/src/_shared/shares.dart';
import 'package:b2b_commerce/src/home/search/order_product_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/products_buttons_section.dart';
import 'components/products_plate_section.dart';
import 'components/products_recommend_section.dart';

class ProductsHomePage extends StatefulWidget {
  @override
  _ProductsHomePageState createState() => _ProductsHomePageState();
}

class _ProductsHomePageState extends State<ProductsHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => PlateProductState(
                  type: SeeProductPlateType.RECOMMEND_FOR_YOU)),
        ],
        child: Scaffold(
          body: Container(
              color: Color.fromRGBO(245, 245, 245, 1),
              child: ProductsHomePageView()),
        ));
  }
}

class ProductsHomePageView extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  ProductsHomePageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 188.0,
          pinned: true,
          elevation: 0.5,
          title: ProductsHomeTitle(
            leading: GlobalSearchInput<String>(
              tips: ' 搜索产品名称',
              delegate: OrderProductSearchDelegate(),
            ),
          ),
          backgroundColor: Constants.THEME_COLOR_MAIN,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[ProductsHeaderCarousels()],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            ProductsButtonsSection(),
            ProductsPlateSection(),
            ProductsBodyCarousels()
          ])),
        ),
        SliverToBoxAdapter(
            child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '为你推荐',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )),
        ProductsRecommendSection(),
        SliverToBoxAdapter(
            child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '已到底',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )),
      ],
    ));
  }
}

class ProductsHomeTitle extends StatelessWidget {
  final Widget leading;

  const ProductsHomeTitle({Key key, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: leading,
          ),
        ],
      ),
    );
  }
}

class ProductsHeaderCarousels extends StatelessWidget {
  //Carousel 的MediaModel URL 需为全路径
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductHomeCarouselsState>(
        builder: (context, ProductHomeCarouselsState state, _) {
          List<CarouselItem> items = state
              .headerCarousels()
              .where((carousel) => carousel.media != null)
              .map((carousel) =>
              CarouselItem(model: MediaModel(url: carousel.media.normalUrl())))
              .toList();

      // //若为空采用静态图
          if (items == null || items.isEmpty) {
            return Container();
          }

          return Carousel(items, 240);
    });
  }
}

class ProductsBodyCarousels extends StatelessWidget {
  final double height;

  const ProductsBodyCarousels({Key key, this.height = 50}) : super(key: key);

  //Carousel 的MediaModel URL 需为全路径
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductHomeCarouselsState>(
        builder: (context, ProductHomeCarouselsState state, _) {
          List<CarouselItem> items = state
              .bodyCarousels()
              .where((carousel) => carousel.media != null)
              .map((carousel) =>
              CarouselItem(model: MediaModel(url: carousel.media.detailUrl())))
              .toList();

      // //若为空采用静态图
          if (items == null || items.isEmpty) {
            return Container();
          }

      return Container(
          height: height,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Carousel(
              items,
              height,
              scrollDirection: Axis.vertical,
            ),
          ));
    });
  }
}
