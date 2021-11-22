import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:widgets/widgets.dart';

class RequirementListItem extends StatelessWidget {
  final RequirementOrderModel model;

  final int maxLines;

  const RequirementListItem({Key key, this.model, this.maxLines = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDetail(context),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            children: <Widget>[
              _buildTitleRow(),
              _buildContent(context),
              _buildBottom()
            ],
          )),
    );
  }

  Widget _buildImages(BuildContext iContext) {
    var pictures = getPictures();

    if (pictures.length == 0) {
      return Container();
    } else {
      double ratio = MediaQuery.of(iContext).devicePixelRatio;

      List<Widget> imageWidgets = pictures
          .map((e) => Expanded(
                  child: GestureDetector(
                onTap: () => onPreview(e, iContext),
                child: Container(child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  double imageWidth = constraints.maxWidth;
                  double imageHeight =
                      getImageHeight(pictures.length, imageWidth);
                  String processUrl =
                      'image_process=resize,w_${imageWidth * ratio}/crop,mid,w_${imageWidth * ratio},h_${imageHeight * ratio}';
                  return CachedNetworkImage(
                    height: imageHeight,
                    imageUrl: '${e.imageProcessUrl(processUrl)}',
                    placeholder: (context, url) => SpinKitRing(
                      color: Colors.grey[300],
                      lineWidth: 2,
                      size: 30,
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.broken_image,
                      size: 30,
                      color: Colors.grey[300],
                    ),
                    fit: BoxFit.cover,
                  );
                })),
              )))
          .toList();

      List<Widget> widgets = [];

      for (int i = 0; i < imageWidgets.length; i++) {
        widgets.add(imageWidgets[i]);
        if (i != imageWidgets.length - 1) {
          widgets.add(Container(width: 10));
        }
      }

      return Container(
        margin: EdgeInsets.only(top: 8),
        child: Row(children: widgets),
      );
    }
  }

  Widget _buildTitleRow(
      {TextStyle style = const TextStyle(
          color: Color(0xFFAA6E15),
          fontSize: 14,
          fontWeight: FontWeight.w500)}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          children: [
            Container(
                width: 150,
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ImageFactory.buildProcessedAvatar(
                            model.belongTo.profilePicture,
                            processurl:
                                'image_process=resize,w_320/crop,mid,w_320,h_320,circle,320')),
                    Expanded(
                        child: Text('${model.belongTo.name ?? ''}',
                            style: style,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis))
                  ],
                )),
            Expanded(
              child: Text(
                '${RequirementOrderTypeLocalizedMap[model.orderType] ??
                    ''}${model.details.identityTypeStr != null
                    ? '·'
                    : ''}${model.details.identityTypeStr ?? ''}',
                style: style,
                textAlign: TextAlign.end,
              ),
            )
          ],
        ));
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 4),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: Text('${model.details.productName ?? ''}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff222222),
                        fontWeight: FontWeight.bold)))
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: _buildText(),
        ),
        _buildImages(context)
      ]),
    );
  }

  Widget _buildText(
      {TextStyle style = const TextStyle(
          fontSize: 13,
          color: Color(0xff666666),
          fontWeight: FontWeight.w500)}) {
    return LayoutBuilder(builder: (context, constrants) {
      final span = TextSpan(text: model.remarks ?? '', style: style);
      final tp = TextPainter(
          text: span, maxLines: maxLines, textDirection: TextDirection.ltr)
        ..layout(maxWidth: constrants.maxWidth);

      //超过行的情况
      if (tp.didExceedMaxLines) {
        //文字分两部分
        //单行字数
        int lineNum = tp.width ~/ tp.text.style.fontSize;

        var strs1 = span.text.substring(0, lineNum * (maxLines - 1));
        var strs2 = span.text.substring(lineNum * (maxLines - 1));

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$strs1',
                    style: style,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$strs2',
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '查看更多',
                  style: TextStyle(
                      color: Color(0xff1486fa), fontSize: style.fontSize),
                )
              ],
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
                child: Text(
                  '${model.remarks ?? ''}',
                  style: style,
                ))
          ],
        );
      }
    });
  }

  Widget _buildBottom({TextStyle style =
  const TextStyle(fontSize: 10, color: Color(0xff999999))}) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // (model.details.address != null && model.details.address != "")
          //     ? Expanded(
          //         child: Row(children: [
          //         Container(
          //           margin: EdgeInsets.only(right: 2),
          //           child: Icon(
          //             B2BIconsV2.location,
          //             size: 14,
          //             color: Color(0xff999999),
          //           ),
          //         ),
          //         Expanded(
          //             child: Text(
          //           '${model.details.cityStr ?? ''}·${model.details.districtStr ?? ''}',
          //           style: style,
          //           overflow: TextOverflow.ellipsis,
          //         ))
          //       ]))
          //     : Container(),
          Text(
            '${DateExpress2Util.express(model.creationTime)}',
            style: style,
          )
        ],
      ),
    );
  }

  void onDetail(BuildContext context) {
    Provider.of<CertificationStatusHelper>(context, listen: false)
        .oncheckProfile(
        context: context, onJump: () => jumpToDetailPage(context));
  }

  List<MediaModel> getPictures() {
    if (model?.details?.pictures == null || model.details.pictures.isEmpty) {
      return [];
    }

    if (model.details.pictures.length > 2) {
      return model.details.pictures.getRange(0, 3).toList();
    } else {
      return model.details.pictures;
    }
  }

  double getImageHeight(int length, double width) {
    switch (length) {
      case 1:
      //16:9
        return width * (9 / 16);
        break;
      case 2:
      //4:3
        return width * (3 / 4);
        break;
      case 3:
        return width;
        break;
      default:
        return width;
    }
  }

  void jumpToDetailPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_REQUIREMENT,
        arguments: {'code': model.code});
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

  //图片预览
  void onPreview(MediaModel media, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GalleryPhotoViewWrapper(
              galleryItems: model.details.pictures
                  .map((model) => GalleryItem(model: model))
                  .toList(),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: model.details.pictures.indexOf(media),
              scrollDirection: Axis.horizontal,
            ),
      ),
    );
  }
}
