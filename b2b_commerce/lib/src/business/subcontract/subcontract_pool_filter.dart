import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class SubContractFilterPage extends StatelessWidget {
  final SubContractPoolState subContractPoolState;

  SubContractFilterPage({Key key, this.subContractPoolState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FlatButton(
                onPressed: (){
                  subContractPoolState.clearAllCondition();
                  Navigator.pop(context);
                },
                child: Text(
                  '重置',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FlatButton(
                onPressed: (){
                  subContractPoolState.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  '确定',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Text('类       型'),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: SubContractTypeEnum
                      .map((type) => ChoiceChip(
                      label: Container(
                        height: 20,
                        width: 60,
                        child: Center(child: Text(type.name)),
                      ),
                      backgroundColor: Colors.grey[100],
                      selectedColor: Color.fromRGBO(255, 214, 12, 1),
                      selected: subContractPoolState.type == type.code,
                      onSelected: (bool selected) {
                        subContractPoolState.type = type.code;
                      }))
                      .toList(),
                ),
              ),
            Divider(height: 0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Text('面料类别'),
                ],
              ),
            ),
            Consumer(
              builder: (context, MajorCategoryState majorCategoryState,_) => Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child:FutureBuilder(
                  future: majorCategoryState
                      .getMajorCategories(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CategoryModel>>
                      snapshot) {
                    if (!snapshot.hasData && snapshot.data != null) {
                      return Center(
                          child:
                          CircularProgressIndicator());
                    } else {
                      return GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 20,
                        childAspectRatio: 3,
                        padding: EdgeInsets.zero,
                        children: List.generate(snapshot.data?.length ?? 0, (index) {
                          return ChoiceChip(
                              label: Container(
                                height: 20,
                                width: 60,
                                child: Center(child: Text(snapshot.data[index].name)),
                              ),
                              backgroundColor: Colors.grey[100],
                              selectedColor: Color.fromRGBO(255, 214, 12, 1),
                              selected: subContractPoolState.majorCategory == snapshot.data[index],
                              onSelected: (bool selected) {
                                subContractPoolState.majorCategory = snapshot.data[index];
                              });
                        }),
                      );
                    }
                  },
                ),

              ),
            ),
            Divider(height: 0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Text('加工方式'),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: CooperationModesEnum
                      .map((type) => ChoiceChip(
                      label: Container(
                        height: 20,
                        width: 60,
                        child: Center(child: Text(type.name)),
                      ),
                      backgroundColor: Colors.grey[100],
                      selectedColor: Color.fromRGBO(255, 214, 12, 1),
                      selected: subContractPoolState.machiningType == type.code,
                      onSelected: (bool selected) {
                        subContractPoolState.machiningType = type.code;
                      }))
                      .toList(),
                ),
              ),
            Divider(height: 0,),
          ],
        ),
      ),
    );
  }

}
