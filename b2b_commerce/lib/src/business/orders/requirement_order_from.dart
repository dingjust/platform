import 'dart:io';

import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/delivery_address_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_price_field.dart';
import 'package:b2b_commerce/src/business/orders/form/remarks_field.dart';
import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../apparel_products.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import '../../home/requirement/requirement_publish_success.dart';
import 'form/pictures_field.dart';
import 'form/product_field.dart';
import 'form/total_quantity_field.dart';
import 'form/major_category_field.dart';
import 'form/minor_category_field.dart';
import 'form/production_areas_field.dart';

final List<EnumModel> technologyList = [
  EnumModel.fromJson({'code': '全工艺', 'name': '全工艺'}),
  EnumModel.fromJson({'code': '打板', 'name': '打板'}),
  EnumModel.fromJson({'code': '车缝', 'name': '车缝'}),
  EnumModel.fromJson({'code': '裁剪', 'name': '裁剪'}),
  EnumModel.fromJson({'code': '印花', 'name': '印花'}),
  EnumModel.fromJson({'code': '后枕', 'name': '后枕'}),
];

class RequirementOrderFrom extends StatefulWidget {
  final ApparelProductModel product;

  RequirementOrderFrom({this.product});

  _RequirementOrderFromState createState() => _RequirementOrderFromState();
}

class _RequirementOrderFromState extends State<RequirementOrderFrom> {
  RequirementOrderModel model = RequirementOrderModel();
  List<CategoryModel> _categorySelected = [];
  bool _isShowMore = true;
  String address = '选取';
  String technology = '选取';
  List<MediaModel> _normalMedias = [];
  List<File> _normalImages = [];
  String isProvideSampleProduct = '选取';
  String isInvoice = '选取';
  String inspectionMethod = '选取';
  bool _isRequirementPool = true;
  String isProofing = '选取';

  @override
  void initState() {
    model.product = widget.product;
    if (model.product?.normal != null) _normalMedias = model.product?.normal;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('需求发布'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
          actions: <Widget>[
            /*IconButton(
                icon: Icon(Icons.play_for_work),
                color: Color.fromRGBO(255, 149, 22, 1),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequirementImportProduct(),
                      ),
                    )),*/
            GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Center(
                    child: Text(
                      '导入商品',
                      style: TextStyle(color: Color.fromRGBO(255, 149, 22, 1)),
                    ),
                  ),
                ),
                onTap: () async {
                  List<File> files = _normalImages.toList();
                  dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductsPage(
                            isRequirement: true,
                            item: model.product,
                          ),
                    ),
                  );

                  //TODO：导入商品后的一系列操作
                  _normalImages.clear();
                  model.product = result;
                  _normalMedias = model.product?.normal;
                  _categorySelected.clear();
                  if (model.product?.minorCategory != null) {
                    _categorySelected.add(model.product.minorCategory);
                  }
                  if (_normalMedias != null) {
                    _normalMedias.forEach((media) {
                      //缓存图片并获取缓存图片
//                      CacheManager.getInstance().then((cacheManager){
//                        cacheManager.getFile(media.url).then((file){
//                          _normalImages.add(file);
//                        });
//                      });
                      DefaultCacheManager()
                          .getSingleFile(media.url)
                          .then((file) {
                        setState(() {
                          _normalImages.add(file);
                        });
                      });
                    });
                  }
                })
          ],
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            _buildBody(context),
            _buildCommitButton(context),
          ],
        )));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: <Widget>[
//            _buildPic(context),
            PicturesField(_normalImages),
            Offstage(
              offstage: model.product == null,
              child: ProductField(model),
            ),
            MajorCategoryField(model),
            new Divider(height: 0),
            MinorCategoryField(model, _categorySelected),
            new Divider(height: 0),
            TotalQuantityField(model),
            new Divider(height: 0),
            ExpectedPriceField(model),
            new Divider(height: 0),
            ExpectedDeliveryDateField(model),
            new Divider(height: 0),
            ContactWayField(model),
            new Divider(height: 0),
            DeliveryAddressField(model),
            _isShowMore ? Container() : new Divider(height: 0),
            _buildHideBody(context),
            _buildHideTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHideBody(BuildContext context) {
    return Offstage(
        offstage: _isShowMore,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                ProductionAreasField(model),
                new Divider(
                  height: 0,
                ),
                _buildCooperationModes(context),
                new Divider(
                  height: 0,
                ),
                _buildProofing(context),
                new Divider(
                  height: 0,
                ),
                _buildSampleProduct(context),
                new Divider(
                  height: 0,
                ),
                _buildInvoice(context),
                new Divider(
                  height: 0,
                ),
                RemarksField(model),
              ],
            ),
          ),
        ));
  }

  //是否展开更多
  Widget _buildHideTips(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(''),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '继续完善需求信息，更加精准匹配工厂',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    '更多条件',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF9516),
                    ),
                  ),
                  Icon(
                    _isShowMore
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Color(0xFFFF9516),
                    size: 28,
                  ),
                ],
              )),
          decoration: BoxDecoration(
            color: Color.fromRGBO(242, 242, 242, 1),
          ),
        ),
        onTap: () {
          setState(() {
            _isShowMore = !_isShowMore;
          });
        });
  }

  //加工类型
  Widget _buildCooperationModes(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '加工类型',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              model.machiningType == null
                  ? enumMap(MachiningTypeEnum, model.machiningType)
                  : '选取',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        onTap: () {
          _showTypeSelect();
        });
  }

  //是否需要打样
  Widget _buildProofing(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否需要打样',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              isProofing,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          _showIsProofingSelect();
        });
  }

  //是否提供样衣
  Widget _buildSampleProduct(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否提供样衣',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              isProvideSampleProduct,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          _showIsProvideSampleProductSelect();
        });
  }

  //是否开具发票
  Widget _buildInvoice(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否开具发票',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              isInvoice,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          _showIsInvoiceSelect();
        });
  }

  //确认发布按钮
  Widget _buildCommitButton(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: RaisedButton(
              color: Color(0xFFFF9516),
              child: Text(
                '确定发布',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PublishRequirementSuccessDialog(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            width: 200,
            child: Center(
              child: CheckboxListTile(
                title: Text(
                  '发布到需求池',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey),
                ),
                value: _isRequirementPool,
                onChanged: (T) {
                  setState(() {
                    _isRequirementPool = !_isRequirementPool;
                  });
                },
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 242, 242, 1),
      ),
    );
  }

  //加工类型
  void _showTypeSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: MachiningTypeEnum.map((machiningType) {
                return ListTile(
                  title: Text(machiningType.name),
                  onTap: () {
                    setState(() {
                      model.machiningType = machiningType.code;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ));
      },
    );
  }

  //是否打样选项
  void _showIsProofingSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('需要打样'),
                  onTap: () async {
                    setState(() {
                      isProofing = '需要打样';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不需要打样'),
                  onTap: () async {
                    setState(() {
                      isProofing = '不需要打样';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //是否提供样衣选项
  void _showIsProvideSampleProductSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('提供样衣'),
                  onTap: () async {
                    setState(() {
                      isProvideSampleProduct = '提供样衣';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不提供样衣'),
                  onTap: () async {
                    setState(() {
                      isProvideSampleProduct = '不提供样衣';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //是否开具发票选项
  void _showIsInvoiceSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('开发票'),
                  onTap: () async {
                    setState(() {
                      isInvoice = '开发票';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不开发票'),
                  onTap: () async {
                    setState(() {
                      isInvoice = '不开发票';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }
}
