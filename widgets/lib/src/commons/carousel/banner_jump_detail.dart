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
          imageUrl: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=270792303,1544523664&fm=26&gp=0.jpg",
          fit: BoxFit.cover,
          placeholder: (context, url) =>  SpinKitRing(
            color: Colors.black12,
            size: 30.0,
            lineWidth: 2,
          ),
          errorWidget: (context, url, error) => SpinKitRing(
            color: Colors.black12,
            size: 30.0,
            lineWidth: 2,
          )
      ),
    );
  }

  Widget buildCenterPictures(BuildContext context){
    return Container(
      height: 600,
      child: CachedNetworkImage(
          imageUrl: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=270792303,1544523664&fm=26&gp=0.jpg",
          fit: BoxFit.cover,
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
        imageUrl: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=270792303,1544523664&fm=26&gp=0.jpg",
        fit: BoxFit.cover,
        placeholder: (context, url) =>  SpinKitRing(
          color: Colors.black12,
          size: 30.0,
          lineWidth: 2,
        ),
        errorWidget: (context, url, error) => SpinKitRing(
          color: Colors.black12,
          size: 30.0,
          lineWidth: 2,
        )
      ),
    );
  }

}