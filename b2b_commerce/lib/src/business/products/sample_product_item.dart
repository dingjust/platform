import 'package:b2b_commerce/src/business/products/sample_product_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class SampleProductItem extends StatelessWidget {
  SampleProductModel item;
  bool isDetail;
  bool isHistoryCreate;

  SampleProductItem({this.item,this.isDetail = false,this.isHistoryCreate = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (isHistoryCreate) {
          Navigator.pop(context, item);
          return;
        }
        if(isDetail) ProductRepositoryImpl().getSample(item.code).then((sample){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductDetailPage(item: item,)));
        });
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(bottom: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: item.pictures.length > 0
                        ? NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${item.pictures[0].url}')
                        : AssetImage(
                            'temp/picture.png',
                            package: "assets",
                          ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item?.name,style: TextStyle(fontSize: 15),),
                    Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '货号：' + item?.code,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
