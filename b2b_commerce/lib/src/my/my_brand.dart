import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/nodata_show.dart';
import 'package:b2b_commerce/src/business/supplier/company_purchase_list.dart';
import 'package:b2b_commerce/src/business/supplier/company_quote_list.dart';
import 'package:b2b_commerce/src/my/company/form/my_company_certificate.dart';
import 'package:b2b_commerce/src/my/company/form/my_personal_certificate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './company/form/my_brand_base_form.dart';
import 'company/form/my_company_contact_form.dart';

/// 认证信息
class MyBrandPage extends StatefulWidget {
  MyBrandPage(
    this.brandUid, {
    this.isDetail = false,
    this.isSupplier = false,
  });

  final String brandUid;
  final bool isDetail;
  final bool isSupplier;

  _MyBrandPageState createState() => _MyBrandPageState();
}

class _MyBrandPageState extends State<MyBrandPage> {
  BrandModel _brand;

  @override
  void initState() {
//    _brand = BrandModel.fromJson(BrandModel.toJson(widget.brand));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //退出品牌详情页清空全部报价单和全部生产单的缓存数据
    QuoteOrdersBLoC.instance.reset();
    PurchaseOrderBLoC.instance.reset();
  }

  Future<BrandModel> _getData() {
    return UserRepositoryImpl().getBrand(widget.brandUid);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<BrandModel>(
      future: _getData(),
      initialData: BrandModel(),
      builder: (context, snapshot) {
          _brand = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('公司介绍'),
              elevation: 0.5,
              actions: <Widget>[
                Offstage(
                  offstage:
                  UserBLoC.instance.currentUser.b2bUnit.uid != _brand.uid,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(icon: Text('编辑',style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1),),), onPressed: ()async{
                          dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyBrandBaseFormPage(_brand)));
                          if(result == true){
                            dynamic brand = await UserRepositoryImpl().getBrand(_brand.uid);
                            print(brand.name);
                            if(brand != null){
                              _brand = brand;
                            }
                          }
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body:

            snapshot.data != null ? ListView(
              children: _buildWidgets(),
            ):Column(children: <Widget>[NoDataShow()],crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,),
          );
      }
    );
  }

  _buildWidgets(){
    List<Widget> _widgets = [
      SizedBox(
        height: 10,
        child: Container(
          color: Colors.grey[Constants.SIZEDBOX_COLOR],
        ),
      ),
      _buildBrandBaseInfo(context),
    ];
    //获取与该品牌最新的报价单
    if(widget.isSupplier){
      _widgets.add(Column(
        children: <Widget>[
          SizedBox(
            height: 10,
            child: Container(
              color: Colors.grey[Constants.SIZEDBOX_COLOR],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: buildQuoteItem(),
          ),
        ],
      ));
    }
    //获取与该品牌最新的生产订单
    if(widget.isSupplier){
      _widgets.add(Column(
        children: <Widget>[
          SizedBox(
            height: 10,
            child: Container(
              color: Colors.grey[Constants.SIZEDBOX_COLOR],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: buildPurchaseOrderItem(),
          ),
        ],
      ));
    }

    _widgets.add(
      SizedBox(
        height: 10,
        child: Container(
          color: Colors.grey[Constants.SIZEDBOX_COLOR],
        ),
      ),
    );
    _widgets.add(_buildBrandCertificate(context));
    _widgets.add(
      SizedBox(
        height: 10,
        child: Container(
          color: Colors.grey[Constants.SIZEDBOX_COLOR],
        ),
      ),
    );
    _widgets.add(_buildBrandRegisterDate());
    return _widgets;
  }

  FutureBuilder<PurchaseOrderModel> buildPurchaseOrderItem() {
    return FutureBuilder(
      future: getPurchaseOrderItem(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Offstage(
            offstage: !(snapshot.hasData && snapshot.data != null),
            child: Column(
              children: <Widget>[
                PurchaseOrderListItem(
                  order: snapshot.data,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: GestureDetector(
                      child: Text(
                        '查看全部>>',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompanyPurchaseListPage(
                                      companyUid: _brand.uid,
                                    )));
                      },
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }

  FutureBuilder<QuoteModel> buildQuoteItem() {
    return FutureBuilder(
      future: getQuoteItem(),
      builder: (context, snapshot) {
        print(snapshot.data);
        return Offstage(
            offstage: !(snapshot.hasData && snapshot.data != null),
            child: Column(
              children: <Widget>[
                QuoteListItem(
                  model: snapshot.data,
                  showActions: false,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: GestureDetector(
                      child: Text(
                        '查看全部>>',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompanyQuoteListPage(
                                      companyUid: _brand.uid,
                                    )));
                      },
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }

  Future<PurchaseOrderModel> getPurchaseOrderItem() async {
    PurchaseOrderModel purchaseOrderModel;
    PurchaseOrdersResponse purchaseOrdersResponse =
        await PurchaseOrderRepository()
            .getPurchaseOrdersByBrand(_brand.uid, {
      'size': 1,
    });

    if (purchaseOrdersResponse != null &&
        purchaseOrdersResponse.content.length > 0) {
      purchaseOrderModel = purchaseOrdersResponse.content[0];
    }

    return Future(() => purchaseOrderModel);
  }

  Future<QuoteModel> getQuoteItem() async {
    QuoteModel quoteModel;
    QuoteOrdersResponse quoteOrdersResponse =
        await QuoteOrderRepository().getQuotesByBrand(_brand.uid, {
      'size': 1,
    });

    if (quoteOrdersResponse != null && quoteOrdersResponse.content.length > 0) {
      quoteModel = quoteOrdersResponse.content[0];
    }
    return Future(() => quoteModel);
  }

  Card _buildBrandRegisterDate() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text('注册时间'),
        trailing:
            Text(DateFormatUtil.formatYMD(_brand.creationTime) ?? ''),
      ),
    );
  }

  Card _buildBrandCertificate(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text('公司认证信息'),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          if (_brand.type == CompanyType.INDIVIDUAL_HOUSEHOLD) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPersonalCertificatePage(
                          _brand,
                          onlyRead: true,
                        )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyCompanyCertificatePage(
                          _brand,
                          onlyRead: true,
                        )));
          }
        },
      ),
    );
  }

  Widget _buildBrandBaseInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                _brand.profilePicture != null
                    ? Container(
                        width: 80,
                        height: 80,
                        child: CachedNetworkImage(
                            width: 100,
                            height: 100,
                            imageUrl:
                                '${_brand.profilePicture.previewUrl()}',
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(
                                'temp/picture.png',
                                package: "assets",
                              ),
                              fit: BoxFit.cover,
                            )),
                      ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _brand.name ?? '',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
//                        _brand.starLevel == null ? Container() : Stars(starLevel:_brand.starLevel),
                        Stars(
                          starLevel: _brand.starLevel ?? 0,
                        ),
                        Container(
                          child: Text(
                            _brand.approvalStatus ==
                                    ArticleApprovalStatus.approved
                                ? "已认证"
                                : '未认证',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 214, 12, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '品牌名称',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_brand.brand ?? ''}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '联系人',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_brand.contactPerson ?? ''}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '职务',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_brand.duties ?? ''}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '联系方式',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_brand.contactPhone ?? ''}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    '经营地址',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    '${_brand.contactAddress != null && _brand.contactAddress.region != null
                  ? _brand.contactAddress.details
                      : ''}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '座机号码',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_brand.phone ?? ''}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '合作品牌',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${_brand.cooperativeBrand ?? ''}",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '产值规模',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  _brand.scaleRange == null
                      ? ''
                      : ScaleRangesLocalizedMap[_brand.scaleRange],
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '优势类目',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: (context),
                        builder: (context) {
                          return SimpleDialog(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 5,
                                ),
                                child: Text(
                                  formatCategoriesSelectText(
                                      _brand.adeptAtCategories,
                                      _brand.adeptAtCategories.length),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          );
                        });
                  },
                  child: Text(
                    formatCategoriesSelectText(
                        _brand.adeptAtCategories, 2),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '质量等级',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatEnumSelectsText(_brand.salesMarket, FactoryQualityLevelsEnum, 2),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '风格',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatEnumSelectsText(_brand.styles, StyleEnum, 4),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(height: 0),
        ],
      ),
    );
  }

  //格式化类别
  String formatCategoriesSelectText(List<CategoryModel> categories, int count) {
    String text = '';

    if (categories != null) {
      text = '';
      for (int i = 0; i < categories.length; i++) {
        if (i > count - 1) {
          text += '...';
          break;
        }

        if (i == categories.length - 1) {
          text += categories[i].name;
        } else {
          text += categories[i].name + '、';
        }
      }
    }

    return text;
  }

  String formatAgeRangesText(List<AgeRanges> ageRanges) {
    String text = '';

    if (ageRanges != null) {
      text = '';
      for (int i = 0; i < ageRanges.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == ageRanges.length - 1) {
          text += AgeRangesLocalizedMap[ageRanges[i]];
        } else {
          text += AgeRangesLocalizedMap[ageRanges[i]] + '、';
        }
      }
    }

    return text;
  }

  String formatPriceRangesText(List<PriceRanges> priceRanges) {
    String text = '';

    if (priceRanges != null) {
      text = '';
      for (int i = 0; i < priceRanges.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == priceRanges.length - 1) {
          text += PriceRangesLocalizedMap[priceRanges[i]];
        } else {
          text += PriceRangesLocalizedMap[priceRanges[i]] + '、';
        }
      }
    }

    return text;
  }
}
