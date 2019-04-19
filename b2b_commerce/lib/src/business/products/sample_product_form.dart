import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SampleProductFormPage extends StatefulWidget {
  SampleProductModel item;
  bool isCreate;

  SampleProductFormPage({this.item, this.isCreate = false});

  SampleProductFormPageState createState() => SampleProductFormPageState();
}

class SampleProductFormPageState extends State<SampleProductFormPage> {
  List<MediaModel> _images;
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();
  FocusNode _skuIDFocusNode = FocusNode();
  TextEditingController _skuIDController = TextEditingController();
  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.code;
    _images = widget.item?.pictures ?? [];

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(widget.isCreate ? '新建样衣':'编辑样衣'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Text('上传样衣图片'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: EditableAttachments(
              list: _images,
            ),
          ),
          TextFieldComponent(
            focusNode: _nameFocusNode,
            controller: _nameController,
            leadingText: '样衣名称',
            hintText: '请输入样衣名称',
          ),
          TextFieldComponent(
            focusNode: _skuIDFocusNode,
            controller: _skuIDController,
            leadingText: '货号',
            hintText: '请输入样衣名称',
          ),
          Expanded(
              child: ListTile(
            title: RaisedButton(
              onPressed: () {
                if (_nameController.text == '') {
//                  (_scaffoldKey.currentState as ScaffoldState).showSnackBar(
//                    SnackBar(
//                      content: Text('样衣名称不可以为空'),
//                      duration: Duration(seconds: 1),
//                      action: SnackBarAction(label: 'aa', onPressed: () {}),
//                    ),
//                  );
                  showDialog(
                      context: (context),
                      builder: (context) => AlertDialog(
                            content: Text('样衣名称不可以为空'),
                          ));
                  return;
                }
                if (_skuIDController.text == '') {
                  showDialog(
                      context: (context),
                      builder: (context) => AlertDialog(
                            content: Text('货号不可以为空'),
                          ));
                  return;
                }
                widget.item.code = _skuIDController.text;
                widget.item.name = _nameController.text;
                widget.item.pictures = _images;

                widget.isCreate
                    ? ProductRepositoryImpl()
                        .createSample(widget.item)
                        .then((code) {
                        Navigator.pop(context);
                        SampleProductBLoC.instance.filterByStatuses();
                      })
                    : ProductRepositoryImpl()
                        .updateSample(widget.item)
                        .then((code) {
                        Navigator.pop(context);
                        SampleProductBLoC.instance.filterByStatuses();
                      });
              },
              child: Text('确认'),
              color: Color.fromRGBO(255, 214, 12, 1),
            ),
          )),
        ],
      ),
    );
  }
}
