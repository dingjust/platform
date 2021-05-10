import 'package:flutter/material.dart';

import 'package:models/models.dart';
import 'package:services/services.dart';

import 'seal/contract_seal_page.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/my/contract/contract_template.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';

class MyContractManagePage extends StatefulWidget {
  _MyContractManagePageState createState() => _MyContractManagePageState();
}

class _MyContractManagePageState extends State<MyContractManagePage> {
  List<SealModel> sealList;
  ContractCount count;
  var _futureBuilderFuture;

  @override
  void initState() {
    initSeal();
    _futureBuilderFuture = getData();
    super.initState();
  }

  initSeal() async {
    sealList = await ContractRepository()
        .getSealList({'type': ''}, {'page': '0', 'size': '100'});
  }

  Future<CertificationContractCount> getData() async {
    CertificationContractCount contractCount =
        await ContractRepository().getContractCount();
    return contractCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('合同管理'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: FutureBuilder<CertificationContractCount>(
        builder: (BuildContext context,
            AsyncSnapshot<CertificationContractCount> snapshot) {
          if (snapshot.data != null) {
            return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _buildHead(),
                  _buildMain(snapshot.data.data),
                  _buildHelp(),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        initialData: null,
        future: _futureBuilderFuture,
      ),
      // bottomNavigationBar: Container(
      //   color: Colors.white,
      //   padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      //   child: FlatButton(
      //     color: Color.fromRGBO(255, 214, 12, 1),
      //     child: Padding(
      //       padding: EdgeInsets.symmetric(vertical: 10),
      //       child: Text(
      //         '发起签署',
      //         style: TextStyle(
      //           color: Colors.black,
      //           fontSize: 18,
      //         ),
      //       ),
      //     ),
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(5))),
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => ContractSelectFromItemPage()));
      //     },
      //   ),
      // )
    );
  }

  Widget _buildHead() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyContractPage()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                B2BImage.allContract(width: 50, height: 50),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '全部合同',
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyContractTemplatePage()));
            },
            child: Column(
              children: <Widget>[
                B2BImage.myContract(width: 50, height: 50),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '我的模板',
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContractSealPage(
                            isSelect: false,
                          )));
            },
            child: Column(
              children: <Widget>[
                B2BImage.mySeal(width: 50, height: 50),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '我的印章',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: Colors.grey[300], width: 1))),
    );
  }

  Widget _buildMain(ContractCount count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey[400], width: 1)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyContractPage(type: 'WAIT_ME_SIGN')));
              },
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        B2BImage.waitMySign(width: 30, height: 30),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('待我签署'),
                              Text('${count != null ? count.waitMeSign : ''}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          Container(
            width: 20,
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey[400], width: 1)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyContractPage(type: 'WAIT_PARTNER_SIGN')));
              },
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        B2BImage.waitOtherSign(width: 30, height: 30),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('待他签署'),
                              Text('${count != null
                                  ? count.waitPartnerSign
                                  : ''}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelp() {
    return Container(
      margin: EdgeInsets.only(top: 200),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text('如何选择合同类型？'),
          ),
          Text('什么是电子合同？')
        ],
      ),
    );
  }
}
