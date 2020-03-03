import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail_by_factory.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
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
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildRow1(),
                  _buildRow2(context),
                  _buildRow3()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: _buildTag(order.labels ?? []),
        ),
        Text(
          '${order.details.productName ?? order.details.category?.name}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, color: Colors.black),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  '${order.details.category?.name}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  '${order.details.expectedMachiningQuantity ?? 0}件',
                  style: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(255, 149, 22, 1)),
                ),
              ),
              // Text(
              //   '${DateExpressUtil.express(order.modifiedTime)}',
              //   style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
              // ),
            ],
          ),
        ),
        // order.details.maxExpectedPrice != null
        //     ? RichText(
        //         text: TextSpan(
        //             text: '￥',
        //             style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1)),
        //             children: <TextSpan>[
        //               TextSpan(
        //                   text: '${order.details.maxExpectedPrice}',
        //                   style: TextStyle(fontSize: 18))
        //             ]),
        //       )
        //     : Container(),

        GestureDetector(
          onTap: () async {
            QuoteModel newQuote =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RequirementQuoteOrderForm(
                          model: order,
                          quoteModel: QuoteModel(attachments: []),
                        )));

            if (newQuote != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuoteOrderDetailPage(
                        newQuote.code,
                      )));
            }
          },
          child: Container(
            height: 25,
            width: 65,
            margin: EdgeInsets.only(left: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(255, 214, 12, 1)),
            child: Center(
              child: Text('去报价'),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRow3() {
    return Row(
      children: <Widget>[
        Logo(
          order: order,
        ),
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
                order.belongTo.approvalStatus == ArticleApprovalStatus.approved
                    ? Tag(
                        label: '  已认证  ',
                        color: Color.fromRGBO(255, 133, 148, 1),
                        backgroundColor: Color.fromRGBO(255, 243, 243, 1),
                      )
                    : Container(),
                Text(
                  '${DateExpressUtil.express(order.modifiedTime)}',
                  style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                ),
              ],
            )),
        // Container(
        //   margin: EdgeInsets.only(left: 10),
        //   padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
        //   decoration: BoxDecoration(
        //       color: Color.fromRGBO(255, 243, 243, 1),
        //       borderRadius: BorderRadius.circular(10)),
        //   child: Text(
        //     "已认证",
        //     style: TextStyle(
        //         fontSize: 15, color: Color.fromRGBO(255, 133, 148, 1)),
        //   ),
        // )
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
