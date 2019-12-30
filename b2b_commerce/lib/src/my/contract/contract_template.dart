
import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const statuses = <EnumModel>[
  EnumModel('CGDD', '采购订单'),
  EnumModel('KJXY', '框架协议'),
  EnumModel('WTSCHT', '委托合同'),
  EnumModel('BCXY', '补充协议'),
];

class MyContractTemplatePage extends StatefulWidget {
  _MyContractTemplatePageState createState() => _MyContractTemplatePageState();
}

class _MyContractTemplatePageState extends State<MyContractTemplatePage>  with SingleTickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  final GlobalKey _globalKey = GlobalKey<_MyContractTemplatePageState>();
  var controller;

  @override
  void initState() {
    controller = TabController(
      length: statuses.length,
      vsync: this, //动画效果的异步处理，默认格式
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<MyContractTemplateBLoC>(
      key: _globalKey,
      bloc: MyContractTemplateBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '合同模板',
        ),
        body: Scaffold(
          appBar: TabBar(
            isScrollable: true,
            controller: controller,
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            tabs: statuses.map((tab) {
              return Tab(text: tab.name);
            }).toList(),),
          body: TabBarView(
            controller: controller,
            children: statuses.map((status) =>
                MyContractTemplateListPage(status: status)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

  class MyContractTemplateListPage extends StatefulWidget{
    final String keyword;
    final EnumModel status;

    MyContractTemplateListPage({this.keyword,this.status});

    _MyContractTemplateListPageState createState() => _MyContractTemplateListPageState();
  }

  class _MyContractTemplateListPageState extends State<MyContractTemplateListPage> with AutomaticKeepAliveClientMixin {
    ScrollController _scrollController = ScrollController();

    @override
    void initState() {
      super.initState();

      var bloc = BLoCProvider.of<MyContractTemplateBLoC>(context);

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          bloc.loadingStart();
          bloc.loadingMore(status: widget.status.code);
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      var bloc = BLoCProvider.of<MyContractTemplateBLoC>(context);
      return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.refreshData(widget.status.code,'');
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: StreamBuilder<TemplateData>(
                  stream: widget.status == null
                      ? bloc.stream
                      : bloc.stream.where((data) =>
                  data.status == widget.status.code),
                  // initialData: null,
                  builder:
                      (BuildContext context, AsyncSnapshot<TemplateData> snapshot) {
                    if (snapshot.data == null) {
                      bloc.getData(status: widget.status.code);

                      return ProgressIndicatorFactory
                          .buildPaddedProgressIndicator();
                    }
                    if (snapshot.data.data.length <= 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 200),
                            child: Image.asset(
                              'temp/logo2.png',
                              package: 'assets',
                              width: 80,
                              height: 80,
                            ),
                          ),
                          Container(
                              child: Text(
                                AppBLoC.instance.getConnectivityResult == ConnectivityResult.none
                                    ? '网络链接不可用请重试'
                                    : '没有相关数据',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )),
                        ],
                      );
                    }
                    if (snapshot.hasData) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                        child:GridView.builder(
//                          shrinkWrap: true,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.data.length,
                          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //横轴元素个数
                              crossAxisCount: 2,
                              //纵轴间距
                              mainAxisSpacing: 10.0,
                              //横轴间距
                              crossAxisSpacing: 0.0,
                              //子组件宽高长度比例
                              childAspectRatio: 0.9),

                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        child: Image.asset(
                                          'temp/word.png',
                                          package: 'assets',
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          '${snapshot.data.data[index].title}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<bool>(
                  stream: bloc.bottomStream,
                  initialData: false,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return ScrolledToEndTips(
                      hasContent: snapshot.data,
                      scrollController: _scrollController,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<bool>(
                  stream: bloc.loadingStream,
                  initialData: false,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return ProgressIndicatorFactory
                        .buildPaddedOpacityProgressIndicator(
                      opacity: snapshot.data ? 1.0 : 0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

  @override
  bool get wantKeepAlive => false;

  }
