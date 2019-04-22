import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyFactoryBaseFormPage extends StatefulWidget {
  MyFactoryBaseFormPage(this.factory);

  final FactoryModel factory;

  @override
  State createState() => MyFactoryBaseFormPageState();
}

class MyFactoryBaseFormPageState extends State<MyFactoryBaseFormPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cooperativeBrandController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cooperativeBrandFocusNode = FocusNode();

  List<MediaModel> medias = [];
  List<String> _scaleRange = [];
  List<String> _monthlyCapacityRanges = [];
  List<String> _populationScale = [];
  List<String> _cooperationModes = [];

  @override
  void initState() {
    _nameController.text = widget.factory.name ?? '';
    _cooperativeBrandController.text = widget.factory.cooperativeBrand ?? '';
    if (widget.factory.scaleRange != null) {
      _scaleRange.add(widget.factory.scaleRange.toString().split('.')[1]);
    }
    if (widget.factory.monthlyCapacityRange != null) {
      _monthlyCapacityRanges
          .add(widget.factory.monthlyCapacityRange.toString().split('.')[1]);
    }
    if (widget.factory.populationScale != null) {
      _populationScale
          .add(widget.factory.populationScale.toString().split('.')[1]);
    }
    if (widget.factory.cooperationModes != null) {
      _cooperationModes.addAll(
        widget.factory.cooperationModes
            .map((cooperationMode) => cooperationMode.toString().split('.')[1]),
      );
    }
    if (widget.factory.profilePicture != null)
      medias = [widget.factory.profilePicture];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.factory.monthlyCapacityRange);
    return Scaffold(
      appBar: AppBar(
        title: Text('基本资料'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text(
                '确定',
                style: TextStyle(),
              ),
              onPressed: () {
                if (medias.length > 0) {
                  widget.factory.profilePicture = medias[0];
                } else {
                  widget.factory.profilePicture = null;
                }
                widget.factory.name =
                    _nameController.text == '' ? null : _nameController.text;
                widget.factory.cooperativeBrand =
                    _cooperativeBrandController.text == ''
                        ? null
                        : _cooperativeBrandController.text;

                UserRepositoryImpl()
                    .factoryUpdate(widget.factory)
                    .then((a) => Navigator.pop(context));
              })
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                '上传图片',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
            ),
            EditableAttachments(
              list: medias,
              maxNum: 1,
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                focusNode: _nameFocusNode,
                leadingText: Text('公司名称',style: TextStyle(fontSize: 16,color: Colors.grey,)),
                controller: _nameController,
              ),
            ),
            SizedBox(height: 2),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '月均产能',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                    Text(widget.factory.monthlyCapacityRange == null
                        ? ''
                        : MonthlyCapacityRangesLocalizedMap[
                            widget.factory.monthlyCapacityRange]),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: MonthlyCapacityRangesEnum,
                            title: '月均产能',
                            codes: _monthlyCapacityRanges,
                            count: 3,
                          ),
                    ));

                if (result != null) _monthlyCapacityRanges = result;

                if (_monthlyCapacityRanges.length > 0) {
                  MonthlyCapacityRange monthlyCapacityRanges =
                      MonthlyCapacityRange.values.singleWhere(
                          (monthlyCapacityRanges) =>
                              monthlyCapacityRanges.toString().split('.')[1] ==
                              _monthlyCapacityRanges[0],
                          orElse: () => null);

                  widget.factory.monthlyCapacityRange = monthlyCapacityRanges;
                }
              },
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '产值规模',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                    Text(widget.factory.scaleRange == null
                        ? ''
                        : ScaleRangesLocalizedMap[widget.factory.scaleRange]),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: ScaleRangesEnum,
                            title: '产值规模',
                            codes: _scaleRange,
                            count: 3,
                          ),
                    ));

                if (result != null) _scaleRange = result;

                if (_scaleRange.length > 0) {
                  ScaleRanges scaleRange = ScaleRanges.values.singleWhere(
                      (scaleRange) =>
                          scaleRange.toString().split('.')[1] == _scaleRange[0],
                      orElse: () => null);

                  widget.factory.scaleRange = scaleRange;
                }
              },
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '工厂规模',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                    Text(widget.factory.populationScale == null
                        ? ''
                        : PopulationScaleLocalizedMap[
                            widget.factory.populationScale]),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: PopulationScaleEnum,
                            title: '工厂规模',
                            codes: _populationScale,
                            count: 3,
                          ),
                    ));

                if (result != null) _scaleRange = result;

                if (_scaleRange.length > 0) {
                  PopulationScale populationScale = PopulationScale.values
                      .singleWhere(
                          (populationScale) =>
                              populationScale.toString().split('.')[1] ==
                              _populationScale[0],
                          orElse: () => null);

                  widget.factory.populationScale = populationScale;
                }
              },
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '合作方式',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                    Text(formatCooperationModesSelectText(
                        widget.factory.cooperationModes)),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: CooperationModesEnum,
                            title: '合作方式',
                            codes: _cooperationModes,
                            multiple: true,
                            count: 4,
                          ),
                    ));

                if (result != null) _cooperationModes = result;

                if (_cooperationModes.length > 0) {
                  List<CooperationModes> cooperationModes =
                      _cooperationModes.map((mode) {
                    return CooperationModes.values.singleWhere(
                        (cooperationMode) =>
                            cooperationMode.toString().split('.')[1] == mode,
                        orElse: () => null);
                  }).toList();

                  widget.factory.cooperationModes = cooperationModes;
                }
              },
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '生产大类',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatCategorySelectText(widget.factory.categories, 5),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () async {
                List<CategoryModel> categorys =
                    await ProductRepositoryImpl().majorCategories();

                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          title: '生产大类',
                          items: categorys,
                          models: widget.factory.categories,
                          multiple: true,
                        ),
                  ),
                );

                if (result != null) {
                  widget.factory.categories = result;
                }
              },
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '优势类目',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatCategorySelectText(
                          widget.factory.adeptAtCategories, 2),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () async {
                List<CategoryModel> categories =
                    await ProductRepositoryImpl().cascadedCategories();
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategorySelectPage(
                          categories: categories,
                          minCategorySelect: widget.factory.adeptAtCategories,
                          multiple: true,
                        ),
                  ),
                );

                if (result != null) {
                  widget.factory.adeptAtCategories = result;
                }
              },
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                focusNode: _cooperativeBrandFocusNode,
                leadingText: Text('合作品牌商',style: TextStyle(fontSize: 16,color: Colors.grey,)),
                controller: _cooperativeBrandController,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '我的标签',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatLabelsSelectText(widget.factory.labels),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () async {
                List<LabelModel> labels = await UserRepositoryImpl().labels();
                labels.removeWhere((label) => label.group != 'FACTORY');
                if (widget.factory.labels == null) widget.factory.labels = [];
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          title: '选择标签',
                          items: labels,
                          models: widget.factory.labels,
                          multiple: true,
                        ),
                  ),
                );

                if (result != null) {
                  widget.factory.labels = result;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String formatCategorySelectText(List<CategoryModel> categorys, int count) {
    String text = '';

    if (categorys != null) {
      text = '';
      for (int i = 0; i < categorys.length; i++) {
        if (i > count - 1) {
          text += '...';
          break;
        }

        if (i == categorys.length - 1) {
          text += categorys[i].name;
        } else {
          text += categorys[i].name + '、';
        }
      }
    }

    return text;
  }

  String formatLabelsSelectText(List<LabelModel> labels) {
    String text = '';

    if (labels != null) {
      text = '';
      for (int i = 0; i < labels.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == labels.length - 1) {
          text += labels[i].name;
        } else {
          text += labels[i].name + '、';
        }
      }
    }

    return text;
  }

  //格式化合作方式
  String formatCooperationModesSelectText(
      List<CooperationModes> cooperationModes) {
    String text = '';

    if (cooperationModes != null) {
      text = '';
      for (int i = 0; i < cooperationModes.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == cooperationModes.length - 1) {
          text += CooperationModesLocalizedMap[cooperationModes[i]];
        } else {
          text += CooperationModesLocalizedMap[cooperationModes[i]] + '、';
        }
      }
    }

    return text;
  }
}
