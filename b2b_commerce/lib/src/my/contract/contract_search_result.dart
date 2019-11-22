import 'package:b2b_commerce/src/_shared/products/apparel_product_search_list.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../my_contract.dart';
import 'contract_search_result_list.dart';

class ContractSearchResultPage extends StatefulWidget{
  String keyword;

  ContractSearchResultPage({
    this.keyword = '',
    Key key,
  }) : super(key: key);

  _ContractSearchResultPageState createState() => _ContractSearchResultPageState();
}

class _ContractSearchResultPageState extends State<ContractSearchResultPage> {
  final GlobalKey _globalKey = GlobalKey<_ContractSearchResultPageState>();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<MyContractBLoC>(
      key: _globalKey,
      bloc: MyContractBLoC.instance,
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      onClick();
                    },
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300], width: 0.5),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          widget.keyword,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: MyContractSearchResultList(
              keyword: widget.keyword,
            ),
          ),
        ),
        onWillPop: (){
          Navigator.of(context).pop();
          MyContractBLoC.instance.clearByKeyword();
          return Future.value(false);
        },
      ),
    );
  }

  void onClick() async{
    Navigator.pop(context);
//    MyContractBLoC.instance.clearByKeyword();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


