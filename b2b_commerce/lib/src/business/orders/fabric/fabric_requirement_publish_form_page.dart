import 'dart:io';

import 'package:core/core.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'fabric_requirement_publish_grant_page.dart';

///面料需求发布表单页
class FabricRequirementPublishFormPage extends StatefulWidget {
  @override
  _FabricRequirementPublishFormPageState createState() =>
      _FabricRequirementPublishFormPageState();
}

class _FabricRequirementPublishFormPageState
    extends State<FabricRequirementPublishFormPage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;

  TextEditingController titleController;
  FocusNode titleFocusNode;
  TextEditingController numController;

  FocusNode numFocusNode;

  List<MediaModel> pictures;
  List<MediaModel> video;

  int expireTime;

  ///是否同意协议
  bool isAgree;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    titleController = TextEditingController();
    titleFocusNode = FocusNode();
    numController = TextEditingController();
    numFocusNode = FocusNode();
    pictures = [];
    video = [];
    expireTime = 7;
    isAgree = false;
  }

  Future<void> initPlatformState() async {
    AndroidDeviceInfo androidInfo;
    IosDeviceInfo iosInfo;

    try {
      if (Platform.isAndroid) {
        androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      } else if (Platform.isIOS) {
        iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      }
    } on PlatformException {
      print('[nbyjy]=====>获取设备信息错误');
    }

    if (!mounted) return;

    setState(() {
      androidDeviceInfo = androidInfo;
      iosDeviceInfo = iosInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ShowDialogUtil.showChoseDiglog(context, '正在创建面料需求，是否确认退出', () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('面料需求'),
        ),
        body: Container(
          color: Colors.grey[100],
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
        color: Colors.white,
        child: ListView(children: <Widget>[
          _PicturesRow(
            list: pictures,
            editable: true,
          ),
          Divider(),
          _VideoRow(
            editable: true,
            list: video,
          ),
          Divider(),
          _TitleRow(
            titleController: titleController,
            titleFocusNode: titleFocusNode,
            onChanged: (v) {},
          ),
          _NumRow(
            numController: numController,
            numFocusNode: numFocusNode,
            onChanged: (v) {},
          ),
          Divider(),
          _UnitRow(),
          Divider(),
          _ExpiryTimeRow(
            value: expireTime,
            onChanged: (v) {
              setState(() {
                expireTime = v;
              });
            },
          ),
          Divider(),
          _ProtocolRow(
            value: isAgree,
            onChanged: (v) {
              setState(() {
                isAgree = v;
              });
            },
          ),
          _NextButton(
            onPressed: isAgree
                ? () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            FabricRequirementPublishGrantPage()));
                  }
                : null,
          )
        ]));
  }
}

///参考图片
class _PicturesRow extends StatelessWidget {
  final List<MediaModel> list;

  final int maxNum;

  final bool editable;

  const _PicturesRow(
      {Key key, @required this.list, this.maxNum = 5, this.editable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '参考图片',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextSpan(
                        text: '（若无图片可不上传）',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          EditableAttachments(
            list: list,
            maxNum: maxNum,
            editable: editable,
          ),
          Container(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '最多上传5张',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      TextSpan(
                        text: '（长按图片删除）',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///参考视频
class _VideoRow extends StatelessWidget {
  final List<MediaModel> list;

  final int maxNum;

  final bool editable;

  const _VideoRow(
      {Key key, @required this.list, this.maxNum = 1, this.editable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '参考视频',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextSpan(
                        text: '（若无视频可不上传）',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          VideoAttachments(
            list: list,
            maxNum: maxNum,
            editable: editable,
          ),
          Container(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '最多上传1个',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      TextSpan(
                        text: '（长按视频删除）',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///标题
class _TitleRow extends StatelessWidget {
  final TextEditingController titleController;

  final FocusNode titleFocusNode;

  final ValueChanged<String> onChanged;

  const _TitleRow({Key key,
    @required this.titleController,
    @required this.titleFocusNode,
    @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '面料标题',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' * ',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '填写',
              controller: titleController,
              focusNode: titleFocusNode,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _NumRow extends StatelessWidget {
  final TextEditingController numController;

  final FocusNode numFocusNode;

  final ValueChanged<String> onChanged;

  const _NumRow({Key key,
    @required this.numController,
    @required this.numFocusNode,
    @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '采购数量',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              inputType: TextInputType.number,
              hintText: '填写',
              controller: numController,
              focusNode: numFocusNode,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

///单位选择
class _UnitRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '采购单位',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ]),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///有效期
class _ExpiryTimeRow extends StatelessWidget {
  final int value;

  final ValueChanged<int> onChanged;

  const _ExpiryTimeRow(
      {Key key, @required this.value, @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '有效期限',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 0,
              mainAxisSpacing: 20,
              childAspectRatio: 4,
              padding: EdgeInsets.zero,
              children: List.generate(EffectiveDaysEnum.length, (index) {
                return GestureDetector(
                  onTap: () {
                    onChanged(int.parse(EffectiveDaysEnum[index].code));
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                          value: EffectiveDaysEnum[index].code,
                          groupValue: value.toString(),
                          onChanged: (v) {
                            onChanged(int.parse(EffectiveDaysEnum[index].code));
                          }),
                      Expanded(
                          child: Text(
                            EffectiveDaysEnum[index].name,
                            softWrap: false,
                            overflow: TextOverflow.visible,
                          )),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolRow extends StatelessWidget {
  final bool value;

  final ValueChanged<bool> onChanged;

  const _ProtocolRow({Key key, @required this.value, @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Checkbox(
              onChanged: onChanged,
              value: value,
            ),
            Text(
              '我已阅读并同意',
              style: TextStyle(color: Colors.black54),
            ),
            GestureDetector(
              onTap: () => showServiceProtocol(context),
              child: Text(
                '《注册及授权发布协议》',
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ));
  }

  void showServiceProtocol(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/paymentProtocol.txt"),
            initialData: null,
            builder: (context, snapshot) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            '注册及授权发布协议',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}

///下一步按钮
class _NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _NextButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: RaisedButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '下一步',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: onPressed,
        ));
  }
}
