import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import 'package:services/services.dart';

class FastPublishRequirement extends StatefulWidget {
  _FastPublishRequirementState createState() => _FastPublishRequirementState();
}

class _FastPublishRequirementState extends State<FastPublishRequirement> {
  RequirementOrderModel model = RequirementOrderModel(details: RequirementInfoModel());
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _requirementNumController = TextEditingController();

  /// 期望交货时间
  DateTime expectedDeliveryDate;

  /// 需求数量
  int requirementNum;

  List<CategoryModel> _categorySelected = [];
  String category = '点击选择分类';

  @override
  void initState() {
    ProductRepositoryImpl().cascadedCategories().then((categorys)=>_categorys = categorys);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();

    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(8, 20, 8, 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    B2BIcons.left_quotation,
                    color: Color.fromRGBO(255, 234, 234, 1),
                    size: 12,
                  ),
                  Text(
                    '   急速发布需求   ',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    B2BIcons.right_quotation,
                    color: Color.fromRGBO(255, 234, 234, 1),
                    size: 12,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _showCategorySelect();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      category,
                      style: TextStyle(
                          color: Color.fromRGBO(150, 150, 150, 1),
                          fontSize: 15),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Color.fromRGBO(200, 200, 200, 1),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // _showRequirementNum(context, _focusNode);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(248, 248, 248, 1),
                    borderRadius: BorderRadius.circular(5)),
                child:
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text(
                    //       requirementNum == null ? '填写需求数量' : '${requirementNum}',
                    //       style: TextStyle(
                    //           color: Color.fromRGBO(150, 150, 150, 1),
                    //           fontSize: 15),
                    //     )
                    //   ],
                    // )
                    TextFormField(
                        autofocus: false,
                        controller: _requirementNumController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            hintText: '填写需求数量',
                            border: InputBorder.none),
                        // 校验数量
                        validator: (v) {
                          return int.parse(v) > 0 ? null : '数量大于0';
                        }),
              ),
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    expectedDeliveryDate != null
                        ? Text(
                            '${DateFormatUtil.format(expectedDeliveryDate)}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          )
                        : Text(
                            '预计交货时间',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Color.fromRGBO(200, 200, 200, 1),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: FlatButton(
                        onPressed: () async{
                          model.details.category = _categorySelected == [] ? null : _categorySelected[0];
                          model.details.expectedMachiningQuantity = requirementNum;
                          model.details.expectedDeliveryDate = expectedDeliveryDate;

                          String code = await RequirementOrderRepository().publishNewRequirement(model);
                          //清空数据
                          expectedDeliveryDate = null;
                          _requirementNumController.clear();

                          //跳转
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PublishRequirementSuccessDialog(
                                      model: model,
                                    ),
                                fullscreenDialog: true,
                              ));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Color.fromRGBO(255, 149, 22, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: Text(
                          '直接发布',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: expectedDeliveryDate == null
            ? DateTime.now()
            : expectedDeliveryDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    setState(() {
      expectedDeliveryDate = picked;
    });
  }

  void _showRequirementNum(BuildContext context, FocusNode focusNode) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入需求数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFieldComponent(
                  controller: _requirementNumController,
                  autofocus: true,
                  inputType: TextInputType.number,
                  focusNode: focusNode,
                  hintText: '请输入需求数量',
                  padding: EdgeInsets.all(0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(color: Color(0xffFF9516)),
              ),
              onPressed: () {
                if (_requirementNumController.text != '' &&
                    _requirementNumController.text != null) {
                  setState(() {
                    requirementNum = int.parse(_requirementNumController.text);
                  });
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //小类
  void _showCategorySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: CategorySelect(
            categorys: _categorys,
            multiple: false,
            verticalDividerOpacity: 1,
            categorySelect: _categorySelected,
          ),
        );
      },
    ).then((val) {
      category = '';
      if (_categorySelected.isNotEmpty) {
        for (int i = 0; i < _categorySelected.length; i++) {
          category += _categorySelected[i].name + ',';
        }
      } else {
        category = '点击选择分类';
      }
      setState(() {
        category = category;
      });
    });
  }
}

List<CategoryModel> _categorys;
