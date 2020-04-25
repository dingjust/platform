import 'package:b2b_commerce/src/home/_shared/widgets/dj_bottom_sheet.dart'
as dj;
import 'package:b2b_commerce/src/home/_shared/widgets/product_attributes_tab.dart';
import 'package:b2b_commerce/src/home/product/buy_proofing_form.dart';
import 'package:b2b_commerce/src/home/product/buy_purchase_form.dart';
import 'package:b2b_commerce/src/home/product/buy_stock_form.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import 'components/clip_widget.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key key, @required this.product}) : super(key: key);

  ApparelProductModel product;

  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  TextEditingController _numController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();

  ProductType productType;

  void initState() {
    super.initState();

    if (widget.product != null) {
      //数据埋点>>>看款详情
      FlutterUmplus.event("order_product_detail_page",
          label: widget.product.code);

      //点击量
      ItemRepository().onDetail(widget.product.id);

      //若产品没有类型
      if (widget.product.productType == null ||
          widget.product.productType.isEmpty) {
        //默认期货
        productType = ProductType.FUTURE_GOODS;
      } else {
        if (widget.product.productType.contains(ProductType.SPOT_GOODS)) {
          productType = ProductType.SPOT_GOODS;
        } else if (widget.product.productType
            .contains(ProductType.TAIL_GOODS)) {
          productType = ProductType.TAIL_GOODS;
        } else {
          productType = ProductType.FUTURE_GOODS;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);

    List<MediaModel> thumbnails = [];
    if (widget.product.thumbnails != null) {
      thumbnails = widget.product.thumbnails
          .map((thumbnail) =>
          MediaModel(
              convertedMedias: thumbnail.convertedMedias,
              mediaFormat: thumbnail.mediaFormat,
              mediaType: thumbnail.mediaType,
              mime: thumbnail.mime,
              name: thumbnail.name,
              url: '${thumbnail.normalUrl()}',
              id: thumbnail.id))
          .toList();
    }

    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Color.fromRGBO(248, 248, 248, 1),
          child: CustomScrollView(
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
                    // ProductCarousel(thumbnails, 400),
                    _buildTypeRow(),
                    _buildHeaderSection(),
                    ProductAttributesTab(widget.product),
                    _buildImagesSection()
                  ])),
            ],
          ),
        ),
        bottomSheet: _bubildOrderSheet(bloc),
      ),
    );
  }

  Widget _buildTypeRow() {
    double height = 50;

    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
          Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      // margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                color: Color.fromRGBO(254, 227, 93, 1),
                child: ClipWidget(
                  child: _buildTypeSection(),
                ),
              )),
          Container(
              width: 100,
              height: height,
              color: Color.fromRGBO(254, 227, 93, 1),
              child: Center(
                child: Text(
                  '已售${widget.product?.salesVolume ?? 0 > 9999
                      ? '9999+'
                      : widget.product?.salesVolume ?? 0}件',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildTypeSection() {
    List<ProductType> productTypes;
    if (widget.product.productType != null &&
        widget.product.productType.isNotEmpty) {
      productTypes = widget.product.productType;
      //排序
      productTypes.forEach((type) {
        print('${type}${type.index}');
      });
      productTypes.sort((o1, o2) => (o1.index - o2.index));
    } else {
      productTypes = [ProductType.FUTURE_GOODS];
    }

    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(243, 109, 113, 1)),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
            children: productTypes
                .map(
                  (type) =>
                  Expanded(
                      flex: 1,
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        onPressed: () {
                          setState(() {
                            productType = type;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${ProductTypeLocalizedMap[type]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: productType == type ? 16 : 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                                width: 40,
                                decoration: BoxDecoration(
                                  border: productType == type
                                      ? Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.6)))
                                      : null,
                                ))
                          ],
                        ),
                      )),
            )
                .toList()));
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
              '${widget.product.name}',
              style: TextStyle(
                  color: Color.fromRGBO(50, 50, 50, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip,
            ),
          ),
          _buildMoneyRow(),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                productType == ProductType.FUTURE_GOODS
                    ? '出货周期：${widget.product.basicProduction}件内${widget.product
                    .productionDays}天，每加${widget.product
                    .productionIncrement}件多1天'
                    : '出货周期：72小时内',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              )),
          Opacity(
            opacity: productType == ProductType.FUTURE_GOODS ? 1 : 0,
            child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  '注：买期货需要支付30%定金',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildMoneyRow() {
    List<SteppedPriceModel> steppedPrices;
    if (productType == ProductType.FUTURE_GOODS) {
      steppedPrices = widget.product.steppedPrices;
    } else {
      steppedPrices = widget.product.spotSteppedPrices;
    }

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
            '${steppedPrices[i].minimumQuantity}~${steppedPrices[i + 1]
                .minimumQuantity - 1}件'));
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

  void onOrder() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('填写需求信息'),
          content: Container(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('需求数量'),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(200, 200, 200, 1)))),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _numController,
                    onChanged: (value) {},
                    //只能输入数字
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        hintText: '填写', border: InputBorder.none),
                  ),
                ),
                Text('备注'),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(200, 200, 200, 1)))),
                  child: TextField(
                    autofocus: true,
                    controller: _remarksController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        hintText: '请填写颜色、尺码、特殊工艺以及其他要求',
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定', style: TextStyle(color: Colors.black)),
              onPressed: () async {},
            ),
          ],
        );
      },
    );
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
            Column(
                children: widget.product.images
                    .map((media) =>
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              child: CachedNetworkImage(
                                  imageUrl: '${media.normalUrl()}',
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
                    ))
                    .toList()),
          ],
        ));
  }

  Widget _bubildOrderSheet(UserBLoC bloc) {
    return Container(
      height: 55,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        jumpToFactory(bloc);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            B2BIcons.home_2,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            '工厂主页',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    child: InkWell(
                      onTap: onTel,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            B2BIcons.phone_2,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            '联系',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )

                // FlatButton(
                //   child: Column(
                //     children: <Widget>[
                //       Icon(
                //         B2BIcons.home_2,
                //         size: 20,
                //         // color: Colors.green,
                //       ),
                //       Text(
                //         '工厂主页',
                //         style: TextStyle(fontSize: 12),
                //       )
                //     ],
                //   ),
                //   onPressed: () {
                //     jumpToFactory(bloc);
                //   },
                // ),
                // FlatButton(
                //   child: Column(
                //     children: <Widget>[
                //       Icon(
                //         B2BIcons.phone_2,
                //         size: 20,
                //         // color: Colors.green,
                //       ),
                //       Text(
                //         '联系',
                //         style: TextStyle(fontSize: 12),
                //       )
                //     ],
                //   ),
                //   onPressed: onTel,
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      height: double.infinity,
                      child: Builder(
                        builder: (BuildContext buttonContext) =>
                            FlatButton(
                              color: Color.fromRGBO(254, 227, 93, 1),
                              onPressed: () {
                                switch (productType) {
                                  case ProductType.FUTURE_GOODS:
                                    onBuyPurchase(buttonContext);
                                    break;
                                  case ProductType.SPOT_GOODS:
                                    onBuyStock(buttonContext);
                                    break;
                                  case ProductType.TAIL_GOODS:
                                    onBuyStock(buttonContext);
                                    break;
                                  default:
                                }
                              },
                              disabledColor: Colors.grey[300],
                              child: Text(
                                '立即购买',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onAttribute() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return AttributeTable(
            product: widget.product,
          );
        });
  }

  ///买样衣
  void onBuyProofing(BuildContext buildContext) {
    dj.showModalBottomSheet<void>(
        context: buildContext,
        builder: (BuildContext context) {
          return BuyProofingForm(
            widget.product,
            onRefresh: () {
              setState(() {});
            },
          );
        });
  }

  ///买期货
  void onBuyPurchase(BuildContext buildContext) {
    dj.showModalBottomSheet<void>(
        context: buildContext,
        builder: (BuildContext context) {
          return BuyPurchaseForm(widget.product);
        });
  }

  ///买现货/尾货
  void onBuyStock(BuildContext buildContext) {
    dj.showModalBottomSheet<void>(
        context: buildContext,
        builder: (BuildContext context) {
          return BuyStockForm(widget.product);
        });
  }

  //拨打联系人
  void onTel() async {
    var url = 'tel:' + widget.product.belongTo.contactPhone;
    await launch(url);
  }

  //跳转工厂详情
  void jumpToFactory(UserBLoC bloc) {
    if (bloc.isBrandUser) {
      UserRepositoryImpl()
          .getFactory(widget.product.belongTo.uid)
          .then((factory) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyFactoryPage(
                  factoryUid: factory.uid,
                  isFactoryDetail: true,
                ),
          ),
        );
      });
    }
  }
}

class BasicInfoRow extends StatelessWidget {
  const BasicInfoRow({Key key,
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
                        '${label}',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 15),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        '${value}',
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

class JumpTo extends StatelessWidget {
  const JumpTo({Key key, @required this.label, @required this.onTap})
      : super(key: key);

  final String label;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Text(
                '${label}',
                style: TextStyle(color: Color.fromRGBO(255, 149, 22, 1)),
              ),
            ),
            Icon(
              B2BIcons.right,
              size: 12,
              color: Color.fromRGBO(255, 149, 22, 1),
            )
          ],
        ),
      ),
    );
  }
}
