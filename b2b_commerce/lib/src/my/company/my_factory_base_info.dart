import 'dart:ui';

import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/supplier/company_purchase_list.dart';
import 'package:b2b_commerce/src/business/supplier/company_quote_list.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyFactoryBaseInfo extends StatefulWidget {
  MyFactoryBaseInfo(this.factory, {Key key}) : super(key: key);

  final FactoryModel factory;

  @override
  State createState() => MyFactoryBaseInfoState();
}

class MyFactoryBaseInfoState extends State<MyFactoryBaseInfo> {
  Future _getQuoteFuture;
  Future _getPurchaseFuture;

  @override
  void initState() {
    _getQuoteFuture = _getQuoteData();
    _getPurchaseFuture = _getPurchaseData();
    // TODO: implement initState
    super.initState();
  }

  //获取与该工厂最新的报价单
  Future<QuoteModel> _getQuoteData() async {
    QuoteModel quoteModel;
    QuoteOrdersResponse quoteResponse =
        await QuoteOrderRepository().getQuotesByFactory(widget.factory.uid, {
      'size': 1,
    });
    if (quoteResponse.content.length > 0) {
      quoteModel = quoteResponse.content[0];
    }
    return Future.value(quoteModel);
  }

  //获取与该工厂最新的生产单
  Future<PurchaseOrderModel> _getPurchaseData() async {
    PurchaseOrderModel purchaseOrderModel;
    PurchaseOrdersResponse purchaseOrdersResponse =
        await PurchaseOrderRepository()
            .getPurchaseOrdersByFactory(widget.factory.uid, {
      'size': 1,
    });
    if (purchaseOrdersResponse.content.length > 0) {
      purchaseOrderModel = purchaseOrdersResponse.content[0];
    }
    return Future.value(purchaseOrderModel);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildFactoryHeaderRow = [
      widget.factory.approvalStatus == ArticleApprovalStatus.approved
          ? Tag(
              label: '  已认证  ',
              color: Colors.black,
              backgroundColor: Color.fromRGBO(255, 214, 12, 1),
            )
          : Tag(
              label: '  未认证  ',
              color: Colors.black,
              backgroundColor: Colors.grey[300],
            )
    ];
    widget.factory.labels.forEach((label) {
      return _buildFactoryHeaderRow.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Tag(
            label: label.name,
            color: Color.fromRGBO(255, 133, 148, 1),
          ),
        ),
      );
    });
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildFactoryItem(_buildFactoryHeaderRow),
              ),
              Divider(height: 0),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildhistoryOrdersCount(),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildMonthCapacityRange(),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildScaleRange(),
              ),
              Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildPopulationScale(),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildCooperationModes(),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildCategories(),
              ),
              Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildAdeptAtCategories(),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildCooperativeBrand(),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildCreationTime(),
              ),
              Divider(height: 0),
            ],
          ),
        ),
        _buildNewestQuote(),
        _buildNewestPurchase(),
      ],
    );
  }

  FutureBuilder<PurchaseOrderModel> _buildNewestPurchase() {
    return FutureBuilder<PurchaseOrderModel>(
      future: _getPurchaseFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
                child: Container(
                  color: Colors.grey[Constants.SIZEDBOX_COLOR],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: PurchaseOrderItem(
                  order: snapshot.data,
                ),
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
                                    companyUid: widget.factory.uid,
                                  )));
                    },
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  FutureBuilder<QuoteModel> _buildNewestQuote() {
    return FutureBuilder<QuoteModel>(
      future: _getQuoteFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
                child: Container(
                  color: Colors.grey[Constants.SIZEDBOX_COLOR],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: QuoteListItem(
                  model: snapshot.data,
                  showActions: false,
                ),
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
                                    companyUid: widget.factory.uid,
                                  )));
                    },
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  Row _buildCreationTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '注册时间',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Text(
          '${DateFormatUtil.formatYMD(widget.factory.creationTime) ?? ''}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _buildCooperativeBrand() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '合作品牌商',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Container(
          width: MediaQueryData.fromWindow(window).size.width - 130,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.factory.cooperativeBrand ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildAdeptAtCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '优势品类',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Container(
          width: MediaQueryData.fromWindow(window).size.width - 130,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatCategoriesSelectText(widget.factory.adeptAtCategories,
                  widget.factory.adeptAtCategories.length),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '生产大类',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Container(
          width: MediaQueryData.fromWindow(window).size.width - 130,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatCategoriesSelectText(
                  widget.factory.categories, widget.factory.categories.length),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildCooperationModes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '合作方式',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Text(
          formatCooperationModesSelectText(widget.factory.cooperationModes),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _buildPopulationScale() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '工厂规模',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Text(
          PopulationScaleLocalizedMap[widget.factory.populationScale] ?? '',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _buildScaleRange() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '产值规模',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        Text(
          "${ScaleRangesLocalizedMap[widget.factory.scaleRange] ?? ''}",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _buildMonthCapacityRange() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '月均产能',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Text(
          MonthlyCapacityRangesLocalizedMap[
                  widget.factory.monthlyCapacityRange] ??
              '',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _buildhistoryOrdersCount() {
    return Row(
      children: <Widget>[
        const Text('历史接单'),
        Text(
          '${widget.factory.historyOrdersCount ?? 0}',
          style: const TextStyle(color: Colors.red),
        ),
        const Text('单')
      ],
    );
  }

  Row _buildFactoryItem(List<Widget> _buildFactoryHeaderRow) {
    return Row(
      children: <Widget>[
        ImageFactory.buildThumbnailImage(widget.factory.profilePicture),
        Expanded(
          child: Container(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.factory.name,
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
                Stars(
                  starLevel: widget.factory.starLevel ?? 0,
                ),
                Container(
                  height: 20,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildFactoryHeaderRow,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  //格式化类别
  String formatCategoriesSelectText(List<CategoryModel> categories, int count) {
    String text = '';
    Map<String, List<String>> map = Map();
    if (categories != null) {
      text = '';
      for (int i = 0; i < categories.length; i++) {
        if (map[categories[i].parent.name] == null) {
          map[categories[i].parent.name] = [categories[i].name];
        } else {
          map[categories[i].parent.name].add(categories[i].name);
        }
      }

      map.forEach((key, value) {
        if (key != '大类') {
          text += key;
          text += '--';
        }
        for (int i = 0; i < value.length; i++) {
          if (i == value.length - 1) {
            text += value[i];
            if (map.keys.last != key) {
              text += '\n';
            }
          } else {
            text += value[i] + '、';
          }
        }
      });
    }

    return text;
  }

  String formatCategorySelectText(List<CategoryModel> categorys) {
    String text = '';

    if (categorys != null) {
      text = '';
      for (int i = 0; i < categorys.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == categorys.length - 1) {
          text += categorys[i].name;
        } else {
          text += categorys[i].name + '、';
        }
      }
    }

    return text;
  }

  String formatLabelsSelectText(List<LabelModel> labels) {
    String text = '';

    if (labels != null) {
      text = '';
      for (int i = 0; i < labels.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == labels.length - 1) {
          text += labels[i].name;
        } else {
          text += labels[i].name + '、';
        }
      }
    }

    return text;
  }

  //格式化合作方式
  String formatCooperationModesSelectText(
      List<CooperationModes> cooperationModes) {
    String text = '';

    if (cooperationModes != null) {
      text = '';
      for (int i = 0; i < cooperationModes.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == cooperationModes.length - 1) {
          text += CooperationModesLocalizedMap[cooperationModes[i]];
        } else {
          text += CooperationModesLocalizedMap[cooperationModes[i]] + '、';
        }
      }
    }

    return text;
  }
}
