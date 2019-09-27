import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:photo_view/photo_view.dart';
import 'package:services/services.dart';

class MyAuthenticationEnterpriseResult extends StatefulWidget{
  bool isCompany;
  MyAuthenticationEnterpriseResult({this.isCompany:false});

  @override
  _MyAuthenticationEnterpriseResultState createState() => _MyAuthenticationEnterpriseResultState();
}

class _MyAuthenticationEnterpriseResultState extends State<MyAuthenticationEnterpriseResult>{
  var _futureBuilderFuture;


  @override
  void initState() {
    _futureBuilderFuture = _getData();

    super.initState();
  }

  Future<CertificationInfo> _getData() async {
    // 查询明细
    CertificationInfo model = await ContractRepository().getAuthenticationInfoEnterprise();

    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.isCompany?'企业认证':'个体户认证'}'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: FutureBuilder<CertificationInfo>(
          builder: (BuildContext context,
              AsyncSnapshot<CertificationInfo> snapshot) {
            if (snapshot.data != null) {
              return Container(
                  child: widget.isCompany ? _buildEnterprise(snapshot.data.data)
                      :_buildIndividualBusiness(snapshot.data.data)
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }, initialData: null,
          future: _futureBuilderFuture,
        ),
        bottomNavigationBar: Container(
          color: Colors.white10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
            color: Colors.red,
            child: Text(
              '重新认证',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: (){
            },
          ),
        )
    );
  }

  Widget _buildIndividualBusiness(AuthenticationInfoModel model){
    return ListView(
      children: <Widget>[
        _buildInfo('公司名称', '${model.name}'),
        _buildInfo('社会信用代码', '${model.organization}'),
        _buildInfo('法定代表人', '${model.agent.name}'),
        _buildInfo('身份证号码', '${model.agent.idCardNum}'),
        _buildCertificates(),
      ],
    );
  }

  Widget _buildEnterprise(AuthenticationInfoModel model){
    return ListView(
      children: <Widget>[
        _buildInfo('企业名称', '${model.name}'),
        _buildInfo('社会信用代码', '${model.organization}'),
        _buildInfo('法定代表人', '${model.agent.name}'),
        _buildInfo('我的身份', '${model.agent!=null? '我是法人':'我是代理人'}'),
        _buildInfo('我的姓名', '${model.agent!=null?model.agent.name:model.legal.name}'),
        _buildInfo('身份证号码', '${model.agent!=null?model.agent.idCardNum:model.legal.idCardNum}'),
        _buildInfo('银行账号', '${model.bankCardNo}'),
        _buildInfo('开户银行', '${model.bankName}'),
        _buildInfo('开户支行', '${model.bankDetailName}'),
        _buildCertificates(),
      ],
    );
  }

  Widget _buildInfo(String left,String right){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                '${left}',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              '${right}',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
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