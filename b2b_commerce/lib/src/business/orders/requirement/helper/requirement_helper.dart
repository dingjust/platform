import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../requirement_order_form.dart';

class RequirementHelper {
  ///指定工厂发布需求
  static publishToFactory({BuildContext context, FactoryModel factory}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Opacity(
            opacity: 1,
            child: Container(
              height: 300,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (factory == null) {
                              return;
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MultiProvider(
                                          providers: [
                                            ChangeNotifierProvider(
                                              create: (_) =>
                                                  RequirementOrderFormState(
                                                uid: factory.uid,
                                                factoryDetailModel: factory,
                                              ),
                                            ),
                                          ],
                                          child: Consumer(builder: (context,
                                              RequirementOrderFormState state,
                                              _) {
                                            return RequirementOrderForm(
                                              formState: state,
                                            );
                                          }),
                                        ))).then((v) {
                              Navigator.pop(context);
                            });
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
                                  child: Text('发布新需求'),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (factory == null) {
                              return;
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RequirementOrderSelectPage(
                                          onConfirm: (models) async {
                                            List<RequirementOrderModel>
                                                requirements = models as List<
                                                    RequirementOrderModel>;
                                            List<String> codes = [];
                                            if (requirements != null) {
                                              codes = requirements
                                                  .map((model) => model.code)
                                                  .toList();
                                            }
                                            if (factory != null) {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) {
                                                    return RequestDataLoading(
                                                      requestCallBack:
                                                          RequirementOrderRepository()
                                                              .doRecommendations(
                                                                  codes, [
                                                        factory.uid
                                                      ]),
                                                      outsideDismiss: false,
                                                      loadingText: '正在邀请。。。',
                                                      entrance: '',
                                                    );
                                                  }).then((value) {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (_) {
                                                      return CustomizeDialog(
                                                        dialogType: DialogType
                                                            .RESULT_DIALOG,
                                                        successTips: '邀请成功',
                                                        failTips: '邀请失败',
                                                        callbackResult: value,
                                                        confirmAction: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    });
                                              });
                                            }
                                          },
                                        )));
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
                                  child: Text('选择已有需求'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Container(
                          child: Icon(
                        Icons.close,
                        size: 30,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
