import 'package:b2b_commerce/src/my/contract/webview_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractTempPage extends StatefulWidget {
  List<ContractTemplateModel> list;
  String title;
  ContractTempPage({this.list,this.title});
  _ContractTempPageState createState() => _ContractTempPageState();
}

class _ContractTempPageState extends State<ContractTempPage>{
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('${widget.title}'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child:GridView.builder(
          itemCount: widget.list == null? 0 : widget.list.length,
          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
              crossAxisCount: 2,
              //纵轴间距
              mainAxisSpacing: 10.0,
              //横轴间距
              crossAxisSpacing: 0.0,
              //子组件宽高长度比例
              childAspectRatio: 0.95),

              itemBuilder: (BuildContext context, int index) =>
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: _buildItems(
                        context, widget.list[index]),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context, ContractTemplateModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(model);
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

  Widget _buildItemImage(BuildContext context,ContractTemplateModel model){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
        child: Image.asset(
          'temp/word.png',
          package: 'assets',
          width: 140,
          height: 140,
          fit: BoxFit.fill,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ));
  }

  Widget _buildItemTitle(BuildContext context,ContractTemplateModel model){
    return Container(
      height: 35,
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      alignment: Alignment.centerLeft,
      child: Center(
        child: Text(
          '${model.title == null? '':model.title}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

}