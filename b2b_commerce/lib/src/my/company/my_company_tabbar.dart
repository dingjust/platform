import 'package:b2b_commerce/src/business/products/existing_product_item.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/my_company_contact_from.dart';
import 'form/my_factory_base_form.dart';
import 'my_company_certificate_widget.dart';
import 'my_company_contact_from_widget.dart';
import 'my_company_tabbar_widget.dart';
import 'my_factory_base_info.dart';

class MyCompanyTabbarPage extends StatefulWidget {
  FactoryModel factory;
  bool isFactoryDetail;

  MyCompanyTabbarPage(this.factory, {this.isFactoryDetail = false});

  _MyCompanyTabbarPageState createState() => _MyCompanyTabbarPageState();
}

class _MyCompanyTabbarPageState extends State<MyCompanyTabbarPage>
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
    _tabController = TabController(vsync: this, length: _states.length);
//    _scrollController.addListener((){
//      if(_scrollController.offset == 188){
//        setState(() {
//          _becomeTab = true;
//        });
//      }
//      print(_scrollController.offset);
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('公司介绍'),
          centerTitle: true,
          elevation: 0.5,
          actions: <Widget>[
            Offstage(
              offstage: widget.isFactoryDetail,
              child: IconButton(icon: Text('编辑'), onPressed: () {
                switch (_tabController.index) {
                  case 0:
                    return Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            MyFactoryBaseFormPage(widget.factory)));
                    break;
                  case 1:
                    return Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            MyCompanyContactFromPage(
                              company: widget.factory, isEditing: true,)));
                    break;
                  case 2:
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return CustomizeDialog(
                            dialogType: DialogType.RESULT_DIALOG,
                            failTips: '现款产品不可以编辑',
                            callbackResult: false,
                            confirmAction: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                    );
//                  ShowDialogUtil.showSimapleDialog(context, '现款产品不可以编辑');
                    break;
                  case 3:
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return CustomizeDialog(
                            dialogType: DialogType.RESULT_DIALOG,
                            failTips: '认证请移步`我的认证`进行认证',
                            callbackResult: false,
                            confirmAction: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                    );
//                  ShowDialogUtil.showSimapleDialog(context, '认证请移步`我的认证`进行认证');
                    break;
                  default :
                    return Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            MyCompanyContactFromPage(
                              company: widget.factory, isEditing: true,)));
                    break;
                }
              }),
            ),
          ],
        ),
        body: MyCompanyTabbar(
          widget.factory, isFactoryDetail: widget.isFactoryDetail,)
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
              builder: (context) =>
                  MyCompanyContactFromPage(
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
    return MyFactoryBaseInfo(widget.factory);
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
  Widget _buildCashProducts() {
    return FutureBuilder(
        future: UserBLoC.instance.currentUser.type == UserType.FACTORY
            ? ProductRepositoryImpl().list({
          'approvalStatuses': ['approved'],
        }, {
          'size': 3
        })
            : ProductRepositoryImpl().getProductsOfFactory({
          'approvalStatuses': ['approved'],
        }, {
          'size': 3
        }, widget.factory.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                  child: Container(
                    color: Colors.grey[Constants.SIZEDBOX_COLOR],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // 加载条
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ProgressIndicatorFactory
                              .buildDefaultProgressIndicator(),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductsPage(
                              factoryUid: widget.factory.uid,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Text(
                            '现款产品',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: const Icon(Icons.chevron_right),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: GridView.count(
                    controller: ScrollController(),
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.5 / 5,
                    children: List.generate(
                      snapshot.data.content.length,
                          (index) {
                        return ExistingProductItem(
                          snapshot.data.content[index],
                          isFactoryDetail: true,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  //图文详情

  Widget _buildCompanyCertificate() {
    return Container(
      color: Colors.white,
      child: MyCompanyCertificateWidget(
        widget.factory,
        onlyRead: true,
      ),
    );
  }

  Card _buildRegisterDate() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text('注册时间'),
        trailing:
        Text(DateFormatUtil.formatYMD(widget.factory.creationTime) ?? ''),
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
