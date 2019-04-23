import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';


class BannerJumpDetailPage extends StatefulWidget{

  @override
  _BannerJumpDetailPage createState() => _BannerJumpDetailPage();
}

class _BannerJumpDetailPage extends State<BannerJumpDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            buildHeadPictures(context),
            buildCenterPictures(context),
            buildBottomPictures(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeadPictures(BuildContext context){
    return Container(
      height: 600,
      child: CachedNetworkImage(
          imageUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556530085&di=d23b57d9f5abf60b3544f27199943803&imgtype=jpg&er=1&src=http%3A%2F%2Fimg001.hc360.cn%2Fm7%2FM01%2F5A%2F4F%2FwKhQpFWjbZCEYEkpAAAAAATIxUw568.jpg",
          fit: BoxFit.fill,
          placeholder: (context, url) =>  SpinKitRing(
            color: Colors.white,
            size: 50.0,
          ),
          errorWidget: (context, url, error) => SpinKitRing(
            color: Color(0xFF24292E),
            size: 50,
          )
      ),
    );
  }

  Widget buildCenterPictures(BuildContext context){
    return Container(
      height: 600,
      child: CachedNetworkImage(
          imageUrl: "https://img.alicdn.com/imgextra/i2/116883537/O1CN01PEI4Zv1bzzNviK22y_!!116883537.jpg",
          fit: BoxFit.fill,
          placeholder: (context, url) =>  SpinKitRing(
            color: Colors.black12,
            lineWidth: 2,
            size: 30,
          ),
          errorWidget: (context, url, error) => SpinKitRing(
            color: Colors.black12,
            lineWidth: 2,
            size: 30,
          )
      ),
    );
  }

  Widget buildBottomPictures(BuildContext context){
    return Container(
      height: 600,
      child: CachedNetworkImage(
        imageUrl: "https://img.alicdn.com/imgextra/i2/116883537/O1CN01PEI4Zv1bzzNviK22y_!!116883537.jpg",
        fit: BoxFit.fill,
        placeholder: (context, url) =>  SpinKitRing(
          color: Colors.white,
          size: 50.0,
        ),
        errorWidget: (context, url, error) => SpinKitRing(
            color: Color(0xFF24292E),
          size: 50,
        )
      ),
    );
  }

}