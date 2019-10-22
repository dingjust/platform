
import 'package:b2b_commerce/src/my/contract/contract_cgdd_from.dart';
import 'package:b2b_commerce/src/my/contract/contract_kjxy_from.dart';
import 'package:b2b_commerce/src/my/contract/contract_wtscht_from.dart';
import 'package:flutter/material.dart';

class ContractSelectFromItemPage extends StatefulWidget {

  ContractSelectFromItemPage();
  _ContractSelectFromItemPageState createState() => _ContractSelectFromItemPageState();
}

class _ContractSelectFromItemPageState extends State<ContractSelectFromItemPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _buildPage(),
      ),
    );
  }

  Widget _buildPage(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: Container(
              child: Text(
                 '签署合同',
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color.fromRGBO(255, 214, 12, 1),width: 1)),
              ),
            ),
          ),
          Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                      'temp/contract_help.png',
                      package: 'assets',
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    '如何选择合同类型',
                    style: TextStyle(
                        fontSize: 24
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>ContractWTSCHTFrom()));
                  },
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                            child: Image.asset(
                              'temp/wtsc.png',
                              package: 'assets',
                              width: 80,
                              height: 80,
                            ),
                        ),
                      ),
                      Center(
                       child: Container(
                         child: Text(
                           '委托生产合同'
                         ),
                       ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>ContractCGDDFrom()));
                  },
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: Image.asset(
                            'temp/cgdd.png',
                            package: 'assets',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                              '采购订单'
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>ContractKJXYFrom()));
                  },
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: Image.asset(
                            'temp/kjxy.png',
                            package: 'assets',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                              '框架协议'
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Center(
              child: Container(
                child: Icon(
                  Icons.close,
                  size: 30,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

}