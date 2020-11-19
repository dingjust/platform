import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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

  CompanyModel selectedCompany;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  Widget _buildSearchButton() {
    return IconButton(
        icon: const Icon(B2BIcons.search, size: 20),
        onPressed: () {
          setState(() {
            isSearching = true;
          });
        });
  }

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Consumer<CompanyState>(
              builder: (context, CompanyState state, _) => SearchAppbarTitle(
                controller: controller,
                focusNode: focusNode,
                onSearch: () {
                  state.setKeyword(controller.text);
                  if (controller.text == '') {
                    setState(() {
                      isSearching = false;
                    });
                  }
                },
                onChange: (v) {
                  state.setKeyword(controller.text);
                },
              ),
            ),
          )
        : AppBarFactory.buildDefaultAppBar(
            '$appBarTitle',
            actions: <Widget>[_buildSearchButton()],
          );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CompanyState>(
      create: (context) => CompanyState(),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: Consumer<CompanyState>(
          builder: (context, CompanyState state, _) => Container(
            child: _buildBody(state),
          ),
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }

  Widget _buildBody(CompanyState state) {
    if (state.getKeyword == '') {
      return _buildTips('输入查询的公司名称或账号');
    } else if (state.getEntry().totalElements > -1) {
      return CompanySelectList(
        state: state,
        onItemTap: onItemTap,
        selectedCompany: selectedCompany,
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
              },
              child: Text(
                '确定',
                style: TextStyle(fontSize: 18),
              ),
            )),
          ],
        ));
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
  final CompanyState state;

  final CompanyModel selectedCompany;

  final ValueChanged<CompanyModel> onItemTap;

  ScrollController _scrollController;

  CompanySelectList({
    Key key,
    this.onItemTap,
    this.selectedCompany,
    this.state,
  }) : super(key: key) {
    this._scrollController = ScrollController();
    // 监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        state.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            state.companies().isNotEmpty
                ? Column(
                    children: state
                        .companies()
                        .map(
                          (model) => CompanySelectItem(
                            model: model,
                            selectedCompany: selectedCompany,
                            onPressed: () {
                              if (onItemTap != null) {
                                onItemTap(model);
                              }
                            },
                          ),
                        )
                        .toList(),
                  )
                : NoDataInfoRow(),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
              opacity: state.loadingMore ? 1.0 : 0,
            ),
            _buildEnd()
          ],
        ),
        onRefresh: () async {
          state.clear();
        },
      ),
    );
  }

  Widget _buildEnd() {
    return state.getEntry().currentPage + 1 == state.getEntry().totalPages
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

  const CompanySelectItem(
      {Key key, this.model, this.selectedCompany, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_buildMain()],
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
                    fontWeight: FontWeight.w500),
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
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              _buildTag()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag() {
    return model.approvalStatus == ArticleApprovalStatus.unapproved
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Color.fromRGBO(68, 138, 255, 1),
              ),
            ),
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
                style: TextStyle(color: Colors.green, fontSize: 10),
              ),
            ),
          );
  }
}
