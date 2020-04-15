import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail_by_factory.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/factory_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:widgets/widgets.dart';

class RequirementPoolOrderItem extends StatelessWidget {
  const RequirementPoolOrderItem({Key key, this.order, this.pageContext})
      : super(key: key);

  final RequirementOrderModel order;

  final BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (order.code != null) {
          ///资料完善度校验
          Provider.of<CertificationStatusHelper>(context).oncheckProfile(
              context: context,
              onJump: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        RequirementOrderDetailByFactoryPage(order.code)));
              });
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: <Widget>[_buildEntries(context)],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
      ),
    );
  }

  Widget _buildEntries(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildImage(),
                        Expanded(
                            child: Container(
                              height: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _buildRow1(),
                                  _buildRow2(context),
                                ],
                              ),
                            ))
                      ],
                    ),
                    _buildRow3()
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 80,
      width: 80,
      margin: EdgeInsets.only(right: 10),
      child: ImageFactory.buildThumbnailImageForList(order.details.pictures,
          fit: BoxFit.cover),
    );
  }

  Widget _buildRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Row(
        //   children: _buildTag(order.labels ?? []),
        // ),
        Text(
          '${order.details.productName ?? order.details.category?.name}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      '${order.details.expectedMachiningQuantity ?? 0}件',
                      style: TextStyle(
                          fontSize: 15, color: Color.fromRGBO(255, 149, 22, 1)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      '${order.details.category?.name ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${DateExpressUtil.express(order.modifiedTime)}',
                style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow3() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    '${order.belongTo.name}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 10,
                ),
                Text(
                  order.belongTo.contactAddress != null
                      ? '${order.belongTo.contactAddress.city.name}${order
                      .belongTo.contactAddress.cityDistrict.name}'
                      : '',
                  style: TextStyle(color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
      ],
    );
  }

  List<Widget> _buildTag(List<LabelModel> labels) {
    List<Widget> tags = [];
    labels.where((label) => label.group == 'ORDER').forEach((label) {
      tags.add(Tag(
        label: '${label.name}',
        color: Colors.black,
        backgroundColor: Color.fromRGBO(255, 214, 12, 1),
      ));
    });
    return tags;
  }
}

class Logo extends StatelessWidget {
  final RequirementOrderModel order;

  const Logo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _logo;
    if (order.belongTo.profilePicture == null) {
      _logo = Container(
        width: 20,
        height: 20,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color.fromRGBO(243, 243, 243, 1)),
        child: Icon(
          B2BIcons.noPicture,
          color: Color.fromRGBO(200, 200, 200, 1),
          size: 10,
        ),
      );
    } else {
      _logo = Container(
        width: 20,
        height: 20,
        child: CachedNetworkImage(
            imageUrl: '${order.belongTo.profilePicture.previewUrl()}',
            fit: BoxFit.cover,
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
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      );
    }
    return _logo;
  }
}
