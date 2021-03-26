import 'dart:ui';

import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MaterielProductForm extends StatefulWidget {
  ///有id为更新
  final int id;

  const MaterielProductForm({Key key, this.id}) : super(key: key);

  @override
  _MaterielProductFormState createState() => _MaterielProductFormState();
}

class _MaterielProductFormState extends State<MaterielProductForm> {
  MaterielProductModel form;

  bool showMore = false;
  ScrollController _scrollController;

  ///用途
  var uses = ['服装', '里料', '沙发', '窗帘', '鞋材', '箱包', '工程布', '功能布', '防水布', '家纺'];

  TextEditingController _nameController;
  FocusNode _nameNode;
  TextEditingController _skuController;
  FocusNode _skuNode;
  TextEditingController _priceController;
  FocusNode _priceNode;
  TextEditingController _gramWeightController;
  FocusNode _gramWeightNode;
  TextEditingController _widthController;
  FocusNode _widthNode;
  TextEditingController _basisController;
  FocusNode _basisNode;
  TextEditingController _describeController;
  FocusNode _describeNode;

  @override
  void initState() {
    if (widget.id == null) {
      form = MaterielProductModel(images: [], details: [], uses: []);
    }
    _scrollController = ScrollController();
    _nameController = TextEditingController();
    _nameNode = FocusNode();
    _skuController = TextEditingController();
    _skuNode = FocusNode();
    _priceController = TextEditingController();
    _priceNode = FocusNode();
    _gramWeightController = TextEditingController();
    _gramWeightNode = FocusNode();
    _widthController = TextEditingController();
    _widthNode = FocusNode();
    _basisController = TextEditingController();
    _basisNode = FocusNode();
    _describeController = TextEditingController();
    _describeNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('${widget.id != null ? '编辑' : '创建'}面辅料'),
        actions: [_deleteBtn()],
      ),
      body: Container(
        child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context,
              AsyncSnapshot<MaterielProductModel> snapshot) {
            if (form != null) {
              return ListView(
                controller: _scrollController,
                children: [
                  _buildCategory(),
                  _buildImages(),
                  _buildBasic(),
                  _buildInfo(),
                  _submitBtn()
                ],
              );
            } else {
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return FormBlock(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '面料类型',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  )
                ]),
              ),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQueryData
                                  .fromWindow(window)
                                  .size
                                  .height /
                                  2,
                              child: Consumer(
                                builder: (context,
                                    MajorCategoryState categoryState, _) =>
                                    FutureBuilder(
                                      future: categoryState
                                          .getMajorCategories(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<CategoryModel>>
                                          snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child: CircularProgressIndicator());
                                        } else {
                                          return SingleMajorCategorySelect(
                                            categories: snapshot.data,
                                            categorySelect: form.category,
                                            onItemTap: (categoryModel) {
                                              setState(() {
                                                form.category = categoryModel;
                                                Navigator.pop(context);
                                              });
                                            },
                                          );
                                        }
                                      },
                                    ),
                              ),
                            );
                          });
                    },
                    child: Text(
                      '${form.category?.name ?? '选择面料类型'}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.end,
                    )),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildImages() {
    return FormBlock(
      children: [
        FormTitle(
          '产品主图',
          remarks: '(长按删除)',
        ),
        Container(
          color: Colors.white,
          child: EditableAttachments(
            list: form.images,
            maxNum: 5,
          ),
        ),
        FormTitle(
          '产品详情图',
          remarks: '(长按删除)',
        ),
        Container(
          color: Colors.white,
          child: EditableAttachments(
            list: form.details,
            maxNum: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildBasic() {
    return FormBlock(
      children: [
        FormTitle('产品标题：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '必填',
            controller: _nameController,
            // maxLength: 120,
            focusNode: _nameNode,
            onChanged: (value) {
              form.name = value;
            },
          ),
        ),
        FormTitle('货号：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '必填',
            controller: _skuController,
            // maxLength: 120,
            focusNode: _skuNode,
            onChanged: (value) {
              form.skuID = value;
            },
          ),
        ),
        FormTitle('价格：'),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldBorderComponent(
                    padding: EdgeInsets.all(0),
                    hideDivider: true,
                    isRequired: true,
                    textAlign: TextAlign.left,
                    inputFormatters: [
                      DecimalInputFormat(),
                    ],
                    hintText: '必填',
                    controller: _priceController,
                    focusNode: _priceNode,
                    onChanged: (value) {
                      form.price = double.parse(value);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    '元/米',
                  ),
                )
              ],
            )),
      ],
    );
  }

  Widget _buildInfo() {
    return FormBlock(
      children: [
        FormTitle('克重：'),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldBorderComponent(
                    padding: EdgeInsets.all(0),
                    hideDivider: true,
                    isRequired: true,
                    textAlign: TextAlign.left,
                    inputFormatters: [
                      DecimalInputFormat(),
                    ],
                    hintText: '必填',
                    controller: _gramWeightController,
                    focusNode: _gramWeightNode,
                    onChanged: (value) {
                      form.gramWeight = double.parse(value);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    'g/㎡',
                  ),
                )
              ],
            )),
        FormTitle('有效幅宽：'),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldBorderComponent(
                    padding: EdgeInsets.all(0),
                    hideDivider: true,
                    isRequired: true,
                    textAlign: TextAlign.left,
                    inputFormatters: [
                      DecimalInputFormat(),
                    ],
                    hintText: '必填',
                    controller: _widthController,
                    focusNode: _widthNode,
                    onChanged: (value) {
                      form.width = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    'cm',
                  ),
                )
              ],
            )),
        FormTitle('成分：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '必填',
            controller: _basisController,
            focusNode: _basisNode,
            onChanged: (value) {
              form.basis = value;
            },
          ),
        ),
        FormTitle('描述：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '填写描述',
            controller: _describeController,
            focusNode: _describeNode,
            onChanged: (value) {
              form.describe = value;
            },
          ),
        ),
        FormTitle('用途：'),
        Row(
          children: [
            Expanded(
                child: _UsesSelection(
                  values: uses,
                  data: form.uses,
                  onChange: (values) {
                    setState(() {
                      form.uses = values;
                    });
                  },
                ))
          ],
        ),
      ],
    );
  }

  Widget _submitBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  disabledColor: Colors.grey,
                  onPressed: () {
                    if (validateForm()) {
                      _submit();
                    }
                  },
                  color: Constants.THEME_COLOR_MAIN,
                  child: Text('保存',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ))),
            ))
      ],
    );
  }

  Widget _deleteBtn() {
    if (widget.id != null) {
      return TextButton(onPressed: _onDelete, child: Text('删除'));
    } else {
      return Container();
    }
  }

  ///校验表单
  bool validateForm() {
    List<FormValidateItem> validateItems = [
      FormValidateItem((form.category == null), '请选择面料类型!'),
      FormValidateItem((form.name == null || form.name.trim() == ''), '请填写标题!'),
      FormValidateItem((form.images == null || form.images.isEmpty), '请上传主图！'),
      FormValidateItem(
          (form.skuID == null || form.skuID.trim() == ''), '请填写货号！'),
      FormValidateItem(form.price == null || !(form.price > 0), '请填写价格！'),
      FormValidateItem(
          form.gramWeight == null || !(form.gramWeight > 0), '请填写克重！  '),
      FormValidateItem(
          (form.width == null || form.width.trim() == ''), '请填写有效幅宽！'),
      FormValidateItem(
          (form.basis == null || form.basis.trim() == ''), '请填写成分！')
    ];

    FormValidateItem item = validateItems
        .firstWhere((element) => element.result, orElse: () => null);

    if (item == null) {
      return true;
    } else {
      BotToast.showText(
          text: '${item.message}',
          onlyOne: true,
          crossPage: false,
          clickClose: true);
      return false;
    }
  }

  void _submit() async {
    Function cancelFunc =
    BotToast.showLoading(crossPage: false, clickClose: true);
    BaseResponse response = await MaterielProductRepository.create(form);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '提交成功');
      Navigator.of(context).pop(true);
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  void _onDelete() {
    BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        clickClose: true,
        crossPage: false,
        backgroundColor: Colors.black38,
        toastBuilder: (cancelFunc) =>
            AlertDialog(
              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('是否确认删除？'),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: FlatButton(
                                onPressed: cancelFunc, child: Text('否'))),
                        Expanded(
                            child: FlatButton(
                                onPressed: () {
                                  cancelFunc.call();
                                  _delete();
                                },
                                child: Text('是',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ))))
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  void _delete() async {
    Function cancelFunc =
    BotToast.showLoading(crossPage: false, clickClose: true);
    BaseResponse result = await MaterielProductRepository.delete(widget.id);
    cancelFunc.call();
    if (result != null) {
      if (result.code == 1) {
        BotToast.showText(text: '删除成功');
        Navigator.of(context).pop(true);
      } else {
        BotToast.showText(text: '删除失败：${result.msg}');
      }
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  ///获取产品信息
  Future<MaterielProductModel> _getData() async {
    if (form == null) {
      MaterielProductModel result =
      await MaterielProductRepository.get(widget.id);
      if (result != null) {
        form = result;
        initForm(form);
      }
    }
    return form;
  }

  void initForm(MaterielProductModel model) {
    setState(() {
      _nameController.text = model.name;
      _skuController.text = model.skuID;
      _priceController.text = '${model.price ?? ''}';
      _gramWeightController.text = '${model.gramWeight ?? ''}';
      _widthController.text = model.width;
      _basisController.text = model.basis;
      _describeController.text = model.describe;
    });
  }
}

///用途选择组件
class _UsesSelection extends StatelessWidget {
  final List<String> values;

  final List<String> data;

  final ValueChanged<List<String>> onChange;

  const _UsesSelection({Key key, this.values, this.onChange, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        children: values
            .map(
              (e) =>
              ChoiceChip(
                selectedColor: Color.fromRGBO(255, 214, 12, 1),
                label: Text(
                  e,
                  style: TextStyle(color: Colors.black),
                ),
                selected: data.contains(e),
                onSelected: (select) {
                  if (select) {
                    data.add(e);
                    onChange(data);
                  } else {
                    data.remove(e);
                    onChange(data);
                  }
                },
              ),
        )
            .toList(),
      ),
    );
  }
}
