import 'package:b2b_commerce/src/home/product/buy_proofing_form.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';
import 'package:b2b_commerce/src/home/product/dj_bottom_sheet.dart' as dj;

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key key, @required this.product}) : super(key: key);

  ApparelProductModel product;

  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  TextEditingController _numController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);

    List<MediaModel> thumbnails = widget.product.thumbnails
        .map((thumbnail) => MediaModel(
        convertedMedias: thumbnail.convertedMedias,
        mediaFormat: thumbnail.mediaFormat,
        mediaType: thumbnail.mediaType,
        mime: thumbnail.mime,
        name: thumbnail.name,
        url: '${thumbnail.detailUrl()}',
        id: thumbnail.id))
        .toList();

    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            '现款详情',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Container(
          color: Color.fromRGBO(248, 248, 248, 1),
          child: ListView(
            children: <Widget>[
              ProductCarousel(thumbnails, 400),
              _buildHeaderSection(),
              _buildBasicInfoSection(bloc),
              // _buildOrderButton(),
              _buildImagesSection()
            ],
          ),
        ),
        bottomSheet: _bubildOrderSheet(bloc),
      ),
    );
  }

  Widget _buildHeaderSection() {
    //因字符样式不同，将价格按小数点分割
    List<String> _minPrice = widget.product.minPrice != null
        ? widget.product.minPrice.toString().split(".")
        : ['0', '0'];
    List<String> _maxPrice = widget.product.maxPrice != null
        ? widget.product.maxPrice.toString().split(".")
        : ['0', '0'];

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.symmetric(vertical: 10),
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
              ),
              overflow: TextOverflow.clip,
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     RichText(
          //       text: TextSpan(
          //           text: '￥',
          //           style: TextStyle(
          //               color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
          //           children: <TextSpan>[
          //             TextSpan(
          //                 text: '${_minPrice[0]}.',
          //                 style: TextStyle(fontSize: 25)),
          //             TextSpan(text: '${_minPrice[1]}'),
          //             TextSpan(text: '——￥'),
          //             TextSpan(
          //                 text: '${_maxPrice[0]}.',
          //                 style: TextStyle(fontSize: 25)),
          //             TextSpan(text: '${_maxPrice[1]}')
          //           ]),
          //     ),
          //     Text(
          //       '${widget.product.belongTo.contactAddress.region.name}${widget.product.belongTo.contactAddress.city.name}',
          //       style: TextStyle(
          //           color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
          //     )
          //   ],
          // )
          _buildMoneyRow(),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                  text: '打样费: ',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                        text: '￥60.00', style: TextStyle(color: Colors.red))
                  ]),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '生产天数：1000件内5天，每加500件多1天',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              )),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '买大货需要支付30%定金',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ))
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(UserBLoC bloc) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BasicInfoRow(
            label: '工厂',
            value: '${widget.product.belongTo?.name}',
            action: JumpTo(
                label: '进厂',
                onTap: () {
                  jumpToFactory(bloc);
                }),
          ),
          BasicInfoRow(
            label: '参数',
            value: '面料、含量、风格...',
            onTap: onAttribute,
          ),
        ],
      ),
    );
  }

  // Widget _buildOrderButton() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 20),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         FlatButton(
  //             onPressed: () {
  //               FastRequirementForm fastRequirementForm =
  //                   new FastRequirementForm();
  //               fastRequirementForm
  //                 ..categories = [widget.product.category]
  //                 ..product = widget.product.code
  //                 ..factoryUid = widget.product.belongTo.uid;
  //               Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => RequirementDatePick(
  //                         fastRequirementForm: fastRequirementForm,
  //                         nowTime: DateTime.now(),
  //                       )));
  //             },
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(40)),
  //             color: Color.fromRGBO(255, 214, 12, 1),
  //             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
  //             child: Text(
  //               '下单',
  //               style: TextStyle(
  //                   color: Color.fromRGBO(36, 38, 41, 1), fontSize: 20),
  //             )),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMoneyRow() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildMoneyRowBlock('￥50.00', '50~1000件'),
          _buildMoneyRowBlock('￥45.00', '1001~5000件'),
          _buildMoneyRowBlock('￥40.00', '≥5001'),
        ],
      ),
    );
  }

  Widget _buildMoneyRowBlock(String price, String decription) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '$price',
            style: TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '$decription',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          )
        ],
      ),
    );
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
          children: widget.product.images
              .map(
                (media) =>
                CachedNetworkImage(
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
          )
              .toList()),
    );
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
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        B2BIcons.home_2,
                        size: 28,
                        // color: Colors.green,
                      ),
                      Text('工厂主页')
                    ],
                  ),
                  onPressed: () {
                    jumpToFactory(bloc);
                  },
                ),
                FlatButton(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        B2BIcons.phone_2,
                        size: 28,
                        // color: Colors.green,
                      ),
                      Text('联系')
                    ],
                  ),
                  onPressed: onTel,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      height: double.infinity,
                      child: Theme(
                          data: ThemeData(
                            canvasColor: Colors.transparent,
                            primaryColor: Colors.white,
                            accentColor: Color.fromRGBO(255, 214, 12, 1),
                            bottomAppBarColor: Colors.grey,
                          ),
                          child: Builder(
                            builder: (BuildContext buttonContext) =>
                                FlatButton(
                                  color: Color.fromRGBO(255, 245, 157, 1),
                                  onPressed: () {
                                    onBuyProofing(buttonContext);
                                  },
                                  disabledColor: Colors.grey[300],
                                  child: Text(
                                    '买样衣',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                          ))),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    child: FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: () {},
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '买大货',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
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

  void onBuyProofing(BuildContext buildContext) {
    dj.showModalBottomSheet<void>(
        context: buildContext,
        builder: (BuildContext context) {
          return BuyProofingForm(widget.product);
        });
  }

  /// 发布
  void onPublish() async {
    RequirementOrderModel form = RequirementOrderModel();

    // // form..
    // String code =
    //     await RequirementOrderRepository().publishNewRequirement(form);
    // if (code != null) {
    //   form.code = code;
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //         builder: (context) => PublishRequirementSuccessDialog(
    //               model: form,
    //             ),
    //       ),
    //       ModalRoute.withName('/'));
    // }
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
