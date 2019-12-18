import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';


///品类状态管理
class RequirementOrderEditFormState with ChangeNotifier{
  final RequirementOrderModel detailModel;
  RequirementOrderEditFormState({this.detailModel});

  RequirementOrderModel _model;

  RequirementOrderModel get model {
    if(_model == null){
      _model = this.detailModel;
      if(_model.details == null){
        _model.details = RequirementInfoModel(
          productiveOrientations: [],
          salesMarket: [],
          machiningType: MachiningType.LABOR_AND_MATERIAL,
          proofingNeeded: false,
          invoiceNeeded: false,
          publishingMode: 'PUBLIC',
          effectiveDays: 90,
        );
      }else{
        if(_model.details.productiveOrientations == null){
          _model.details.productiveOrientations = [];
        }
        if(_model.details.salesMarket == null){
          _model.details.salesMarket = [];
        }
        if(_model.details.machiningType == null){
          _model.details.machiningType = MachiningType.LABOR_AND_MATERIAL;
        }
        if(_model.details.proofingNeeded == null){
          _model.details.proofingNeeded = false;
        }
        if(_model.details.invoiceNeeded == null){
          _model.details.invoiceNeeded = false;
        }
        if(_model.details.publishingMode == null){
          _model.details.publishingMode = 'PUBLIC';
        }
        if(_model.details.effectiveDays == null){
          _model.details.effectiveDays = 90;
        }
      }
      if(_model.attachments == null){
        _model.attachments = [];
      }
    }
    return _model;
  }

  set model(RequirementOrderModel value) {
    _model = value;
  }

  //刷新model
  refresh(){
    _model = null;
    notifyListeners();
  }
}
