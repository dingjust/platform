import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../../../services.dart';

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
          ),
        attachments: [],
      );
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

  static Future<void> validateMessage(BuildContext context, String message) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            outsideDismiss: true,
          );
        });
  }
}
