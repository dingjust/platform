import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:b2b_commerce/src/my/contract/seal_select_widget.dart';
import 'package:flutter/material.dart';

import 'contract_select_widget.dart';
import 'contract_webview_page.dart';

class JoinOrderContractPage extends StatefulWidget{
  _JoinOrderContractPageState createState() => _JoinOrderContractPageState();
}

class _JoinOrderContractPageState extends State<JoinOrderContractPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('关联订单合同'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            _buildSelectOrderItem(),
            _buildSelectContractItem(),
            _buildSelectSealItem(),
          ],
        ),
      ),
        bottomNavigationBar: Container(
          color: Colors.white10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '去签约',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: (){
//              Navigator.push(
//                context,MaterialPageRoute(builder: (context) => WebViewPage()),
//              );
            },
          ),
        )
    );
  }

  Widget _buildSelectOrderItem(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            width: 80,
            height: 80,
            child: Image.asset(
              'temp/select_order.png',
              package: 'assets',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: RichText(
              text: TextSpan(
                  text: '选择关联订单',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        )),
                  ]),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 3,color: Colors.black38)
      ),
    );
  }

  Widget _buildSelectContractItem(){
    return GestureDetector(
      onTap: (){
        ContractSelectWidget(cacel: () {
          setState(() {
          });
          Navigator.pop(context);
        }).showAddressPicker(
          context,
          selectType: (province) {
          },
          selectTemplate: (city) {
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              width: 80,
              height: 80,
              child: Image.asset(
                'temp/select_contract.png',
                package: 'assets',
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text: '选择合同模板',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                )),
                          ]),
                    ),
                  ),
                  Container(
                    child: Text(
                      '上传纸质合同仅支持电脑端',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 3,color: Colors.black38)
        ),
      ),
    );
  }

  Widget _buildSelectSealItem(){
    return GestureDetector(
      onTap: (){
        SealSelectWidget(cacel: () {
          setState(() {
          });
          Navigator.pop(context);
        }).showAddressPicker(
          context,
          selectType: (province) {
          },
          selectTemplate: (city) {
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              width: 80,
              height: 80,
              child: Image.asset(
                'temp/select_seal.png',
                package: 'assets',
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: RichText(
                text: TextSpan(
                    text: '选择印章',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          )),
                    ]),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 3,color: Colors.black38)
        ),
      ),
    );
  }

}