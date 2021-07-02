import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/distance_text.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/orientations_text.dart';
import 'package:b2b_commerce/src/my/company/form/my_brand_base_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_base_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class RequirementListItem extends StatefulWidget {
  final RequirementOrderModel model;

  const RequirementListItem({Key key, this.model}) : super(key: key);

  @override
  _RequirementListItemState createState() => _RequirementListItemState();
}

class _RequirementListItemState extends State<RequirementListItem> {
  ///文字最大行数
  int maxLines = 3;

  ///是否限制最大行数
  bool isLinesLimit = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<CertificationStatusHelper>(context).oncheckProfile(
            context: context, onJump: () => jumpToDetailPage(context));
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(borderRadius)
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              // _buildImage(context),
              _buildTitleRow(),
              _buildContent(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${widget.model.details.productName ?? ''}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              '${widget.model.details.expectedMachiningQuantity}件',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Text(
                            '${widget.model.details.category.name}',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    DistanceText(
                      val: widget.model.distance,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: widget.model.details.productiveDistricts != null
                          ? DistrictsOrientationsText(
                              districts:
                                  widget.model.details.productiveDistricts ??
                                      [],
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(97, 95, 95, 1),
                                  fontSize: 10))
                          : OrientationsText(
                              regions:
                                  widget.model.details.productiveOrientations ??
                                      [],
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(97, 95, 95, 1),
                                  fontSize: 10)),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${DateExpress2Util.express(widget.model.creationTime)}',
                          style: TextStyle(
                              color: Color.fromRGBO(97, 95, 95, 1),
                              fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  // Widget _buildImage(BuildContext context) {
  //   if (model?.details?.pictures == null ||
  //       widget.model.details.pictures.isEmpty) {
  //     return Container();
  //   } else {
  //     const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';

  //     return ClipRRect(
  //       //剪裁为圆角矩形
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(borderRadius),
  //           topRight: Radius.circular(borderRadius)),
  //       child: CachedNetworkImage(
  //         imageUrl:
  //             '${widget.model.details.pictures.first.imageProcessUrl(processUrl)}',
  //         placeholder: (context, url) => SpinKitRing(
  //           color: Colors.grey[300],
  //           lineWidth: 2,
  //           size: 30,
  //         ),
  //         errorWidget: (context, url, error) => SpinKitRing(
  //           color: Colors.grey[300],
  //           lineWidth: 2,
  //           size: 30,
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget _buildTitleRow({
    TextStyle style =
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  }) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 5),
                    child: ImageFactory.buildProcessedAvatar(
                        widget.model.belongTo.profilePicture,
                        processurl: 'image_process=circle,200')),
                Expanded(
                    child: Text('${widget.model.belongTo.name ?? ''}',
                        style: style,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis))
              ],
            )),
            Text('找订单', style: style),
            Expanded(
                child: Text('十三行', textAlign: TextAlign.right, style: style))
          ],
        ));
  }

  Widget _buildContent({TextStyle style = const TextStyle(fontSize: 12)}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300], width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child:
                    Text('${widget.model.details.productName}', style: style))
          ],
        ),
        _buildText()
      ]),
    );
  }

  Widget _buildText({TextStyle style = const TextStyle(fontSize: 12)}) {
    if (widget.model.remarks == null) {
      return Container();
    }

    return LayoutBuilder(builder: (context, constrants) {
      final span = TextSpan(text: widget.model.remarks ?? '', style: style);
      final tp = TextPainter(
          text: span, maxLines: maxLines, textDirection: TextDirection.ltr)
        ..layout(maxWidth: constrants.maxWidth);
      if (tp.didExceedMaxLines) {
        return Column(
          children: [
            Text(
              '${widget.model.remarks ?? ''}',
              maxLines: isLinesLimit ? maxLines : null,
              style: style,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        isLinesLimit = !isLinesLimit;
                      });
                    },
                    child: Text(isLinesLimit ? '全文' : '收起'))
              ],
            )
          ],
        );
      } else {
        return Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  '${widget.model.remarks ?? ''}',
                  maxLines: maxLines,
                  style: style,
                ))
              ],
            ));
      }
    });
  }

  void jumpToDetailPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_REQUIREMENT,
        arguments: {'code': widget.model.code});
  }

  void jumpToCompanyIntroduction(BuildContext context) {
    UserBLoC bloc = UserBLoC.instance;
    // 品牌详情
    if (bloc.currentUser.type == UserType.BRAND) {
      UserRepositoryImpl().getBrand(bloc.currentUser.companyCode).then((brand) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBrandBaseFormPage(brand)));
      });
    }
    // 工厂详情
    if (bloc.currentUser.type == UserType.FACTORY) {
      UserRepositoryImpl()
          .getFactory(bloc.currentUser.companyCode)
          .then((factory) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyFactoryBaseFormPage(
              factory,
            ),
          ),
        );
      });
    }
  }

  String generateDistanceStr(double distance) {
    if (distance == null) {
      return '';
    }
    if (distance < 1000) {
      return '${distance}KM';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)}KM';
    }
  }
}
