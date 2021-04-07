import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/my/company/_shared/company_certificate_info.dart';
import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '_shared/factory_capacities.dart';
import '_shared/factory_info.dart';
import 'factory_item_v2.dart';

///工厂介绍页
class FactoryIntroductionPage extends StatefulWidget {
  final String uid;

  const FactoryIntroductionPage({Key key, this.uid}) : super(key: key);

  @override
  _FactoryIntroductionPageState createState() =>
      _FactoryIntroductionPageState();
}

class _FactoryIntroductionPageState extends State<FactoryIntroductionPage>
    with TickerProviderStateMixin {
  FactoryModel data;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<FactoryModel> snapshot) {
          if (data != null) {
            return Container(
              color: Colors.white,
              child: NestedScrollView(
                  headerSliverBuilder: _slverBuilder,
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      FactoryInfo(model: data),
                      CompanyCertificateInfo(code: data.uid),
                      FactoryCapacities(model: data)
                    ],
                  )),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _slverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverAppBar(
        title: Text('公司介绍'),
        pinned: true,
        elevation: 0.5,
        actions: [
          IconButton(
              icon: Icon(
                B2BIcons.share,
              ),
              onPressed: () => onShare())
        ],
        brightness: Brightness.dark,
      ),
      SliverList(
          delegate: SliverChildListDelegate([
        _InfoHeadRow(data),
        Divider(),
        _BriefRow(
          val: '公司简介：${data.intro ?? '暂无简介'}',
        ),
        Container(height: 10, color: Colors.grey[50])
      ])),
      SliverPersistentHeader(
          pinned: true,
          delegate: _AppBarDelegate(TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Constants.THEME_COLOR_ORANGE,
            labelStyle: TextStyle(
              fontSize: 18,
            ),
            unselectedLabelColor: Color(0xff646464),
            labelColor: Constants.THEME_COLOR_ORANGE,
            unselectedLabelStyle: TextStyle(
              fontSize: 18,
            ),
            tabs: [
              Tab(
                text: "公司资料",
              ),
              Tab(
                text: "公司认证",
              ),
              Tab(
                text: "空闲产能",
              ),
              // Tab(
              //   text: "需求",
              // ),
            ],
          ))),
    ];
  }

  ///获取工厂信息
  Future<FactoryModel> _getData() async {
    if (data == null) {
      FactoryModel result = await UserRepositoryImpl().getFactory(widget.uid);
      if (result != null) {
        data = result;
      }
    }
    return data;
  }

  ///分享
  void onShare() {
    // String description = "";
    // int i = 0;

    // data.adeptAtCategories.forEach((v) {
    //   if (i < 4) {
    //     description = "${description} ${v.name}";
    //     i++;
    //   }
    // });

    String description = data.adeptAtCategories.map((e) => e.name).join(' ');

    ShareDialog.showShareDialog(context,
        title: '${data.name}',
        description: description != null ? '$description ...' : '',
        imageUrl: data.profilePicture == null
            ? '${GlobalConfigs.LOGO_URL}'
            : '${data.profilePicture.previewUrl()}',
        url: Apis.shareFactory(widget.uid));
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  _AppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
      // color: overlapsContent ? Colors.white : Color.fromRGBO(245, 245, 245, 1),
      color: Colors.white,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

///头部
class _InfoHeadRow extends StatelessWidget {
  final FactoryModel data;

  const _InfoHeadRow(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          ImageFactory.buildDefaultAvatar(data.profilePicture),
          Expanded(
              child: Container(
            height: 80,
            margin: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      '${data.name}',
                      style: TextStyle(fontSize: 20),
                    ))
                  ],
                ),
                Row(
                  children: [
                    AuthTag(
                      model: data,
                    ),
                    ...data.labels
                        .map((e) => Container(
                              padding: EdgeInsets.fromLTRB(2, 1, 2, 2),
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 0.5),
                                  borderRadius: BorderRadius.circular(2)),
                              child: Text(
                                '${e.name}',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.green),
                              ),
                            ))
                        .toList()
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

///简介
class _BriefRow extends StatelessWidget {
  final String val;

  const _BriefRow({Key key, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            val ?? '',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ))
        ],
      ),
    );
  }
}
