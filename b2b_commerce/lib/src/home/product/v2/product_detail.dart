import 'package:core/core.dart';

import 'package:b2b_commerce/src/home/_shared/widgets/product_attributes_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductDetailPage extends StatefulWidget {
  final String code;

  ProductDetailPage(
    this.code, {
    Key key,
  }) : super(key: key);

  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ApparelProductModel data;

  void initState() {
    super.initState();

    if (widget.code != null) {
      //数据埋点>>>看款详情
      UmengPlugin.onEvent('order_product_detail_page',
          properties: {'code': widget.code});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);

    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Color.fromRGBO(248, 248, 248, 1),
          child: FutureBuilder(
            future: _getData(),
            builder: (BuildContext context,
                AsyncSnapshot<ApparelProductModel> snapshot) {
              if (data != null) {
                return _buildBody();
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Constants.THEME_COLOR_MAIN),
                ));
              }
            },
          ),
        ),
        bottomSheet: _buildBtn(bloc),
      ),
    );
  }

  Widget _buildBody() {
    List<MediaModel> thumbnails = [];
    if (data.thumbnails != null) {
      thumbnails = data.thumbnails
          .map((thumbnail) => MediaModel(
              convertedMedias: thumbnail.convertedMedias,
              mediaFormat: thumbnail.mediaFormat,
              mediaType: thumbnail.mediaType,
              mime: thumbnail.mime,
              name: thumbnail.name,
              url: thumbnail.url,
              id: thumbnail.id))
          .toList();
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          elevation: 0,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0),
          actionsIconTheme: IconThemeData(color: Colors.grey[300]),
          // backgroundColor: Constants.THEME_COLOR_MAIN,
          brightness: Brightness.dark,
          leading: IconButton(
              icon: Icon(
                B2BIcons.left_fill,
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ProductCarousel(thumbnails, 400),
              ],
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          _buildHeaderSection(),
          ProductAttributesTab(data),
          _buildImagesSection()
        ])),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              '${data.name}',
              style: TextStyle(
                  color: Color.fromRGBO(50, 50, 50, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip,
            ),
          ),
          _buildMoneyRow(),
        ],
      ),
    );
  }

  Widget _buildMoneyRow() {
    List<SteppedPriceModel> steppedPrices;
    steppedPrices = data.spotSteppedPrices;

    ///阶梯价空处理
    if (steppedPrices == null) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('请补全商品阶梯价')]),
      );
    }

    List<Widget> _moneyRows = [];
    for (int i = 0; i < steppedPrices.length; i++) {
      if (i == 0) {
        _moneyRows.add(_buildMoneyRowBlock('￥${steppedPrices[i].price}',
            '${steppedPrices[i].minimumQuantity}件起批'));
      }
      //最后一个阶梯价
      else if (i == steppedPrices.length - 1) {
        _moneyRows.add(_buildMoneyRowBlock('￥${steppedPrices[i].price}',
            '≥${steppedPrices[i].minimumQuantity}件'));
      } else {
        _moneyRows.add(_buildMoneyRowBlock('￥${steppedPrices[i].price}',
            '${steppedPrices[i].minimumQuantity}~${steppedPrices[i + 1].minimumQuantity - 1}件'));
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
          // mainAxisAlignment: MainAxisAlignment.st,
          children: _moneyRows),
    );
  }

  Widget _buildMoneyRowBlock(String price, String decription) {
    return Expanded(
        flex: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$price',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$decription',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
        ));
  }

  Widget _buildImagesSection() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 70),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.white,
              child: Row(
                children: <Widget>[Text('商品详情')],
              ),
            ),
            Column(children: [
              for (MediaModel media in [
                ...data?.images ?? [],
                ...data?.details ?? []
              ])
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      child: CachedNetworkImage(
                          imageUrl: '${media.normalUrl()}',
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => SpinKitRing(
                                color: Colors.black12,
                                lineWidth: 2,
                                size: 30,
                              ),
                          errorWidget: (context, url, error) => SpinKitRing(
                                color: Colors.black12,
                                lineWidth: 2,
                                size: 30,
                              )),
                    ))
                  ],
                )
            ])
          ],
        ));
  }

  Widget _buildBtn(UserBLoC bloc) {
    return GestureDetector(
      // onTap: () => _onPay(context, data),
      child: Container(
        height: 35,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.orange[400],
                  Color(0xffffd60c),
                ])),
        child: Center(
          child: Text(
            '下单',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  ///获取产品信息
  Future<ApparelProductModel> _getData() async {
    if (data == null) {
      ApparelProductModel product =
          await ProductRepositoryImpl().detail(widget.code);
      if (product != null) {
        data = product;
      }
    }

    return data;
  }
}

class BasicInfoRow extends StatelessWidget {
  const BasicInfoRow(
      {Key key,
      @required this.label,
      @required this.value,
      this.action,
      this.onTap})
      : super(key: key);

  final String label;
  final String value;
  final Widget action;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        '$label',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 15),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        '$value',
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1), fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 50,
                child: action,
              )
            ],
          ),
        ));
  }
}
