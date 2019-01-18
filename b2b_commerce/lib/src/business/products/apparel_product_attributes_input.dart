import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ApparelProductAttributesInputPage extends StatefulWidget {
  final ApparelProductModel item;

  ApparelProductAttributesInputPage({this.item});

  ApparelProductAttributesInputPageState createState() =>
      ApparelProductAttributesInputPageState();
}

class ApparelProductAttributesInputPageState
    extends State<ApparelProductAttributesInputPage> {
  String _styleText;

  @override
  void initState() {
    if (widget.item != null) {
      _styleText = widget.item?.attributes?.styles?.length > 0
          ? '已选择 ' + widget.item?.attributes?.styles?.length.toString()
          : '';
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('属性'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(children: <Widget>[
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择风格',
                      items: StyleEnum,
                      codes: widget.item?.attributes?.styles,
                      multiple: true,
                    ),
              ),
            );

            if (result != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.length.toString()),
                    ),
              );
              if (result.length > 0) {
                _styleText = '已选择' + result.length.toString();
              }
            }
          },
          child: ShowSelectTile(
            leadingText: '风格',
            tralingText: _styleText,
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            EnumModel result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择面料',
                      items: FabricCompositionEnum,
                      code: widget.item?.attributes?.fabricComposition,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '面料',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择版型',
                      items: EditionTypeEnum,
                      code: widget.item?.attributes?.editionType,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '版型',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择款式',
                      items: PatternEnum,
                      code: widget.item?.attributes?.pattern,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '款式',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择袖型',
                      items: SleeveTypeEnum,
                      code: widget.item?.attributes?.sleeveType,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '袖型',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择袖长/裤长',
                      items: SleeveLengthEnum,
                      code: widget.item?.attributes?.sleeveLength,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '袖长/裤长',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择图案',
                      items: DecorativePatternEnum,
                      multiple: true,
                      codes: widget.item?.attributes?.decorativePattern,
                    ),
              ),
            );
            if (result != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result[0].name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '图案',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择流行元素',
                      items: PopularElementsEnum,
                      multiple: true,
                      codes: widget.item?.attributes?.popularElements,
                    ),
              ),
            );
            if (result != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result[0].name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '流行元素',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择填充物',
                      items: FillerEnum,
                      code: widget.item?.attributes?.filler,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '填充物',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择厚薄',
                      items: ThicknessEnum,
                      code: widget.item?.attributes?.thickness,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '厚薄',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                    title: '选择季节',
                    items: SeasonEnum,
                    code: widget.item?.attributes?.season),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '季节',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择吊牌',
                      items: <EnumModel>[
                        EnumModel('Y001', '有'),
                        EnumModel('Y002', '没有'),
                      ],
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '吊牌',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      title: '选择门襟',
                      items: PlacketEnum,
                      code: widget.item?.attributes?.placket,
                    ),
              ),
            );
            if (result?.name != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(result.name),
                    ),
              );
            }
          },
          child: ShowSelectTile(
            leadingText: '门襟',
            tralingText: '',
            tralingTextColor: Colors.orange,
          ),
        ),
      ]),
    );
  }
}
