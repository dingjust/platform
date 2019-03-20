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
        future:
            _userRepository.getFactory(UserBLoC.instance.currentUser.companyCode),
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
            return Container(child: _buildFactory(context));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        },
      ),
    );
  }

  Widget _buildFactory(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          elevation: 0,
          margin: EdgeInsets.only(top: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15,),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 214, 12, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('编辑'),
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
                        padding:
                            EdgeInsets.only(left: 10),
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
                              starLevel: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "已认证",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(255, 214, 12, 1)),
                                ),
                                Text('广东广州白云'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
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
                      company.monthlyCapacityRanges == null ? '' : MonthlyCapacityRangesLocalizedMap[company.monthlyCapacityRanges],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
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
                SizedBox(
                  height: 20,
                ),
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
                SizedBox(height: 20,),
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '风格',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      '年龄段',
//                      style: TextStyle(
//                        color: Colors.grey,
//                        fontSize: 16,
//                      ),
//                    ),
//                    Text(
//                      '',
//                      style: TextStyle(fontSize: 16),
//                    ),
//                  ],
//                ),
//                SizedBox(
//                  height: 20,
//                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '春夏款价格端',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '秋冬款价格端',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                     '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
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
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.only(top: 10),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            title: Text('公司认证信息'),
            trailing: Icon(Icons.chevron_right),
            onTap: (){

            },
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.only(top: 10),
          child: ListTile(
            title: Text('注册时间'),
            trailing: Text(DateFormatUtil.formatYMD(company.registrationDate) ?? ''),
          ),
        )
      ],
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
        text += '  '+AgeRangesLocalizedMap[ageRange];
      });
    }
    return text;
  }
  String formatPriceRangesText(List<PriceRanges> priceRanges) {
    String text = '';
    if (priceRanges != null && priceRanges.isNotEmpty) {
      priceRanges.forEach((priceRange) {
        text += '  ￥'+PriceRangesLocalizedMap[priceRange];
      });
    }
    return text;
  }
}
