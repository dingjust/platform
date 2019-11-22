
import 'package:b2b_commerce/src/my/contract/contract_seal_page.dart';
import 'package:b2b_commerce/src/my/contract/contract_select_from_page.dart';
import 'package:b2b_commerce/src/my/contract/contract_template.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class MyContractManagePage extends StatefulWidget {
  _MyContractManagePageState createState() => _MyContractManagePageState();
}

class _MyContractManagePageState extends State<MyContractManagePage>{
  List<SealModel> sealList;
  ContractCount count;
  var _futureBuilderFuture;

  @override
  void initState() {
    initSeal();
    _futureBuilderFuture = getData();
    super.initState();
  }

  initSeal() async{
    sealList = await ContractRepository().getSealList({'type':''}, {'page':'0','size':'100'});
  }

  Future<CertificationContractCount> getData() async{
    CertificationContractCount contractCount = await ContractRepository().getContractCount();
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
          }, initialData: null,
          future: _futureBuilderFuture,
        ),
        bottomNavigationBar: Container(
          color: Colors.white10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '创建新合同',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ContractSelectFromItemPage()));
            },
          ),
        )
    );
  }

  Widget _buildHead(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) =>MyContractPage()));
            },
            child: Container(
              child:Column(
                children: <Widget>[
                  Image.asset(
                    'temp/all_contract.png',
                    package: 'assets',
                    width: 80,
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                       '全部合同',
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) =>MyContractTemplatePage()));
            },
            child: Container(
              child:Column(
                children: <Widget>[
                  Image.asset(
                    'temp/all_template.png',
                    package: 'assets',
                    width: 80,
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '我的模板',
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) =>ContractSealPage(sealList: sealList,)));
            },
            child: Container(
              child:Column(
                children: <Widget>[
                  Image.asset(
                    'temp/all_seal.png',
                    package: 'assets',
                    width: 80,
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '我的印章',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black54,width: 1))
      ),
    );
  }

  Widget _buildMain(ContractCount count){
    return Container(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MyContractPage(type: 'WAIT_ME_SIGN')));
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text('待我签署'),
                  ),
                  Container(
                    child: Text('${count != null ? count.waitMeSign : ''}'),
                  )
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.black54,width: 0.5),
                    bottom: BorderSide(color: Colors.black54,width: 1)
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MyContractPage(type: 'WAIT_PARTNER_SIGN')));
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text('待他签署'),
                  ),
                  Container(
                    child: Text('${count != null ? count.waitPartnerSign : ''}'),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Colors.black54,width: 0.5),
                      bottom: BorderSide(color: Colors.black54,width: 1)
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHelp(){
    return Container(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text('如何选择合同类型？'),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(color: Colors.black54,width: 0.5),
                  bottom: BorderSide(color: Colors.black54,width: 1)
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text('什么是电子合同？'),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: Colors.black54,width: 0.5),
                  bottom: BorderSide(color: Colors.black54,width: 1)
              ),
            ),
          )
        ],
      ),
    );
  }

}