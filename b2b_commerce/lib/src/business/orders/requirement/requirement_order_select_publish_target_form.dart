import 'dart:async';

import 'package:b2b_commerce/src/_shared/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/_shared/cooperator/cooperator_select.dart';
import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/machining_type_field.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/business/orders/form/production_areas_field.dart';
import 'package:b2b_commerce/src/business/orders/form/remarks_field.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requriement_order_select_factory_item.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:b2b_commerce/src/my/company/_shared/factory_list_item.dart';
import 'package:b2b_commerce/src/my/company/_shared/factory_select.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'RequirementFormMixins.dart';

/// 需求发布选择发布对象
class RequirementOrderSelectPublishTargetForm extends StatefulWidget {
  RequirementOrderSelectPublishTargetForm({
    this.formState,
  });

  final RequirementOrderFormState formState;

  _RequirementOrderSelectPublishTargetFormState createState() =>
      _RequirementOrderSelectPublishTargetFormState();
}

class _RequirementOrderSelectPublishTargetFormState
    extends State<RequirementOrderSelectPublishTargetForm>
    with RequirementFormMixin,AutomaticKeepAliveClientMixin {
  GlobalKey _scaffoldKey = GlobalKey();
  List<CooperatorModel> _cooperatorModels = [];
  List<FactoryModel> _factoryModels = [];
  List<String> _selectUids = [];

  @override
  void initState() {
    print(widget.formState.cooperatorModels);
    print(widget.formState.factoryModels);
    print(widget.formState.factoryModel);
    _cooperatorModels = List.from(widget.formState.cooperatorModels);
    _factoryModels = List.from(widget.formState.factoryModels);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('选择发布对象'),
        actions: <Widget>[],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '确       定',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            onPressed: () async {
              //统计当前页面选中的uid
              _selectUids.clear();
              _selectUids.addAll(_cooperatorModels.where((coop) => coop.type == CooperatorType.ONLINE && !_selectUids.contains(coop.partner.uid)).map((coop) => coop.partner.uid));
              _selectUids.addAll(_factoryModels.where((factory) => !_selectUids.contains(factory.uid)).map((factory) => factory.uid));
              widget.formState.cooperatorModels = List.from(_cooperatorModels);
              widget.formState.factoryModels = List.from(_factoryModels);
              print(_selectUids);
              Navigator.pop(context,_selectUids);
            }),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: ()async{
                  dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CooperatorSelectPage(models: this._cooperatorModels,)));

                  if(result != null){
                    this._cooperatorModels = result;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('从我的供应商中选择'),
                      Row(
                        children: <Widget>[
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(text: '已选择',style: TextStyle(color: Colors.black,)),
                                TextSpan(text: this._cooperatorModels.length.toString(),style: TextStyle(color: Colors.red,)),
                                TextSpan(text: '家',style: TextStyle(color: Colors.black,)),
                              ]
                          ),),
                          Icon(Icons.chevron_right),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(height: 0,),
              InkWell(
                onTap: ()async{
                  dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FactorySelectPage(factoryModels: this._factoryModels,)));

                  print(result);
                  if(result != null){
                    this._factoryModels = result;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('从全部工厂中选择'),
                      Row(
                        children: <Widget>[
                          RichText(text: TextSpan(
                            children: [
                              TextSpan(text: '已选择',style: TextStyle(color: Colors.black,)),
                              TextSpan(text: this._factoryModels.length.toString(),style: TextStyle(color: Colors.red,)),
                              TextSpan(text: '家',style: TextStyle(color: Colors.black,)),
                            ]
                          ),),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 0,),
//              Container(
//                padding: const EdgeInsets.only(top: 10, right: 15),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    RaisedButton(
//                      color: Color(0xffffd60c),
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(8)),
//                      onPressed: () async {
//                        dynamic result = await Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    CooperatorSelectPage(models: this._cooperatorModels,)));
//
//                        if(result != null){
//                          this._cooperatorModels = result;
//                        }
//                      },
//                      child: Text('选择我的线上合作商'),
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                padding: const EdgeInsets.only(top: 10, right: 15,bottom: 10),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    RichText(
//                      text: TextSpan(children: [
//                        TextSpan(
//                          text: '已选择',
//                          style: TextStyle(color: Colors.black),
//                        ),
//                        TextSpan(
//                          text: this._cooperatorModels.length.toString(),
//                          style: TextStyle(color: Colors.red),
//                        ),
//                        TextSpan(
//                          text: '家',
//                          style: TextStyle(color: Colors.black),
//                        ),
//                      ]),
//                    ),
//                  ],
//                ),
//              ),
//              Expanded(
//                child: Container(
//                  margin: EdgeInsets.all(10),
//                  decoration: ShapeDecoration(
//                    shape: Border.all(color: Colors.grey),
//                  ),
//                  child: ListView(
//                    children: this._cooperatorModels != null
//                        ? this._cooperatorModels.map((cooperator) {
//                      return _buildRow(cooperator);
//                    }).toList()
//                        : Center(
//                      child: CircularProgressIndicator(),
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                padding: const EdgeInsets.only(top: 10, right: 15),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    RaisedButton(
//                      color: Color(0xffffd60c),
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(8)),
//                      onPressed: () async {
//                        dynamic result = await Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    FactorySelectPage(factoryModels: this._factoryModels,)));
//
//                        print(result);
//                        if(result != null){
//                          this._factoryModels = result;
//                        }
//                      },
//                      child: Text('选择全部工厂'),
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                padding: const EdgeInsets.only(top: 10, right: 15,bottom: 10),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    RichText(
//                      text: TextSpan(children: [
//                        TextSpan(
//                          text: '已选择',
//                          style: TextStyle(color: Colors.black),
//                        ),
//                        TextSpan(
//                          text: this._factoryModels.length.toString(),
//                          style: TextStyle(color: Colors.red),
//                        ),
//                        TextSpan(
//                          text: '家',
//                          style: TextStyle(color: Colors.black),
//                        ),
//                      ]),
//                    ),
//                  ],
//                ),
//              ),
//              Expanded(
//                child: Container(
//                  margin: EdgeInsets.all(10),
//                  decoration: ShapeDecoration(
//                    shape: Border.all(color: Colors.grey),
//                  ),
//                  child: ListView(
//                    children: this._factoryModels != null
//                        ? this._factoryModels.map((factory) {
//                      return _buildFactoryItemRow(factory);
//                    }).toList()
//                        : Center(
//                      child: CircularProgressIndicator(),
//                    ),
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 发布
  void onPublish() async {}

  Widget _buildRow(CooperatorModel cooperator) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: CooperatorItem(
                model: cooperator,
              ),
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.cancel), onPressed: (){
          setState(() {
            this._cooperatorModels.remove(cooperator);
          });
        }),
      ],
    );
  }

  Widget _buildFactoryItemRow(FactoryModel factoryModel) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: RequirementOrderSelectFactoryItem(
                model: factoryModel,
              ),
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.cancel), onPressed: (){
          setState(() {
            this._factoryModels.remove(factoryModel);
          });
        }),
      ],
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }


}
