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
      onTap: onDetail,
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              _buildTitleRow(),
              _buildContent(),
              _buildBottom()
            ],
          )),
    );
  }

  Widget _buildImages() {
    var pictures = getPictures();

    if (pictures.length == 0) {
      return Container();
    } else {
      const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';

      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
            children: pictures
                .map((e) => Expanded(
                        child: GestureDetector(
                      onTap: () => onPreview(e),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: CachedNetworkImage(
                          height: getImageHeight(pictures.length),
                          imageUrl: '${e.imageProcessUrl(processUrl)}',
                          placeholder: (context, url) => SpinKitRing(
                            color: Colors.grey[300],
                            lineWidth: 2,
                            size: 30,
                          ),
                          errorWidget: (context, url, error) => SpinKitRing(
                            color: Colors.grey[300],
                            lineWidth: 2,
                            size: 30,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )))
                .toList()),
      );
    }
  }

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
                        processurl:
                            'image_process=resize,w_320/crop,mid,w_320,h_320,circle,320')),
                Expanded(
                    child: Text('${widget.model.belongTo.name ?? ''}',
                        style: style,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis))
              ],
            )),
            Text(
                '${RequirementOrderTypeLocalizedMap[widget.model.orderType] ?? ''}',
                style: style),
            Expanded(
                child: Text('${widget.model.details.identityTypeStr ?? ''}',
                    textAlign: TextAlign.right, style: style))
          ],
        ));
  }

  Widget _buildContent({TextStyle style = const TextStyle(fontSize: 12)}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300], width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: Text('${widget.model.details.productName ?? ''}',
                    style: style))
          ],
        ),
        _buildText(),
        _buildImages()
      ]),
    );
  }

  Widget _buildText({TextStyle style = const TextStyle(fontSize: 12)}) {
    return LayoutBuilder(builder: (context, constrants) {
      final span = TextSpan(text: widget.model.remarks ?? '', style: style);
      final tp = TextPainter(
          text: span, maxLines: maxLines, textDirection: TextDirection.ltr)
        ..layout(maxWidth: constrants.maxWidth);
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.model.remarks ?? ''}',
                  maxLines: isLinesLimit ? maxLines : null,
                  style: style,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              tp.didExceedMaxLines
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          isLinesLimit = !isLinesLimit;
                        });
                      },
                      child: Text(isLinesLimit ? '全文' : '收起'))
                  : TextButton(onPressed: onDetail, child: Text('全文'))
            ],
          )
        ],
      );
    });
  }

  Widget _buildBottom({TextStyle style = const TextStyle(fontSize: 12)}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          widget.model.details.address != null
              ? Expanded(
                  child: Row(children: [
                  Icon(Icons.location_on),
                  Expanded(
                      child: Text(
                    '${widget.model.details.address ?? ''}',
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ))
                ]))
              : Container(),
          Text(
            '${DateExpress2Util.express(widget.model.creationTime)}',
            style:
            TextStyle(color: Color.fromRGBO(97, 95, 95, 1), fontSize: 10),
          )
        ],
      ),
    );
  }

  void onDetail() {
    Provider.of<CertificationStatusHelper>(context, listen: false)
        .oncheckProfile(
        context: context, onJump: () => jumpToDetailPage(context));
  }

  List<MediaModel> getPictures() {
    if (widget.model?.details?.pictures == null ||
        widget.model.details.pictures.isEmpty) {
      return [];
    }

    if (widget.model.details.pictures.length > 2) {
      return widget.model.details.pictures.getRange(0, 3).toList();
    } else {
      return widget.model.details.pictures;
    }
  }

  double getImageHeight(int length) {
    switch (length) {
      case 1:
        return 150;
        break;
      case 2:
        return 120;
        break;
      case 3:
        return 100;
        break;
      default:
        return 100;
    }
  }

  void jumpToDetailPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_REQUIREMENT,
        arguments: {'code': widget.model.code});
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
  void onPreview(MediaModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GalleryPhotoViewWrapper(
              galleryItems: widget.model.details.pictures
                  .map((model) => GalleryItem(model: model))
                  .toList(),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: widget.model.details.pictures.indexOf(model),
              scrollDirection: Axis.horizontal,
            ),
      ),
    );
  }
}
