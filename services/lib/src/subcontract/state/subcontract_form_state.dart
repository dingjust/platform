import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';


///转包表单状态管理
class SubContractFormState with ChangeNotifier{
  SubContractFormState();

  //创建表单数据
  SubContractModel _model;

  SubContractModel get model {
    if(_model == null){
      _model = SubContractModel(
          details: SubContractInfoModel(
            type: 'SUBCONTRACT',
            productiveOrientations: [],
            salesMarket: [],
            machiningType:'LABOR_AND_MATERIAL',
            invoiceNeeded: false,
            effectiveDays: 90,
          ),
      );
    }
    return _model;
  }

  set model(SubContractModel value) {
    _model = value;
  }


  //刷新model
  refresh(){
    _model = null;
    notifyListeners();
  }
}
