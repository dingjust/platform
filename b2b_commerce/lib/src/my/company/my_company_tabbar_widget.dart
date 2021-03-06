import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'form/my_company_contact_form.dart';
import 'my_company_cash_products_widget.dart';
import 'my_company_certificate_widget.dart';
import 'my_company_contact_from_widget.dart';
import 'my_factory_base_info.dart';

class MyCompanyTabbar extends StatefulWidget {
  FactoryModel factory;
  bool isFactoryDetail;
  int tabIndex;
  List<ApparelProductModel> products;

  MyCompanyTabbar(this.factory, {this.isFactoryDetail, this.tabIndex = 0,this.products,});

  _MyCompanyTabbarState createState() => _MyCompanyTabbarState();
}

class _MyCompanyTabbarState extends State<MyCompanyTabbar>
    with SingleTickerProviderStateMixin {
  List<EnumModel> _states = [
    EnumModel('a', '资料介绍'),
    EnumModel('b', '联系方式'),
    EnumModel('c', '产品物料'),
    EnumModel('d', '公司认证'),
  ];
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        vsync: this, length: _states.length, initialIndex: widget.tabIndex);
    super.initState();
  }

  Widget _buildView(String code) {
    switch (code) {
      case 'a':
        return _buildBaseInfo();
        break;
      case 'b':
        return _buildContactWay();
        break;
      case 'c':
        return _buildCashProducts();
        break;
      case 'd':
        return _buildCompanyCertificate();
        break;
      default:
        return _buildBaseInfo();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding:
            EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
        tabs: _states.map((status) {
          return Tab(text: status.name);
        }).toList(),
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
        isScrollable: false,
      ),
      body: TabBarView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _tabController,
        children: _states.map((state) {
          return _buildView(state.code);
        }).toList(),
      ),
    );
  }

  //联系方式
  Container buildContactWay(BuildContext context) {
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
                    company: widget.factory,
                    isEditing: true,
                  ),
            ),
          );
        },
      ),
    );
  }

  //基本资料
  Widget _buildBaseInfo() {
    return MyFactoryBaseInfo(
      widget.factory,
    );
  }

  Widget _buildContactWay() {
    return Container(
      color: Colors.white,
      child: MyCompanyContactFromWidgetPage(
        company: widget.factory,
      ),
    );
  }

  //现款产品
  Widget _buildCashProducts(){
    return MyCompanyCashProducts(widget.factory,);
  }


  Widget _buildCompanyCertificate() {
    return Container(
      color: Colors.white,
      child: MyCompanyCertificateWidget(
        widget.factory,
        onlyRead: true,
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

  //格式化标签
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
        if (i > 1) {
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
