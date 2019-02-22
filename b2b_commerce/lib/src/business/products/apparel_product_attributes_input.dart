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
  List<String> _styleCodes = [];
  List<String> _fabricCompositionCode = [];
  List<String> _editionTypeCode = [];
  List<String> _patternCode = [];
  List<String> _sleeveTypeCode = [];
  List<String> _sleeveLengthCode = [];
  List<String> _decorativePatternCodes = [];
  List<String> _popularElementsCodes = [];
  List<String> _fillerCode = [];
  List<String> _thicknessCode = [];
  List<String> _seasonCode = [];
  List<String> _taggableCode = [];
  List<String> _placketCode = [];

  @override
  void initState() {
    if (widget.item?.styles != null) _styleCodes.addAll(widget.item?.styles);
    if (widget.item?.decorativePattern != null)
      _decorativePatternCodes.addAll(widget.item?.decorativePattern);
    if (widget.item?.popularElements != null)
      _popularElementsCodes.addAll(widget.item?.popularElements);
    if (widget.item?.fabricComposition != null)
      _fabricCompositionCode.add(widget.item?.fabricComposition);
    if (widget.item?.editionType != null)
      _editionTypeCode.add(widget.item?.editionType);
    if (widget.item?.pattern != null) _patternCode.add(widget.item?.pattern);
    if (widget.item?.sleeveType != null)
      _sleeveTypeCode.add(widget.item?.sleeveType);
    if (widget.item?.sleeveLength != null)
      _sleeveLengthCode.add(widget.item?.sleeveLength);
    if (widget.item?.filler != null) _fillerCode.add(widget.item?.filler);
    if (widget.item?.thickness != null)
      _thicknessCode.add(widget.item?.thickness);
    if (widget.item?.season != null) _seasonCode.add(widget.item?.season);
    if (widget.item?.placket != null) _placketCode.add(widget.item?.placket);
    if (widget.item?.taggable != null)
      _taggableCode.add(widget.item?.taggable.toString());

    // TODO: implement initState
    super.initState();
  }

  //格式选中的枚举（多选）
  String formatSelectText(List<String> codes, List<EnumModel> enumModels) {
    String text = '';

    if (codes != null) {
      text = '';
      for (int i = 0; i < codes.length; i++) {
        if (i > 3) {
          text += '...';
          break;
        }

        if (i == codes.length - 1) {
          text += enumMap(enumModels, codes[i]);
        } else {
          text += enumMap(enumModels, codes[i]) + '、';
        }
      }
    }

    return text;
  }

  //格式选中的枚举（单选）
  String formatEnumSelectText(
      List<EnumModel> enumModels, List<String> enumCode) {
    String text = '';
    if (enumCode != null && enumCode.length > 0)
      text = enumMap(enumModels, enumCode[0]);
    return text;
  }

  Future<bool> _requestPop() {
    ApparelProductAttributesModel attributesModel =
        ApparelProductAttributesModel(
      styles: _styleCodes,
      fabricComposition:
          _fabricCompositionCode.length > 0 ? _fabricCompositionCode[0] : null,
      editionType: _editionTypeCode.length > 0 ? _editionTypeCode[0] : null,
      pattern: _patternCode.length > 0 ? _patternCode[0] : null,
      placket: _placketCode.length > 0 ? _placketCode[0] : null,
      sleeveType: _sleeveTypeCode.length > 0 ? _sleeveTypeCode[0] : null,
      sleeveLength: _sleeveLengthCode.length > 0 ? _sleeveLengthCode[0] : null,
      season: _seasonCode.length > 0 ? _seasonCode[0] : null,
      thickness: _thicknessCode.length > 0 ? _thicknessCode[0] : null,
      popularElements: _popularElementsCodes,
      decorativePattern: _decorativePatternCodes,
      filler: _fillerCode.length > 0 ? _fillerCode[0] : null,
      taggable:
          _taggableCode.length > 0 ? _taggableCode.contains('true') : null,
    );
    Navigator.pop(context, attributesModel);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //监听左上角返回和实体返回
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('属性'),
        ),
        body: ListView(
          children: <Widget>[
            InkWell(
              onTap: () async {
                dynamic result = await Navigator.push(
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
                  _styleCodes = result;
                }
              },
              child: ShowSelectTile(
                leadingText: '风格',
                tralingText: formatSelectText(_styleCodes, StyleEnum),
                tralingTextColor: Colors.orange,
              ),
            ),
            InkWell(
              onTap: () async {
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          title: '选择面料',
                          items: FabricCompositionEnum,
                          codes: _fabricCompositionCode,
                        ),
                  ),
                );

                if (result != null) _fabricCompositionCode = result;
              },
              child: ShowSelectTile(
                leadingText: '面料',
                tralingText: formatEnumSelectText(
                  FabricCompositionEnum,
                  _fabricCompositionCode,
                ),
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
                          codes: _editionTypeCode,
                        ),
                  ),
                );

                if (result != null) _editionTypeCode = result;
              },
              child: ShowSelectTile(
                leadingText: '版型',
                tralingText:
                    formatEnumSelectText(EditionTypeEnum, _editionTypeCode),
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
                          codes: _patternCode,
                        ),
                  ),
                );

                if (result != null) _patternCode = result;
              },
              child: ShowSelectTile(
                leadingText: '款式',
                tralingText: formatEnumSelectText(PatternEnum, _patternCode),
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
                          codes: _sleeveTypeCode,
                        ),
                  ),
                );

                if (result != null) _sleeveTypeCode = result;
              },
              child: ShowSelectTile(
                leadingText: '袖型',
                tralingText:
                    formatEnumSelectText(SleeveTypeEnum, _sleeveTypeCode),
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
                          codes: _sleeveLengthCode,
                        ),
                  ),
                );

                if (result != null) _sleeveLengthCode = result;
              },
              child: ShowSelectTile(
                leadingText: '袖长/裤长',
                tralingText:
                    formatEnumSelectText(SleeveLengthEnum, _sleeveLengthCode),
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
                          codes: _decorativePatternCodes,
                        ),
                  ),
                );

                if (result != null) _decorativePatternCodes = result;
              },
              child: ShowSelectTile(
                leadingText: '图案',
                tralingText: formatSelectText(
                    _decorativePatternCodes, DecorativePatternEnum),
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
                          codes: _popularElementsCodes,
                        ),
                  ),
                );

                if (result != null) _popularElementsCodes = result;
              },
              child: ShowSelectTile(
                leadingText: '流行元素',
                tralingText: formatSelectText(
                    _popularElementsCodes, PopularElementsEnum),
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
                          codes: _fillerCode,
                        ),
                  ),
                );

                if (result != null) _fillerCode = result;
              },
              child: ShowSelectTile(
                leadingText: '填充物',
                tralingText: formatEnumSelectText(FillerEnum, _fillerCode),
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
                          codes: _thicknessCode,
                        ),
                  ),
                );

                if (result != null) _thicknessCode = result;
              },
              child: ShowSelectTile(
                leadingText: '厚薄',
                tralingText:
                    formatEnumSelectText(ThicknessEnum, _thicknessCode),
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
                          codes: _seasonCode,
                        ),
                  ),
                );

                if (result != null) _seasonCode = result;
              },
              child: ShowSelectTile(
                leadingText: '季节',
                tralingText: formatEnumSelectText(SeasonEnum, _seasonCode),
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
                          codes: _taggableCode,
                        ),
                  ),
                );

                if (result != null) _taggableCode = result;
              },
              child: ShowSelectTile(
                leadingText: '吊牌',
                tralingText: formatEnumSelectText(<EnumModel>[
                  EnumModel('true', '有'),
                  EnumModel('false', '没有'),
                ], _taggableCode),
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
                          codes: _placketCode,
                        ),
                  ),
                );

                if (result != null) _placketCode = result;
              },
              child: ShowSelectTile(
                leadingText: '门襟',
                tralingText: formatEnumSelectText(PlacketEnum, _placketCode),
                tralingTextColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
