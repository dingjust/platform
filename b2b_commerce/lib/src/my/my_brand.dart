import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
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
    this.brand, {
    this.isDetail = false,
    this.isSupplier = false,
  });

  final BrandModel brand;
  final bool isDetail;
  final bool isSupplier;

  _MyBrandPageState createState() => _MyBrandPageState();
}

class _MyBrandPageState extends State<MyBrandPage> {
  final Map<PurchaseOrderStatus, MaterialColor> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.IN_PRODUCTION: Colors.yellow,
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  Widget _buildContact(BuildContext context) {
    return Container(
      width: 80,
      child: IconButton(
        icon: Text(
          '联系方式',
          style: TextStyle(),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyCompanyContactFormPage(
                    company: widget.brand,
                    isDetail: widget.isDetail,
                  ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    _widgets.add(Offstage(
      offstage: !widget.isSupplier,
      child: Column(
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
      ),
    ));
    //获取与该品牌最新的生产订单
    _widgets.add(Offstage(
      offstage: !widget.isSupplier,
      child: Column(
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
      ),
    ));
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('公司介绍'),
        elevation: 0.5,
        actions: <Widget>[
          _buildContact(context),
        ],
      ),
      body: ListView(
        children: _widgets,
      ),
    );
  }

  FutureBuilder<PurchaseOrderModel> buildPurchaseOrderItem() {
    return FutureBuilder(
      future: getPurchaseOrderItem(),
      builder: (context, snapshot) {
        return Offstage(
            offstage: !(snapshot.hasData && snapshot.data != null),
            child: Column(
              children: <Widget>[
                PurchaseOrderItem(
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
                                      companyUid: widget.brand.uid,
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
                                      companyUid: widget.brand.uid,
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
            .getPurchaseOrdersByBrand(widget.brand.uid, {
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
        await QuoteOrderRepository().getQuotesByBrand(widget.brand.uid, {
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
            Text(DateFormatUtil.formatYMD(widget.brand.creationTime) ?? ''),
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
          if (widget.brand.type == CompanyType.INDIVIDUAL_HOUSEHOLD) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPersonalCertificatePage(
                          widget.brand,
                          onlyRead: true,
                        )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyCompanyCertificatePage(
                          widget.brand,
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
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyBrandBaseFormPage(widget.brand)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('编辑'),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                widget.brand.profilePicture != null
                    ? Container(
                        width: 80,
                        height: 80,
                        child: CachedNetworkImage(
                            width: 100,
                            height: 100,
                            imageUrl:
                                '${widget.brand.profilePicture.previewUrl()}',
                            fit: BoxFit.cover,
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
                          widget.brand.name ?? '',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
//                        widget.brand.starLevel == null ? Container() : Stars(starLevel:widget.brand.starLevel),
                        Stars(
                          starLevel: widget.brand.starLevel ?? 0,
                        ),
                        Container(
                          child: Text(
                            widget.brand.approvalStatus ==
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
                  '${widget.brand.brand ?? ''}',
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
                  "${widget.brand.cooperativeBrand ?? ''}",
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
                  widget.brand.scaleRange == null
                      ? ''
                      : ScaleRangesLocalizedMap[widget.brand.scaleRange],
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
                                      widget.brand.adeptAtCategories,
                                      widget.brand.adeptAtCategories.length),
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
                        widget.brand.adeptAtCategories, 2),
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
                  '风格',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatEnumSelectsText(widget.brand.styles, StyleEnum, 4),
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
                  '年龄段',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatAgeRangesText(widget.brand.ageRanges),
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
                  '春夏款价格端',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatPriceRangesText(widget.brand.priceRange1s),
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
                  '秋冬款价格端',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatPriceRangesText(widget.brand.priceRange2s),
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
