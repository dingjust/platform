import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'my_factory_base_form.dart';
import 'my_factory_contact_form.dart';

class MyFactoryFormPage extends StatefulWidget {
  FactoryModel factory;

  MyFactoryFormPage({this.factory});

  _MyFactoryFormPageState createState() => _MyFactoryFormPageState();
}

class _MyFactoryFormPageState extends State<MyFactoryFormPage>
    with SingleTickerProviderStateMixin {
  List<EnumModel> _states = [
    EnumModel('base', '基本资料'),
    EnumModel('contact', '联系方式'),
  ];
  TabController _tabController;
  FactoryModel _factory = FactoryModel();
  List<MediaModel> _medias = [];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: _states.length);
//    _factory = FactoryModel.fromJson(FactoryModel.toJson(widget.factory));
    FactoryModel.populator(widget.factory, _factory);
    if (widget.factory.profilePicture != null) {
      _medias = [widget.factory.profilePicture];
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('编辑公司信息'),
          elevation: 0.5,
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[100],
        body: Scaffold(
          appBar: TabBar(
            controller: _tabController,
            tabs: _states.map((state) {
              return Tab(
                child: Text(state.name),
              );
            }).toList(),
          ),
          body: TabBarView(
            controller: _tabController,
              children: _states.map((state) {
            switch (state.code) {
              case 'base':
                return MyFactoryBaseFormPage(_factory,medias: _medias,);
                break;
              case 'contact':
                return MyFactoryContactFormPage(
                  company: _factory,
                  isEditing: true,
                );
                break;
            }
          }).toList()),
        ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '保存',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () async {
              _factory.profilePicture = _medias.isNotEmpty ? _medias[0] : null;
              if(_factory.contactPerson == null){
                _showValidateMsg(context, '请填写联系人');
                return;
              }
              if(_factory.contactPhone == null){
                _showValidateMsg(context, '请填写联系电话');
                return;
              }
              if(_factory.contactAddress == null || _factory.contactAddress.region == null || _factory.contactAddress.line1 == null){
                _showValidateMsg(context, '请填写经营地址');
                return;
              }
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return RequestDataLoading(
                      requestCallBack: UserRepositoryImpl()
                          .factoryUpdateContact(_factory),
                      loadingText: '保存中。。。',
                      entrance: '00',
                    );
                  }).then((v){
                    Navigator.pop(context);
              });
            }),
      ),
    );
  }

  //非空提示
  bool _showValidateMsg(BuildContext context, String message) {
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context, String message) async {
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
