import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';


///需求表单状态管理
class RequirementOrderFormState with ChangeNotifier{
  //需求详情数据（初始化编辑表单）
  final RequirementOrderModel detailModel;
  //工厂详情数据（初始化创建表单的'已邀请工厂'）
  final FactoryModel factoryDetailModel;
  //工厂uid（初始化创建表单的'已邀请工厂'）
  final String uid;
  //合作商id（初始化创建表单的'已邀请合作商'）
  final String cid;
  RequirementOrderFormState({this.detailModel,this.uid,this.cid,this.factoryDetailModel,});

  //创建表单数据
  RequirementOrderModel _model;
  //编辑表单数据
  RequirementOrderModel _editModel;

  //已选择的工厂和合作商数据
  String _factoryUid;
  String _cooperatorId;
  List<CooperatorModel> _cooperatorModels;
  List<FactoryModel> _factoryModels;
  FactoryModel _factoryModel;
  CooperatorModel _cooperatorModel;

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

  RequirementOrderModel get editModel {
    if(_editModel == null){
      _editModel = this.detailModel;
      if(_editModel.details == null){
        _editModel.details = RequirementInfoModel(
          productiveOrientations: [],
          salesMarket: [],
          machiningType: MachiningType.LABOR_AND_MATERIAL,
          proofingNeeded: false,
          invoiceNeeded: false,
          publishingMode: 'PUBLIC',
          effectiveDays: 90,
        );
      }else{
        if(_editModel.details.productiveOrientations == null){
          _editModel.details.productiveOrientations = [];
        }
        if(_editModel.details.salesMarket == null){
          _editModel.details.salesMarket = [];
        }
        if(_editModel.details.machiningType == null){
          _editModel.details.machiningType = MachiningType.LABOR_AND_MATERIAL;
        }
        if(_editModel.details.proofingNeeded == null){
          _editModel.details.proofingNeeded = false;
        }
        if(_editModel.details.invoiceNeeded == null){
          _editModel.details.invoiceNeeded = false;
        }
        if(_editModel.details.publishingMode == null){
          _editModel.details.publishingMode = 'PUBLIC';
        }
        if(_editModel.details.effectiveDays == null){
          _editModel.details.effectiveDays = 90;
        }
      }
      if(_editModel.attachments == null){
        _editModel.attachments = [];
      }
    }
    return _editModel;
  }

  set editModel(RequirementOrderModel value) {
    _editModel = value;
  }

  String get factoryUid {
    if(uid != null){
      _factoryUid = uid;
    }
    return _factoryUid;
  }

  set factoryUid(String value) {
    _factoryUid = value;
  }

  String get cooperatorId => _cooperatorId;

  set cooperatorId(String value) {
    _cooperatorId = value;
  }

  List<CooperatorModel> get cooperatorModels {
    if(_cooperatorModels == null){
      _cooperatorModels = [];
    }
    return _cooperatorModels;
  }

  set cooperatorModels(List<CooperatorModel> value) {
    _cooperatorModels = value;
  }

  //标记是否已经加过
  bool isAdded = false;

  List<FactoryModel> get factoryModels {
   if(_factoryModels == null){
     _factoryModels = [];
   }
   if(factoryModel != null){
//     if(_factoryModels.firstWhere((model) => model.uid == factoryModel.uid,orElse: () => null) == null){
//       _factoryModels.add(factoryModel);
//     }
      if(!isAdded){
        _factoryModels.add(factoryModel);
        isAdded = true;
      }
   }
   return _factoryModels;
  }

  set factoryModels(List<FactoryModel> value) {
    _factoryModels = value;
  }

  FactoryModel get factoryModel {
     if(factoryDetailModel != null){
       _factoryModel = factoryDetailModel;
     }
     return _factoryModel;
  }

  set factoryModel(FactoryModel value) {
    _factoryModel = value;
  }

  _getData(){

  }

  //刷新model
  refresh(){
    _model = null;
    notifyListeners();
  }
}
