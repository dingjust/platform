import 'package:b2b_commerce/src/business/supplier/suppliers_detail.dart';
import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_date_pick.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

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
    List<MediaModel> thumbnails = widget.product.thumbnails
        .map((thumbnail) => MediaModel(
            convertedMedias: thumbnail.convertedMedias,
            mediaFormat: thumbnail.mediaFormat,
            mediaType: thumbnail.mediaType,
            mime: thumbnail.mime,
            name: thumbnail.name,
            url: '${GlobalConfigs.IMAGE_BASIC_URL}${thumbnail.url}',
            id: thumbnail.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('现款详情'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              B2BIcons.more,
              size: 4,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Color.fromRGBO(248, 248, 248, 1),
        child: ListView(
          children: <Widget>[
            ProductCarousel(thumbnails, 400),
            _buildHeaderSection(),
            _buildBasicInfoSection(),
            _buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    //因字符样式不同，将价格按小数点分割
    List<String> _minPrice = widget.product.minPrice != null
        ? widget.product.minPrice.toString().split(".")
        : ['0', '0'];
    List<String> _maxPrice = widget.product.maxPrice != null
        ? widget.product.minPrice.toString().split(".")
        : ['0', '0'];

    return Container(
      height: 110,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.product.name}',
            style: TextStyle(
                color: Color.fromRGBO(50, 50, 50, 1),
                fontSize: 16,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
          ),
          RichText(
            text: TextSpan(
                text: '￥',
                style: TextStyle(
                    color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                      text: '${_minPrice[0]}.', style: TextStyle(fontSize: 25)),
                  TextSpan(text: '${_minPrice[1]}'),
                  TextSpan(text: '——￥'),
                  TextSpan(
                      text: '${_maxPrice[0]}.', style: TextStyle(fontSize: 25)),
                  TextSpan(text: '${_maxPrice[1]}')
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '订单数：68',
                style: TextStyle(
                    color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
              ),
              Text(
                '${widget.product.belongTo?.address}',
                style: TextStyle(
                    color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      height: 80,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuppliersDetail(
                          supplierModel: SupplierModel(
                            factory: widget.product.belongTo,
                          ),
                          isSupplier: false,
                        ),
                  ),
                );
              },
            ),
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

  Widget _buildOrderButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: (){
                FastRequirementForm fastRequirementForm = new FastRequirementForm();
                fastRequirementForm.product = widget.product.code;
                fastRequirementForm.factoryUid = widget.product.belongTo.uid;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RequirementDatePick(
                      fastRequirementForm: fastRequirementForm,
                      nowTime: DateTime.now(),
                    )));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
              child: Text(
                '下单',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 20),
              )),
        ],
      ),
    );
  }

  ///构建
  initColorSizeSelectData() {}

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
              child: Text('取消',style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定',style: TextStyle(color: Colors.black)),
              onPressed: () async {},
            ),
          ],
        );
      },
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
                        color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
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
    );
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
