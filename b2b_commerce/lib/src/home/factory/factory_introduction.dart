import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/orders/requirement/helper/requirement_helper.dart';
import 'package:b2b_commerce/src/my/company/_shared/company_certificate_info.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_base_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import '_shared/factory_capacities.dart';
import '_shared/factory_info.dart';
import '_shared/factory_widgets.dart';
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
    if (UserBLoC.instance.currentUser.companyCode != widget.uid) {
      UmengPlugin.onEvent('factory_detail', properties: {'uid': widget.uid});
    }
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<FactoryModel> snapshot) {
          if (data != null) {
            return Scaffold(
                body: Container(
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
                ),
                bottomNavigationBar: _bottom());
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
              onPressed: () => onShare()),
          UserBLoC.instance.currentUser.companyCode == data.uid
              ? TextButton(onPressed: onEdit, child: Text('编辑'))
              : Container()
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
                text: data.approvalType == 'PERSONAL' ? "个人认证" : '公司认证',
              ),
              Tab(
                text: "空闲产能",
              ),
            ],
          ))),
    ];
  }

  Widget _bottom() {
    return Offstage(
      offstage: UserBLoC.instance.currentUser.companyCode == data.uid,
      child: Container(
        height: 65,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
                child: FactoryBottomBtn(
              color: Colors.green,
              label: '联系对方',
              info: '电话沟通协商',
              onTap: _onContact,
            )),
            Expanded(
                child: FactoryBottomBtn(
              color: Colors.blueAccent,
              label: '发布需求',
              info: '邀请对方报价',
              onTap: () {
                RequirementHelper.publishToFactory(
                    context: context, factory: data);
              },
            ))
          ],
        ),
      ),
    );
  }

  ///联系
  void _onContact() {
    String tel = data.contactPhone;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
                    leading: Icon(Icons.message),
                    title: Text('发送短信'),
                    onTap: () async {
                      var url = 'sms:' + tel;
                      await launch(url);
                    },
                  ),
          ],
        );
      },
    );
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
    String description = data.adeptAtCategories.map((e) => e.name).join(' ');
    ShareDialog.showShareDialog(context,
        title: '${data.name}',
        description: description != null ? '$description ...' : '',
        imageUrl: data.profilePicture == null
            ? '${GlobalConfigs.LOGO_URL}'
            : '${data.profilePicture.previewUrl()}',
        url: Apis.shareFactory(widget.uid));
  }

  void onEdit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyFactoryBaseFormPage(
                  data,
                ))).then((v) {
      if (v == true) {
        setState(() {
          data = null;
        });
      }
    });
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
          _buildProfile(),
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

  Widget _buildProfile() {
    if (data?.profilePicture == null) {
      return Container(
        width: 80,
        height: 80,
      );
    } else {
      const processUrl = 'image_process=resize,w_80/crop,mid,w_80,h_80';
      return Container(
        width: 80,
        height: 80,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: '${data.profilePicture.imageProcessUrl(processUrl)}',
            fit: BoxFit.fill,
            placeholder: (context, url) =>
                SpinKitRing(
                  color: Colors.grey[300],
                  lineWidth: 2,
                  size: 30,
                ),
            errorWidget: (context, url, error) =>
                SpinKitRing(
                  color: Colors.grey[300],
                  lineWidth: 2,
                  size: 30,
                ),
          ),
        ),
      );
    }
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
