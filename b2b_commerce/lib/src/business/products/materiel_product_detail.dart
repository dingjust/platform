import 'package:b2b_commerce/src/my/my_brand.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

///面辅料详情页
class MaterielProductDetail extends StatefulWidget {
  final int id;

  const MaterielProductDetail(
    this.id, {
    Key key,
  }) : super(key: key);

  @override
  _MaterielProductDetailState createState() => _MaterielProductDetailState();
}

class _MaterielProductDetailState extends State<MaterielProductDetail> {
  MaterielProductModel data;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context,
            AsyncSnapshot<MaterielProductModel> snapshot) {
          if (data != null) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: _buildBody(),
              ),
              bottomSheet: _BottomSheet(
                model: snapshot.data,
              ),
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

  Widget _buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          elevation: 0,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0),
          actionsIconTheme: IconThemeData(color: Colors.grey[300]),
          brightness: Brightness.dark,
          leading: IconButton(
              icon: Icon(
                B2BIcons.left_fill,
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ProductCarousel(data.images, 400),
              ],
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          _buildPriceRow(),
          _buildNameRow(),
          _buildDescribeRow(),
          Divider(),
          _buildInfo(),
          Divider(),
          _buildDetailImage()
        ])),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '￥${data.price ?? 0}/米',
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }

  Widget _buildNameRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '${data.name}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
          ))
        ],
      ),
    );
  }

  Widget _buildDescribeRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '${data.describe}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.clip,
          ))
        ],
      ),
    );
  }

  Widget _buildInfo() {
    var infoMap = {
      '编号': data.code,
      '货号': data.skuID ?? '',
      '品类': data.category.name ?? '',
      '成分': data.basis ?? '',
      '克重': '${data.gramWeight ?? ''}g/㎡',
      '有效幅宽': '${data.width ?? ''}cm',
      '用途': data.uses.join('、')
    };
    List<Widget> infoRows = [];
    infoMap.forEach((key, value) {
      infoRows.add(_InfoRow(
        title: '$key',
        val: '$value',
      ));
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '产品参数',
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Divider(),
          ...infoRows
        ],
      ),
    );
  }

  Widget _buildDetailImage() {
    return Container(
        margin: EdgeInsets.only(bottom: 60),
        child: Column(
          children: [
            ...data.details
                .map((e) => Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          child: CachedNetworkImage(
                              imageUrl: '${e.normalUrl()}',
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => SpinKitRing(
                                    color: Colors.black12,
                                    lineWidth: 2,
                                    size: 30,
                                  ),
                              errorWidget: (context, url, error) => SpinKitRing(
                                    color: Colors.black12,
                                    lineWidth: 2,
                                    size: 30,
                                  )),
                        ))
                      ],
                    ))
                .toList()
          ],
        ));
  }

  ///获取产品信息
  Future<MaterielProductModel> _getData() async {
    if (data == null) {
      MaterielProductModel result =
          await MaterielProductRepository.get(widget.id);
      if (result != null) {
        data = result;
      }
    }
    return data;
  }
}

class _BottomSheet extends StatelessWidget {
  final MaterielProductModel model;

  const _BottomSheet({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                child: InkWell(
                  onTap: () => onDetail(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.store,
                          color: Colors.black54,
                          size: 35,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  '${model.belongTo.name}',
                                  style: TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ))
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${model.belongTo.contactAddress.city.name ?? ''}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      height: double.infinity,
                      child: Builder(
                        builder: (BuildContext buttonContext) => FlatButton(
                          color: Color.fromRGBO(254, 227, 93, 1),
                          onPressed: onTel,
                          disabledColor: Colors.grey[300],
                          child: Text(
                            '立即联系',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onDetail(BuildContext context) {
    // 品牌详情
    if (model.belongTo.type == CompanyType.BRAND) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyBrandPage(
                    model.belongTo.uid,
                    isDetail: true,
                  )));
    }
    // 工厂详情
    if (model.belongTo.type == CompanyType.FACTORY) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyFactoryPage(
            factoryUid: model.belongTo.uid,
            isFactoryDetail: true,
          ),
        ),
      );
    }
  }

  //拨打联系人
  void onTel() async {
    var url = 'tel:' + model.belongTo.contactPhone;
    await launch(url);
  }
}

class _InfoRow extends StatelessWidget {
  final String title;

  final String val;

  const _InfoRow({Key key, this.title, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              '$title',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              '$val',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
