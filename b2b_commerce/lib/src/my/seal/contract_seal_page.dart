import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'contract_seal_form.dart';

///印章列表
class ContractSealPage extends StatefulWidget {
  ///是否用于选择
  final bool isSelect;

  ///选择后调用函数，为null则返回选择印章数据
  final ValueChanged<SealModel> onSelect;

  ContractSealPage({this.isSelect = true, this.onSelect});

  _ContractSealPageState createState() => _ContractSealPageState();
}

class _ContractSealPageState extends State<ContractSealPage> {
  ///认证状态
  CertificationState certificationState;
  ScrollController scrollController = ScrollController();
  List<SealModel> sealList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SealModel>>(
        future: _getData(),
        initialData: null,
        builder:
            (BuildContext context, AsyncSnapshot<List<SealModel>> snapshot) {
          if (sealList == null) {
            return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 0.5,
                title: Text('印章列表'),
                centerTitle: true,
              ),
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: GridView.builder(
                  itemCount: sealList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 2,
                      //纵轴间距
                      mainAxisSpacing: 10.0,
                      //横轴间距
                      crossAxisSpacing: 0.0,
                      //子组件宽高长度比例
                      childAspectRatio: 0.99),
                  itemBuilder: (BuildContext context, int index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: _buildItems(sealList[index]),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              floatingActionButton: _buildFAB(),
            );
          }
        });
  }

  Widget _buildItems(SealModel model) {
    return GestureDetector(
      onTap: () {
        if (widget.isSelect) {
          if (widget.onSelect != null) {
            widget.onSelect.call(model);
          } else {
            Navigator.of(context).pop(model);
          }
        }
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildItemImage(model),
              flex: 5,
            ),
            Expanded(
              child: _buildItemTitle(model),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(SealModel model) {
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

  Widget _buildItemTitle(SealModel model) {
    return Container(
      height: 35,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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

  Widget _buildFAB() {
    SealType sealType;
    if (certificationState != null) {
      //公章类型
      if (certificationState.data.companyState == AuthenticationState.SUCCESS) {
        sealType = SealType.OFFICAL;
      } else if (certificationState.data.personalState ==
          AuthenticationState.SUCCESS) {
        sealType = SealType.PERSONAL;
      }
    }

    if (sealType == null) {
      return Container();
    }

    return FloatingActionButton(
      onPressed: () {
        //表单
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ContractSealFormPage(
                      type: sealType,
                    )))
            .then((value) {
          if (value) {
            setState(() {
              sealList = null;
            });
          }
        });
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Future<List<SealModel>> _getData() async {
    if (sealList == null) {
      List<SealModel> data = await ContractRepository()
          .getSealList({'type': ''}, {'page': '0', 'size': '100'});
      sealList = data;
    }

    //获取认证状态信息
    if (certificationState == null) {
      CertificationState data =
          await ContractRepository().getAuthenticationState();
      certificationState = data;
    }
    return sealList;
  }
}
