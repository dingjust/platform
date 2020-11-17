import 'package:dio/dio.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';

class CompanySelectPage extends StatefulWidget {

  CompanySelectPage({Key key}) : super(key: key);

  @override
  _CompanySelectPageState createState() => _CompanySelectPageState();
}

class _CompanySelectPageState extends State<CompanySelectPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '公司列表';
  String hintText = '输入公司名称或账号';
  String _keyword = '';
 
  List<CompanyModel> _companyModels;

  CompanyModel selectedCompany;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: FutureBuilder<List<CompanyModel>>(
        initialData: null,
        future: _getData(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CompanyModel>> snapshot) {
          if (_keyword == '') {
            return isSearching
                ? Container()
                : _buildTips('输入查询的公司名称或账号');
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError && snapshot.hasData) {
              return CompanySelectList(
                data: _companyModels,
                onItemTap: onItemTap,
                selectedCompany: selectedCompany,
              );
            } else {
              return _buildTips('查询失败，请稍后再试！');
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBottom() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: FlatButton(
                color: Color.fromRGBO(255, 214, 12, 1),
                onPressed: () {
                  Navigator.of(context).pop(selectedCompany);
                  selectedCompany = null;
                  _keyword = '';
                },
                child: Text(
                  '确定',
                  style: TextStyle(fontSize: 18),
                ),
              )),
        ],
      )
    );
  }

  Widget _buildTips(String tip) {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text(tip)],
      ),
    );
  }

  Future<List<CompanyModel>> _getData() async {
    if (_keyword == '') {
      _companyModels = null;
    } else if (_companyModels == null) {
      try {
        var response = await http$.post(UserApis.companies,
            data: {'keyword': _keyword},
            queryParameters: {'page': 0, 'size': 20});
        if (response != null && response.statusCode == 200) {
          CompanyResponse companiesResponse =
              CompanyResponse.fromJson(response.data);
          _companyModels = companiesResponse.content;
        }
      } on DioError catch (e) {
        print(e);
      }
    }
    return _companyModels;
  }

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: SearchAppbarTitle(
              controller: controller,
              focusNode: focusNode,
              hintText: hintText,
              onSearch: () {
                _keyword = controller.text;
                if (controller.text == '') {
                  setState(() {
                    isSearching = false;
                    selectedCompany = null;
                  });
                }
              },
              onChange: (v) {
                _keyword = controller.text;
                setState(() {
                  _companyModels = null;
                });
              },
            ))
        : AppBarFactory.buildDefaultAppBar('$appBarTitle',
            actions: <Widget>[_buildSearchButton()]);
  }

  Widget _buildSearchButton() {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () {
        setState(() {
          isSearching = true;
        });
      },
    );
  }

  void onItemTap(CompanyModel model) {
    setState(() {
      if (selectedCompany != null && selectedCompany.id == model.id) {
        selectedCompany = null;
      } else {
        selectedCompany = model;
      }
    });
  }
}

class CompanySelectList extends StatelessWidget {
  final List<CompanyModel> data;

  final CompanyModel selectedCompany;

  final ValueChanged<CompanyModel> onItemTap;

  const CompanySelectList(
      {Key key, this.data, this.onItemTap, this.selectedCompany})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        data.length > 0
            ? Column(
                children: data
                    .map((model) => CompanySelectItem(
                        model: model, 
                        selectedCompany: selectedCompany,
                        onPressed: () {
                          if (onItemTap != null) {
                            onItemTap(model);
                          }
                        }))
                    .toList())
            : NoDataInfoRow(),
        // _buildEnd()
      ],
    );
  }

  Widget _buildEnd() {
    return data.length > 0
        ? Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('已经到底了')],
            ),
          )
        : Container();
  }
}

class CompanySelectItem extends StatelessWidget {
  final CompanyModel model;

  final CompanyModel selectedCompany;

  /// 回调方法
  final VoidCallback onPressed;

  const CompanySelectItem({Key key, this.model, this.selectedCompany, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildMain()
          ],
        ),
        decoration: BoxDecoration(
            color: selectedCompany != null && selectedCompany.id == model.id
                ? Constants.THEME_COLOR_MAIN
                : Colors.white,
            borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () async {
        onPressed();
      },
    );
  }

  Widget _buildMain() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                '公司名称：${model.name}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '账号：${model.contactUid}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87
                  ),
                ),
              ),
              _buildTag()
            ],
          ),
        ),
      ]
    );
  }

  Widget _buildTag() {
    return model.approvalStatus == ArticleApprovalStatus.unapproved
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Color.fromRGBO(68, 138, 255, 1))),
            child: Center(
              child: Text(
                '未认证',
                style: TextStyle(
                    color: Color.fromRGBO(68, 138, 255, 1), fontSize: 10),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Constants.THEME_COLOR_MAIN)),
            child: Center(
              child: Text(
                '已认证',
                style:
                    TextStyle(color: Colors.green, fontSize: 10),
              ),
            ),
          );
  }
}
