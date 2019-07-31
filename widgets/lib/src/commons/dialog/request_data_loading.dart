import 'package:flutter/material.dart';
import 'package:services/services.dart';

class RequestDataLoading extends StatefulWidget {
  final bool loading;
  Function dismissCallback;
  String loadingText;
  bool outsideDismiss;
  Future<dynamic> requestCallBack;
  bool callbackResult;
  Future<void> callbackExecution;
  String entrance;
  String keyword;
  String Function() onPress;

  RequestDataLoading({
    Key key,
    this.loading,
    this.loadingText = "loading...",
    this.outsideDismiss = true,
    this.dismissCallback,
    @required this.requestCallBack,
    this.callbackResult,
    this.callbackExecution,
    @required this.entrance,
    this.keyword,
  }) : super(key: key);

  @override
  _RequestDataLoadingPageState createState() => _RequestDataLoadingPageState();
}

class _RequestDataLoadingPageState extends State<RequestDataLoading> {
  _dismissDialog() {
    if (widget.dismissCallback != null) {
      widget.dismissCallback();
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  doRequestData() {
    if (widget.requestCallBack != null) {
      widget.requestCallBack.then((value) {
        Navigator.of(context).pop(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MessageBLoC.instance.errorMessageStream.listen((value) {
      Navigator.of(context).pop();
    });


    if (widget.requestCallBack != null) {
      widget.requestCallBack.then((value) async {
        Navigator.of(context).pop(value);
      });
      // .timeout(Duration(seconds: 5))
      // .then((v) {
      //   print('1======================!!!!');
      //   Navigator.of(context).pop();
      // })
      // .catchError((e) {
      //   print('2======================!!!!');
      //   Navigator.of(context).pop();
      // });
    }
    return GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 120.0,
            height: 120.0,
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Text(
                      widget.loadingText,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingUtil {
  static Future loadingDialog(BuildContext context, Future future,
      String loadingText, String entrance) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: future,
            outsideDismiss: false,
            loadingText: loadingText,
            entrance: entrance,
          );
        });
  }
}
