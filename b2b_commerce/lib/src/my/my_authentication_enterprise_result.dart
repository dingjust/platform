import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

class MyAuthenticationEnterpriseResult extends StatefulWidget{

  @override
  _MyAuthenticationEnterpriseResultState createState() => _MyAuthenticationEnterpriseResultState();
}

class _MyAuthenticationEnterpriseResultState extends State<MyAuthenticationEnterpriseResult>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('企业认证'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              _buildEnterpriseName(),
              _buildEnterpriseIdCard(),
              _buildName(),
              _buildIdCard(),
              _buildCertificates(),
            ],
          ),
        )
    );
  }

  Widget _buildEnterpriseName(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: ListTile(
        title: Text(
          '企业名称',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          'ray',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEnterpriseIdCard(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: ListTile(
        title: Text(
          '工商注册号或统一社会信用代码',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          '4186659784125542',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildName(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: ListTile(
        title: Text(
          '法定代表人',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          'ray',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildIdCard(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: ListTile(
        title: Text(
          '法定代表人证件',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          '4186659784125542',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCertificates(){
   return GestureDetector(
     onTap: (){
       onPreview(context, 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564572398419&di=5f454cdb224a745763f902c3b2c7ece7&imgtype=0&src=http%3A%2F%2Fimg3.ph.126.net%2FUCMw7q9k63MQ5gGkZZeDBQ%3D%3D%2F2564518512827789673.jpg');
     },
     child: Container(
       margin: EdgeInsets.symmetric(vertical: 20),
          child: CachedNetworkImage(
              imageUrl: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564572398419&di=5f454cdb224a745763f902c3b2c7ece7&imgtype=0&src=http%3A%2F%2Fimg3.ph.126.net%2FUCMw7q9k63MQ5gGkZZeDBQ%3D%3D%2F2564518512827789673.jpg',
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    width: MediaQuery.of(context).size.width-100,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              placeholder: (context, url) =>
                  SpinKitRing(
                    color: Colors.black12,
                    lineWidth: 2,
                    size: 30.0,
                  ),
              errorWidget: (context, url, error) =>
                  SpinKitRing(
                    color: Colors.black12,
                    lineWidth: 2,
                    size: 30,
                  )),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          )),
   );
  }


  //图片预览
  void onPreview(BuildContext context, String url) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          child: Container(
              child: PhotoView(
                imageProvider: NetworkImage(url),
              )),
          onTap: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

}