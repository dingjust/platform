import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';


///品类状态管理
class RequirementOrderFormState with ChangeNotifier{
  final String factoryUid;
  RequirementOrderFormState({this.factoryUid});

  RequirementOrderModel _model;

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


  //刷新model
  refresh(){
    _model = null;
    notifyListeners();
  }
}
