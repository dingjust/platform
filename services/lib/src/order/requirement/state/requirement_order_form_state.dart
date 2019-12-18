import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';


///品类状态管理
class RequirementOrderFormState with ChangeNotifier{
  final RequirementOrderModel detailModel;
  RequirementOrderFormState({this.detailModel});

  RequirementOrderModel _model;
  RequirementOrderModel _editModel;

  RequirementOrderModel get model {
    if(_model == null){
      _model = RequirementOrderModel(
          details: RequirementInfoModel(
            productiveOrientations: [],
            salesMarket: [],
            machiningType: MachiningType.LABOR_AND_MATERIAL,
            proofingNeeded: false,
            invoiceNeeded: false,
            publishingMode: 'PUBLIC',
            effectiveDays: 90,
          ),
        attachments: [],
      );
    }
    return _model;
  }

  set model(RequirementOrderModel value) {
    _model = value;
    print('==============');
  }

  RequirementOrderModel get editModel {
    if(_editModel == null){
      _editModel = this.detailModel;
    }
    return _editModel;
  }

  set editModel(RequirementOrderModel value) {
    _editModel = value;
  }

  List<CooperatorModel> _cooperatorModels;
  List<FactoryModel> _factoryModels;


  List<CooperatorModel> get cooperatorModels {
    if(_cooperatorModels == null){
      _cooperatorModels = [];
    }
    return _cooperatorModels;
  }

  set cooperatorModels(List<CooperatorModel> value) {
    _cooperatorModels = value;
  }

  List<FactoryModel> get factoryModels {
   if(_factoryModels == null){
     _factoryModels = [];
   }
   return _factoryModels;
  }

  set factoryModels(List<FactoryModel> value) {
    _factoryModels = value;
  }

  _getData(){

  }

  //刷新model
  refresh(){
    _model = null;
    notifyListeners();
  }
}
