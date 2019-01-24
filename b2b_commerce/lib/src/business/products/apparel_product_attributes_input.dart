import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ApparelProductAttributesInputPage extends StatefulWidget {
  final ApparelProductAttributesModel item;

  ApparelProductAttributesInputPage({this.item});

  ApparelProductAttributesInputPageState createState() =>
      ApparelProductAttributesInputPageState();
}

class ApparelProductAttributesInputPageState
    extends State<ApparelProductAttributesInputPage> {
  String _styleText;
  String _fabricCompositionText;
  String _editionTypeText;
  String _patternText;
  String _sleeveTypeText;
  String _sleeveLengthText;
  String _decorativePatternText;
  String _popularElementsText;
  String _fillerText;
  String _thicknessText;
  String _seasonText;
  String _taggableText;
  String _placketText;
  List<String> _styleCodes;
  String _fabricCompositionCode;
  String _editionTypeCode;
  String _patternCode;
  String _sleeveTypeCode;
  String _sleeveLengthCode;
  List<String> _decorativePatternCodes;
  List<String> _popularElementsCodes;
  String _fillerCode;
  String _thicknessCode;
  String _seasonCode;
  String _taggableCode;
  String _placketCode;

  @override
  void initState() {
    if (widget.item?.styles != null) {
      _styleText = '';
      for (int i = 0; i < widget.item.styles.length; i++) {
        if (i == 4) {
          _styleText += '...';
          break;
        }

        _styleText += enumMap(StyleEnum, widget.item.styles[i]);

        if (i != widget.item.styles.length - 1) {
          _styleText += '、';
        }
      }
      _styleCodes = widget.item?.styles;
    }

    _fabricCompositionText =
        enumMap(FabricCompositionEnum, widget.item?.fabricComposition);
    _fabricCompositionCode = widget.item?.fabricComposition;

    _editionTypeText = enumMap(EditionTypeEnum, widget.item?.editionType);
    _editionTypeCode = widget.item?.editionType;

    _patternText = enumMap(PatternEnum, widget.item?.pattern);
    _patternCode = widget.item?.pattern;

    _sleeveTypeText = enumMap(SleeveTypeEnum, widget.item?.sleeveType);
    _sleeveTypeCode = widget.item?.sleeveType;

    _sleeveLengthText = enumMap(SleeveLengthEnum, widget.item?.sleeveLength);
    _sleeveLengthCode = widget.item?.sleeveLength;

    if (widget.item?.decorativePattern != null) {
      _decorativePatternText = '';
      for (int i = 0; i < widget.item?.decorativePattern.length; i++) {
        if (i == 4) {
          _decorativePatternText += '...';
          break;
        }

        _decorativePatternText +=
            enumMap(DecorativePatternEnum, widget.item?.decorativePattern[i]);

        if (i != widget.item?.decorativePattern.length - 1) {
          _decorativePatternText += '、';
        }
      }

      _decorativePatternCodes = widget.item?.decorativePattern;
    }
    if (widget.item?.popularElements != null) {
      _popularElementsText = '';
      for (int i = 0; i < widget.item?.popularElements.length; i++) {
        if (i == 4) {
          _popularElementsText += '...';
          break;
        }

        _popularElementsText +=
            enumMap(PopularElementsEnum, widget.item?.popularElements[i]);

        if (i != widget.item?.popularElements.length - 1) {
          _popularElementsText += '、';
        }
      }

      _popularElementsCodes = widget.item?.popularElements;
    }

    _fillerText = enumMap(FillerEnum, widget.item?.filler);
    _fillerCode = widget.item?.filler;

    _thicknessText = enumMap(ThicknessEnum, widget.item?.thickness);
    _thicknessCode = widget.item?.thickness;

    _seasonText = enumMap(SeasonEnum, widget.item?.season);
    _seasonCode = widget.item?.season;

    _placketText = enumMap(PlacketEnum, widget.item?.placket);
    _placketCode = widget.item?.placket;

    print(widget.item?.taggable);
    if (widget.item?.taggable != null) {
      print(widget.item?.taggable);
      _taggableText = widget.item?.taggable ? '有' : '没有';
      _taggableCode = widget.item?.taggable ? 'true' : 'false';
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
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () async {
              List<EnumModel> result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnumSelectPage(
                        title: '选择风格',
                        items: StyleEnum,
                        codes: _styleCodes,
                        multiple: true,
                      ),
                ),
              );

              if (result != null) {
                _styleText = '';
                for (int i = 0; i < result.length; i++) {
                  if (i == 4) {
                    _styleText += '...';
                    break;
                  }

                  _styleText += result[i].name;

                  if (i != result.length - 1) {
                    _styleText += '、';
                  }
                }

                _styleCodes = result.map((style) {
                  return style.code;
                }).toList();
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
                        code: _fabricCompositionCode,
                      ),
                ),
              );
              _fabricCompositionText = result.name;
              _fabricCompositionCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '面料',
              tralingText: _fabricCompositionText,
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
                        code: _editionTypeCode,
                      ),
                ),
              );
              _editionTypeText = result.name;
              _editionTypeCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '版型',
              tralingText: _editionTypeText,
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
                        code: _patternCode,
                      ),
                ),
              );
              _patternText = result.name;
              _patternCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '款式',
              tralingText: _patternText,
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
                        code: _sleeveTypeCode,
                      ),
                ),
              );
              _sleeveTypeText = result.name;
              _sleeveTypeCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '袖型',
              tralingText: _sleeveTypeText,
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
                        code: _sleeveLengthCode,
                      ),
                ),
              );
              _sleeveLengthText = result.name;
              _sleeveLengthCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '袖长/裤长',
              tralingText: _sleeveLengthText,
              tralingTextColor: Colors.orange,
            ),
          ),
          InkWell(
            onTap: () async {
              List<EnumModel> result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnumSelectPage(
                        title: '选择图案',
                        items: DecorativePatternEnum,
                        multiple: true,
                        codes: _decorativePatternCodes,
                      ),
                ),
              );

              if (result != null) {
                _decorativePatternText = '';
                for (int i = 0; i < result.length; i++) {
                  if (i == 4) {
                    _decorativePatternText += '...';
                    break;
                  }

                  _decorativePatternText += result[i].name;

                  if (i != result.length - 1) {
                    _decorativePatternText += '、';
                  }
                }

                _decorativePatternCodes = result.map((item) {
                  return item.code;
                }).toList();
              }
            },
            child: ShowSelectTile(
              leadingText: '图案',
              tralingText: _decorativePatternText,
              tralingTextColor: Colors.orange,
            ),
          ),
          InkWell(
            onTap: () async {
              List<EnumModel> result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnumSelectPage(
                        title: '选择流行元素',
                        items: PopularElementsEnum,
                        multiple: true,
                        codes: _popularElementsCodes,
                      ),
                ),
              );

              if (result != null) {
                _popularElementsText = '';
                for (int i = 0; i < result.length; i++) {
                  if (i == 4) {
                    _popularElementsText += '...';
                    break;
                  }

                  _popularElementsText += result[i].name;

                  if (i != result.length - 1) {
                    _popularElementsText += '、';
                  }
                }

                _popularElementsCodes = result.map((item) {
                  return item.code;
                }).toList();
              }
            },
            child: ShowSelectTile(
              leadingText: '流行元素',
              tralingText: _popularElementsText,
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
                        code: _fillerCode,
                      ),
                ),
              );
              _fillerText = result.name;
              _fillerCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '填充物',
              tralingText: _fillerText,
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
                        code: _thicknessCode,
                      ),
                ),
              );
              _thicknessText = result.name;
              _thicknessCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '厚薄',
              tralingText: _thicknessText,
              tralingTextColor: Colors.orange,
            ),
          ),
          InkWell(
            onTap: () async {
              dynamic result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnumSelectPage(
                      title: '选择季节', items: SeasonEnum, code: _seasonCode),
                ),
              );
              _seasonText = result.name;
              _fillerCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '季节',
              tralingText: _seasonText,
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
                          EnumModel('true', '有'),
                          EnumModel('false', '没有'),
                        ],
                        code: _taggableCode,
                      ),
                ),
              );
              _taggableText = result.name;
              _taggableCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '吊牌',
              tralingText: _taggableText,
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
                        code: _placketCode,
                      ),
                ),
              );
              _placketText = result.name;
              _placketCode = result.code;
            },
            child: ShowSelectTile(
              leadingText: '门襟',
              tralingText: _placketText,
              tralingTextColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
