import 'package:flutter/material.dart';

class SearchAppbarTitle extends StatelessWidget {
  final TextEditingController controller;

  final FocusNode focusNode;

  final VoidCallback onSearch;

  final ValueChanged<String> onChange;

  final String hintText;

  const SearchAppbarTitle(
      {Key key,
      this.controller,
      this.focusNode,
      this.onSearch,
      this.hintText = '请输入单号，产品名称...',
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth,
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300], width: 0.5),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: constraints.maxWidth,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: '$hintText',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  contentPadding: EdgeInsets.all(0),
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (onChange != null) {
                                    onChange(value);
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  controller.text = '';
                                  onChange('');
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            )),
        Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          width: 70,
          height: 32,
          child: FlatButton(
              child: Text(
                '搜索',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () async {
                focusNode.unfocus();
                if (onSearch != null) {
                  this.onSearch();
                }
              }),
        ),
      ],
    );
  }
}
