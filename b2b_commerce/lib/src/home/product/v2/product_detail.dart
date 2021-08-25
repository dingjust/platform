import 'package:b2b_commerce/src/_shared/users/favorite.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_form_product.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/mini_program_page_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/home/_shared/widgets/dj_bottom_sheet.dart'
    as dj;

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
  ScrollController _scrollController;
  bool lastStatus = false;

  void initState() {
    super.initState();

    if (widget.code != null) {
      //数据埋点>>>看款详情
      UmengPlugin.onEvent('order_product_detail_page',
          properties: {'code': widget.code});
    }
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset >
            (MediaQuery.of(context).size.width - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
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
        ));
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
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: MediaQuery
              .of(context)
              .size
              .width,
          pinned: true,
          elevation: 0,
          centerTitle: true,
          title: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: lastStatus
                ? Text(
              '款式详情',
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )
                : Container(),
          ),

          leading: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: lastStatus
                ? IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 25,
                  color: Color(0xff231815),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
                : IconButton(
                icon: B2BV2Image.back(width: 24, height: 24),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),

          stretch: true,
          backgroundColor: Colors.white,
          actions: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: lastStatus
                  ? IconButton(
                icon: Icon(B2BIconsV2.share),
                onPressed: onShare,
                color: Color(0xff231815),
              )
                  : IconButton(
                  icon: B2BV2Image.share_circle(width: 24, height: 24),
                  onPressed: onShare),
            ),
          ],
          // backgroundColor: Color.fromRGBO(255, 255, 255, 0),
          // actionsIconTheme: IconThemeData(color: Colors.grey[300]),
          // brightness: Brightness.dark,
          // leading: IconButton(
          //     icon: B2BV2Image.back(width: 24, height: 24),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     }),
          // actions: [
          //   IconButton(
          //       icon: B2BV2Image.share_circle(width: 24, height: 24),
          //       onPressed: onShare),
          // ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ProductCarousel(
                  thumbnails,
                  MediaQuery
                      .of(context)
                      .size
                      .width,
                ),
              ],
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
              _buildHeaderSection(),
              _buildAttributeSection(),
              _buildImagesSection()
            ])),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMoneyRow(),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    '${data.name}',
                    style: TextStyle(
                        color: Color.fromRGBO(50, 50, 50, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          ),
          _buildTagsRow(),
          _buildProductionDay()
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
        _moneyRows.add(_buildMoneyRowBlock('${steppedPrices[i].price}',
            '${steppedPrices[i].minimumQuantity}件起'));
      }
      //最后一个阶梯价
      else if (i == steppedPrices.length - 1) {
        _moneyRows.add(_buildMoneyRowBlock('${steppedPrices[i].price}',
            '≥${steppedPrices[i].minimumQuantity}件'));
      } else {
        _moneyRows.add(_buildMoneyRowBlock('${steppedPrices[i].price}',
            '${steppedPrices[i].minimumQuantity}~${steppedPrices[i + 1]
                .minimumQuantity - 1}件'));
      }
    }
    return Container(
        margin: EdgeInsets.only(bottom: 7),
        child: Row(
          children: [
            Expanded(
              child: Column(children: _moneyRows),
            ),
            FavoriteIcon(
              id: data.id,
            )
          ],
        ));
  }

  Widget _buildMoneyRowBlock(String price, String decription) {
    return Row(
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: '￥',
              style: TextStyle(
                  color: Color(0xFFFF4D4F),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: '$price', style: TextStyle(fontSize: 28))
              ]),
        ),
        Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              '$decription',
              style: TextStyle(color: Color(0xFF666666), fontSize: 14),
            ))
      ],
    );
  }

  Widget _buildImagesSection() {
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '商品详情',
                    style: TextStyle(color: Color(0xff666666), fontSize: 14),
                  )
                ],
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
                              imageUrl: '${media.detailUrl()}',
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) =>
                                  SpinKitRing(
                                    color: Colors.black12,
                                    lineWidth: 2,
                                    size: 30,
                                  ),
                              errorWidget: (context, url, error) =>
                                  SpinKitRing(
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.white,
      child: GestureDetector(
        onTap: onOrder,
        child: Container(
          height: 48,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Color(0xFFFED800)
            // gradient: LinearGradient(
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
            //     colors: [
            //       Colors.orange[400],
            //       Color(0xffffd60c),
            //     ])
          ),
          child: Center(
            child: Text(
              '下单',
              style: TextStyle(color: Color(0xFF222222), fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagsRow() {
    return Row(
        children: data.productType
            .map((e) =>
            Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
              child: Text(
                '${ProductTypeLocalizedMap[e]}',
                style: TextStyle(fontSize: 11, color: Color(0xFFAA6E15)),
              ),
              decoration: BoxDecoration(
                  color: Color(0xFFFFF5D7),
                  borderRadius: BorderRadius.circular(10)),
            ))
            .toList());
  }

  Widget _buildProductionDay({TextStyle style =
  const TextStyle(color: Color(0xFF666666), fontSize: 12)}) {
    if (data.productType.contains(ProductType.FUTURE_GOODS)) {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '生产天数：${data.productionDays}天',
              style: style,
            ),
            Text(
              '生产增量（数量/天）：${data.productionIncrement}',
              style: style,
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildAttributeSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _InfoRow(label: '货号', val: ''),
          _Divider(),
          _InfoRow(label: '品类', val: data.category?.name),
          _Divider(),
          _InfoRow(label: '面料', val: data.superCategories?.name),
          _Divider(),
          _InfoRow(label: '尺码', val: sizesStr().join('、')),
          _Divider(),
          _InfoRow(label: '颜色', val: colorsStr().join('、')),
          _Divider(),
          Builder(
            builder: (iContext) =>
                _InfoRow(
                  label: '属性风格',
                  val: '版型、款式...',
                  onTap: () {
                    dj.showModalBottomSheet<void>(
                        context: iContext,
                        builder: (BuildContext context) {
                          return _BottomSheet(data: data.attributes);
                        });
                  },
                ),
          )
        ],
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

  List<String> sizesStr() {
    List<String> result = [];
    if (data.colorSizes?.first != null && data.colorSizes.first.sizes != null) {
      data.colorSizes.first.sizes.forEach((element) {
        result.add(element.name);
      });
    }
    return result;
  }

  List<String> colorsStr() {
    List<String> result = [];
    if (data.colorSizes != null) {
      data.colorSizes.forEach((element) {
        result.add(element.colorName);
      });
    }
    return result;
  }

  void onOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) =>
                      RequirementOrderFormStateV2(
                          identityTypeStr: '', product: data),
                ),
              ],
              child: Consumer(
                builder: (context, RequirementOrderFormStateV2 state, _) =>
                    RequirementFormProduct(
                      formState: state,
                    ),
              ),
            ),
      ),
    );
  }

  ///分享
  void onShare() {
    var price;

    if (data.steppedPrices != null && data.steppedPrices.isNotEmpty) {
      price = '￥${data.steppedPrices.first.price}';
    } else if (data.spotSteppedPrices != null &&
        data.spotSteppedPrices.isNotEmpty) {
      price = '￥${data.spotSteppedPrices.first.price}';
    } else {
      price = '';
    }

    var day = data.productionDays != null ? '${data.productionDays}天' : '';

    String title = '钉单看款做货 $day $price';
    String description = '钉单看款做货 $day $price';

    const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';

    ShareDialog.showShareDialog(context,
        title: '$title',
        description: '$description',
        imageUrl: data.thumbnails.first.imageProcessUrl(processUrl),
        path: MiniProgramPageRoutes.productDetail(data.code),
        url: GlobalConfigs.APP_TARO_CONTEXT_PATH);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;

  final String val;

  final VoidCallback onTap;

  const _InfoRow({Key key, this.label, this.val, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Text(
                '$label',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xff999999), fontSize: 14),
              ),
            ),
            Expanded(
                child: Text(
                  (val != null && val != '') ? val : '—',
                  style: TextStyle(color: Color(0xff222222), fontSize: 14),
                )),
            onTap != null
                ? Icon(
              Icons.chevron_right,
              size: 15,
              color: Color(0xff999999),
            )
                : Container()
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Color(0xffE7E7E7),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final ApparelProductAttributesModel data;

  const _BottomSheet({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 16,
            right: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        height: MediaQuery
            .of(context)
            .size
            .height * 0.68,
        child: Column(
          children: [
            Container(
                height: 45,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          '属性风格',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff222222),
                          ),
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: Icon(B2BIcons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    )
                  ],
                )),
            Expanded(
              child: ListView(
                children: [
                  _InfoRow(label: '版型', val: data.editionType),
                  _Divider(),
                  _InfoRow(label: '款式', val: data.pattern),
                  _Divider(),
                  _InfoRow(label: '袖型', val: data.sleeveType),
                  _Divider(),
                  _InfoRow(label: '袖长/裤腿', val: data.sleeveLength),
                  _Divider(),
                  _InfoRow(label: '图案', val: data.decorativePatterns.join('、')),
                  _Divider(),
                  _InfoRow(label: '流行元素', val: data.popularElements.join('、')),
                  _Divider(),
                  _InfoRow(label: '填充物', val: data.filler),
                  _Divider(),
                  _InfoRow(label: '厚薄', val: data.thickness),
                  _Divider(),
                  _InfoRow(label: '季节', val: data.season),
                  _Divider(),
                  _InfoRow(label: '门襟', val: data.placket),
                  _Divider(),
                  _InfoRow(label: '吊牌', val: data.taggable ? '有' : '无'),
                  _Divider(),
                  _InfoRow(label: '风格', val: data.styles.join('、')),
                ],
              ),
            )
          ],
        ));
  }
}
