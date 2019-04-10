import 'package:b2b_commerce/src/business/products/sample_product_history_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SampleProductHistoryItem extends StatelessWidget {
  final SampleBorrowReturnHistoryModel item;
  final bool isSampleProductHistory;
  final String state;
  final String type;

  const SampleProductHistoryItem({Key key, this.item,this.isSampleProductHistory = false,this.state,this.type,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const Map<ReturnState, Color> _colorState = {
      ReturnState.NOT_RETURNED: Colors.red,
      ReturnState.RETURNED: Colors.blue,
    };

    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      elevation: 0,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductHistoryFormPage(item,onlyRead:true)));
        },
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Offstage(
                offstage: isSampleProductHistory,
                child: item.images != null && item.images.length > 0?
                      Image.network(
                        '${item.images[0].imageUrl}',
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        )
                        : Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(5),
                        color:
                        Color.fromRGBO(243, 243, 243, 1)),
                    child: Icon(
                        B2BIcons.noPicture,
                        color: Color.fromRGBO(200, 200, 200, 1),
                        size: 60
                    ),
                  ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '借方：${item.relatedParty ?? ''}',
                              style: TextStyle(fontSize: 15),
                              //overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                              ReturnStateLocalizedMap[item.state],
                              style: TextStyle(
                                color: _colorState[item.state],
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              )),
                        ],
                      ),
//                    Container(
//                      padding:
//                          EdgeInsets.symmetric(vertical: 1, horizontal: 5),
//                      decoration: BoxDecoration(
//                        color: Colors.grey[200],
//                        borderRadius: BorderRadius.circular(5),
//                      ),
//                      child: Text(
//                        '货号：' + item.sampleProduct.skuID,
//                        style: TextStyle(
//                          color: Colors.grey,
//                          fontSize: 12,
//                        ),
//                      ),
//                    ),
                      item.type == LendBorrowType.BORROW ?
                      Row(
                        children: <Widget>[
                          Text(
                            '借出日期：'+ (DateFormatUtil.formatYMD(item.creationDate) ?? ''),
                          ),
                          Offstage(
                            offstage: !isSampleProductHistory,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text('借出数量：${item.quantity ?? ''}'),
                            ),
                          )
                        ],
                      ):
                      Row(
                        children: <Widget>[
                          Text(
                            '借入日期：'+ (DateFormatUtil.formatYMD(item.creationDate) ?? ''),
                          ),
                          Offstage(
                            offstage: !isSampleProductHistory,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text('借入数量：${item.quantity ?? ''}'),
                            ),
                          )
                        ],
                      ),
                      item.state == ReturnState.RETURNED
                          ? Text(
                        '归还日期：' +
                            (DateFormatUtil.formatYMD(item.returnedDate) ?? ''),
                      )
                          : Text(
                        '预计归还日期：' +
                            (DateFormatUtil.formatYMD(item.expectedReturningDate) ?? ''),
                      ),
                      !isSampleProductHistory?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Offstage(
                            offstage: item.state == ReturnState.NOT_RETURNED ? false : true,
                            child:GestureDetector(
                              child: Container(
                                padding:
                                EdgeInsets.symmetric(vertical: 3, horizontal: 35),
                                decoration: ShapeDecoration(
                                    color: Color.fromRGBO(255,214,12, 1),
                                    shape: StadiumBorder(side: BorderSide(color: Color.fromRGBO(255,214,12, 1),width: 0,))
                                ),
                                child: Text(
                                  '归还',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              onTap: (){
                                ProductRepositoryImpl().getSampleHistory(item.id.toString()).then((history){
                                  history.state = ReturnState.RETURNED;
                                  history.returnedDate = DateTime.now();
                                  ShowDialogUtil.showAlertDialog(context, '是否确认归还', (){
                                    ProductRepositoryImpl().updateSampleHistory(history).then((a){
                                      print(SampleBorrowReturnHistoryModel.toJson(history));
                                      Navigator.pop(context);
                                      SampleProductHistoryBLoC.instance.filterByStatuses(state, type);
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('样衣归还成功'),duration: Duration(seconds: 2),));
                                    });
                                  });
                                });

                              },
                            ),
                          ),
                        ],
                      ):
                      Text('备注：${item.remarks ?? ''}')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
