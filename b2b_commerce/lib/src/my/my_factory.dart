import 'package:b2b_commerce/src/business/products/existing_product.dart';
import 'package:b2b_commerce/src/business/products/existing_product_item.dart';
import 'package:b2b_commerce/src/my/company/form/my_company_profile_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_base_form.dart';
import 'package:b2b_commerce/src/my/company/my_company_certificate.dart';
import 'package:b2b_commerce/src/my/company/my_company_contact_way.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 认证信息
class MyFactoryPage extends StatefulWidget {
  _MyFactoryPageState createState() => _MyFactoryPageState();
}

class _MyFactoryPageState extends State<MyFactoryPage> {
  FactoryModel company;
  UserRepository _userRepository = UserRepositoryImpl();
  UserType type = UserType.ANONYMOUS;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('公司介绍'),
        elevation: 0.5,
        actions: <Widget>[
          Container(
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
                      builder: (context) => MyCompanyContactWayPage(company)),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: _userRepository
            .getFactory(UserBLoC.instance.currentUser.companyCode),
        // initialData: null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            company = snapshot.data;
            print('${company.approvalStatus}=============');
            return Container(child: _buildFactory(context));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        },
      ),
    );
  }

  Widget _buildFactory(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView(
        children: <Widget>[
          _buildBaseInfo(),
          FutureBuilder<dynamic>(
            future: ProductRepositoryImpl().list({}, {'size': 3}),
            // initialData: null,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 200),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                return _buildCashProducts(context, snapshot.data.content);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            },
          ),
          _buildFactoryWorkPicInfo(context),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              title: Text('公司认证信息'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyCompanyCertificatePage(company,onlyRead: true,)));
              },
            ),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text('注册时间'),
              trailing: Text(
                  DateFormatUtil.formatYMD(company.registrationDate) ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  Card _buildBaseInfo() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 214, 12, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('编辑'),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyFactoryBaseFormPage(company)));
                    },
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: company.profilePicture != null
                            ? NetworkImage(
                                '${GlobalConfigs.IMAGE_BASIC_URL}${company.profilePicture.url}')
                            : AssetImage(
                                'temp/picture.png',
                                package: "assets",
                              ),
                        fit: BoxFit.cover,
                      )),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          company.name,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
//                        company.starLevel == null ? Container() : Stars(starLevel:company.starLevel),
                        Stars(
                          starLevel: company.starLevel ?? 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              company.approvalStatus == ArticleApprovalStatus.approved ? "已认证" : '未认证',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(255, 214, 12, 1)),
                            ),
//                            Text('广东广州白云'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Text('历史接单'),
                  Text(
                    '${company.historyOrdersCount}',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text('单，响应报价时间：'),
                  Text(
                    '${company.responseQuotedTime}',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text('小时（平均）'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '月均产能',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  company.monthlyCapacityRanges == null
                      ? ''
                      : MonthlyCapacityRangesLocalizedMap[
                          company.monthlyCapacityRanges],
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '产值规模',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ScaleRangesLocalizedMap[company.scaleRange],
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '生产大类',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatCategorySelectText(company.categories),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '优势类目',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatCategorySelectText(company.adeptAtCategories),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '合作品牌商',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  company.cooperativeBrand,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Card _buildCashProducts(BuildContext context, List<ProductModel> products) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: GestureDetector(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Text(
                          '现款商品',
                          style: TextStyle(
                            fontSize: 16,
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
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: GridView.count(
                      physics: new NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 2.5 / 5,
                      children: List.generate(products.length, (index) {
                        return ExistingProductItem(products[index]);
                      })),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onTap: () async {
            ProductsResponse productsResponse =
                await ProductRepositoryImpl().list({}, {});

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExistingProductsPage(productsResponse.content),
              ),
            );
          }),
    );
  }

  //工厂生产环境
  Widget _buildFactoryWorkPicInfo(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 214, 12, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('编辑'),
                    ),
                    onTap: (){
                      if(company.companyProfiles == null) company.companyProfiles = [];
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCompanyProfileFormPage(company)));
                    },
                  )
                ],
              ),
            ),
            Container(
                width: double.infinity,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Image.network(
                          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548324012344&di=9d970990f5941d68919dfbe264b328c9&imgtype=0&src=http%3A%2F%2Fwww.gdhangying.com%2Fewinupfile%2F2016102911390175014.jpg',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '新型H-365裁衣机床',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Image.network(
                          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548324406887&di=065efea8f76ed217de5dbaaed0178471&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F6a600c338744ebf835dc43c9d3f9d72a6159a792.jpg',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '新型H-365裁衣机床',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  String formatCategorySelectText(List<CategoryModel> categorys) {
    String text = '';
    if (categorys != null && categorys.isNotEmpty) {
      categorys.forEach((category) {
        text += category.name;
      });
    }
    return text;
  }

  String formatAgeRangesText(List<AgeRanges> ageRanges) {
    String text = '';
    if (ageRanges != null && ageRanges.isNotEmpty) {
      ageRanges.forEach((ageRange) {
        text += '  ' + AgeRangesLocalizedMap[ageRange];
      });
    }
    return text;
  }

  String formatPriceRangesText(List<PriceRanges> priceRanges) {
    String text = '';
    if (priceRanges != null && priceRanges.isNotEmpty) {
      priceRanges.forEach((priceRange) {
        text += '  ￥' + PriceRangesLocalizedMap[priceRange];
      });
    }
    return text;
  }
}
