
import 'package:b2b_commerce/src/my/contract/webview_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractSealPage extends StatefulWidget {
  List<SealModel> sealList;
  ContractModel model;
  bool isSelect;

  ContractSealPage({this.model, this.sealList,this.isSelect = true,});
  _ContractSealPageState createState() => _ContractSealPageState();
}

class _ContractSealPageState extends State<ContractSealPage>{
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('印章列表'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        child:GridView.builder(
          itemCount: widget.sealList.length,
          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
              crossAxisCount: 2,
              //纵轴间距
              mainAxisSpacing: 10.0,
              //横轴间距
              crossAxisSpacing: 0.0,
              //子组件宽高长度比例
              childAspectRatio: 0.99),

              itemBuilder: (BuildContext context, int index) =>
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: _buildItems(
                        context, widget.sealList[index]),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context, SealModel model) {
    return GestureDetector(
      onTap: () {
        if(widget.isSelect){
          flowContract(widget.model?.code,model);
        }

      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: _buildItemImage(context,model),flex: 5,),
            Expanded(child: _buildItemTitle(context,model),flex: 1,),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(BuildContext context,SealModel model){
    return Container(
        width: 200,
        height: 400,
        child: CachedNetworkImage(
            width: 200,
            height: 400,
            imageUrl: '${model.media.actualUrl}',
            fit: BoxFit.fill,
            imageBuilder: (context, imageProvider) => Container(
              width: 200,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            placeholder: (context, url) => SpinKitRing(
              color: Colors.black,
              lineWidth: 1,
              size: 20,
            ),
            errorWidget: (context, url, error) => SpinKitRing(
              color: Colors.black,
              lineWidth: 1,
              size: 20,
            )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ));
  }

  Widget _buildItemTitle(BuildContext context,SealModel model){
    return Container(
      height: 35,
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      alignment: Alignment.centerLeft,
      child: Text(
        '${model.name}',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  flowContract(String code, SealModel sealModel){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            ContractRepository().flowContract(code, sealModel.code),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if(certification.data !=  null){
          Navigator.push(
            context,MaterialPageRoute(builder: (context) => WebView111Page(urlString:certification.data)),
          );
        }else{
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: certification.msg,
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                );
              });
        }
      }else{
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '签署失败',
                callbackResult: false,
                confirmAction: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              );
            });
      }
    });
  }

}