import 'package:b2b_commerce/src/my/my_brand.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class CooperatorDetailPage extends StatefulWidget {
  final int id;
  CooperatorDetailPage({Key key, @required this.id}) : super(key: key);

  @override
  _CooperatorDetailPageState createState() => _CooperatorDetailPageState();
}

class _CooperatorDetailPageState extends State<CooperatorDetailPage> {
  CooperatorModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('合作商详情'),
        elevation: 0.5,
      ),
      body: FutureBuilder<CooperatorModel>(
          initialData: null,
          future: _getData(),
          builder:
              (BuildContext context, AsyncSnapshot<CooperatorModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasError && snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      _InputRow(
                          label: '合作商类型',
                          child: Text(
                            CooperatorType.ONLINE == model.type
                                ? '线上合作商'
                                : '线下合作商',
                            style: TextStyle(fontSize: 18),
                          )),
                      _buildNameInfo(),
                      _InputRow(
                          label: '联系人',
                          child: Text(
                            '${model.contactPerson}',
                            style: TextStyle(fontSize: 18),
                          )),
                      _InputRow(
                          label: '联系方式',
                          child: Text(
                            '${model.contactPhone}',
                            style: TextStyle(fontSize: 18),
                          )),
                      _InputRow(
                          label: '身份类型',
                          child: Text(
                            '${CooperatorCategoryLocalizedMap[model.category]}',
                            style: TextStyle(fontSize: 18),
                          )),
                      _InputRow(
                          label: '开户行',
                          child: Text(
                            '${model.bankOfDeposit}',
                            style: TextStyle(fontSize: 18),
                          )),
                      _InputRow(
                          label: '银行账号',
                          child: Text(
                            '${model.bankAccount}',
                            style: TextStyle(fontSize: 18),
                          )),
                      _InputRow(
                          label: '税号',
                          child: Text(
                            '${model.taxNumber}',
                            style: TextStyle(fontSize: 18),
                          )),
                      _InputRow(
                          label: '绑定账务方案',
                          child: Text(
                            '${model.payPlan != null ? model.payPlan.name : ''}',
                            style: TextStyle(fontSize: 18),
                          )),
                      _InputRow(
                          label: '备注',
                          child: Text(
                            '${model.remarks}',
                            style: TextStyle(fontSize: 18),
                          )),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('查询失败，请稍后再试！'),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<CooperatorModel> _getData() async {
    if (model == null) {
      CooperatorModel detailModel =
          await CooperatorRepositoryImpl().getDetail(widget.id);
      model = detailModel;
    }
    return model;
  }

  Widget _buildNameInfo() {
    return Container(
        constraints: BoxConstraints(minHeight: 70),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
              top: BorderSide(
                color: Colors.grey[300],
              )),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 120,
              child: Text(
                '合作商名称',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text('${model.name}',
                              style: TextStyle(fontSize: 18)),
                        ),
                        Container(
                          height: 20,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: Color.fromRGBO(68, 138, 255, 1))),
                          child: Center(
                            child: Text(
                              '未认证',
                              style: TextStyle(
                                  color: Color.fromRGBO(68, 138, 255, 1),
                                  fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  model.partner != null
                      ? Container(
                          height: 30,
                          width: 70,
                          child: FlatButton(
                            color: Color.fromRGBO(255, 214, 12, 1),
                            onPressed: () {
                              if (model.partner.type == CompanyType.FACTORY) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyFactoryPage(
                                      factoryUid: model.partner.uid,
                                      isFactoryDetail: true,
                                      isSupplier: true,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyBrandPage(
                                      model.partner.uid,
                                      isDetail: true,
                                      isSupplier: true,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              '详情',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ));
  }
}

class _InputRow extends StatelessWidget {
  final String label;

  final Widget child;

  final Widget suffix;

  final double labelWidth;

  final double height;

  final EdgeInsetsGeometry padding;

  final bool top;

  const _InputRow(
      {Key key,
      this.label,
      this.child,
      this.suffix,
      this.labelWidth = 120,
      this.height = 70,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      this.top = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
              top: BorderSide(
                width: top ? 0.5 : 0,
                color: Colors.grey[300],
              )),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: labelWidth,
              child: Text(
                '$label',
                style: TextStyle(fontSize: 16),
              ),
            ),
            child != null ? Expanded(flex: 1, child: child) : Container(),
            suffix != null ? suffix : Container()
          ],
        ));
  }
}
