import 'package:b2b_commerce/src/business/search/suppliers_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SuppliersDetail extends StatelessWidget {
  final SupplierModel supplierModel;

  SuppliersDetail({Key key, @required this.supplierModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('供应商管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.phone),
          )
        ],
      ),
      body: Container(
        child: _buildApparelProductItem(context),
      ),
    );
  }

  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            title: Text('供应商名'),
            trailing: Text(supplierModel.factory.name,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('合作单数'),
            trailing: Text(supplierModel.orderCount.toString(),
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('联系人'),
            trailing: Text(supplierModel.factory.contactPerson,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('手机号码'),
            trailing: Text(supplierModel.factory.contactPhone,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('地址'),
            trailing: Text(
                supplierModel.factory.contactAddress.region.name +
                supplierModel.factory.contactAddress.city.name +
                supplierModel.factory.contactAddress.cityDistrict.name +
                supplierModel.factory.contactAddress.line1,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildTop(BuildContext context){
    return Container(
      height: 150,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.grey,
            child: Image.network(
              supplierModel.factory.profilePicture,
              width: 90,
              height: 90,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        supplierModel.factory.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children:
                            _buildItemsStarIcon(context, supplierModel.factory.starLevel),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Image.network(
                              "https://www.vvfeng.com/data/upload/ueditor/20170422/58fab741b57e7.jpg",
                              width: 20,
                              height: 20,
                            )
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Image.network(
                              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548234386864&di=8f02d11edaa58d5a881f7828d6300fd2&imgtype=0&src=http%3A%2F%2Fa3.mzstatic.com%2Fus%2Fr30%2FPurple111%2Fv4%2F5f%2Fc7%2Fff%2F5fc7ff3e-42b4-d629-462f-148b523a4702%2FCRV_AP_600x360.jpeg",
                              width: 20,
                              height: 20,
                            )
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "已认证",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.deepOrange
                              ),
                            )
                        ),
                        Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                supplierModel.factory.contactAddress.region.name +
                                    supplierModel.factory.contactAddress.city.name +
                                    supplierModel.factory.contactAddress.cityDistrict.name,
                                style: TextStyle(
                                  fontSize: 14
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildHistoryOrderCount(BuildContext context){
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 110,
                margin: EdgeInsets.all(5),
                child: Text(
                  "历史接单数",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    '${supplierModel.factory.historyOrdersCount}单',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                width: 110,
                child: Text(
                  "响应报价时间",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    '${supplierModel.factory.responseQuotedTime}小时（平均）',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildFactory(BuildContext context){
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 110,
                margin: EdgeInsets.all(5),
                child: Text(
                  "月均产能",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    MonthlyCapacityRangesLocalizedMap[supplierModel.factory.monthlyCapacityRanges],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                width: 110,
                child: Text(
                  "产值规模",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    ScaleRangesLocalizedMap[supplierModel.factory.scaleRange],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                width: 110,
                child: Text(
                  "优势品类",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: _buildItemsByEntityList(
                        context, supplierModel.factory.categories),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildFabric(BuildContext context){
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                width: 110,
                child: Text(
                  "常备面料",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.chevron_right),
                  )
                ),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildApparelProductItem(BuildContext context){
      return Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: 110,
                      child: Text(
                        "现货商品",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(5),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.chevron_right),
                          )
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 170,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GridView.count(
                  physics: new NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 2.5 / 5,
                  children: <Widget>[
                    Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Image.network(
                                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "春秋薄款卫衣",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "￥88.00",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Image.network(
                                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "春秋薄款卫衣",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "￥88.00",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Image.network(
                                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                child: Text(
                                    "春秋薄款卫衣",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                    "￥88.00",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      );
  }


  //星级
  List<Widget> _buildItemsStarIcon(BuildContext context, int starLevel) {
    List<Widget> _widget = new List();
    for (int i = 0; i < starLevel; i++) {
      _widget.add(Container(
        child: Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      ));
    }
    return _widget;
  }

  //
  List<Widget> _buildItemsByEntityList(BuildContext context, List<dynamic> _list) {
    List<Widget> _widget = new List();
    if (_list.isNotEmpty) {
      for (int i = 0; i < _list.length; i++) {
        _widget.add(Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Text(
            _list[i].name,
            style: TextStyle(
                fontSize: 18
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
      }
    }
    return _widget;
  }

}
