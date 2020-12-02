import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';

///TODO: 目前插件full_pdf_viewer_plugin  需在FlutterFullPdfViewerManager 添加 .enableAnnotationRendering(true) 支持印章显示。后续需重写pdf插件
class PDFReader extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final String path;
  final bool primary;
  double bottomHeight;

  PDFReader({
    Key key,
    this.appBar,
    @required this.path,
    this.primary = true,
    this.bottomHeight,
  }) : super(key: key);

  @override
  _PDFReaderState createState() => new _PDFReaderState();
}

class _PDFReaderState extends State<PDFReader> {
  final pdfViwerRef = new PDFViewerPlugin();
  Rect _rect;
  Timer _resizeTimer;
  double bottomHeight;

  @override
  void initState() {
    bottomHeight = widget.bottomHeight == null ? 150.0 : widget.bottomHeight;
    super.initState();
    pdfViwerRef.close();
  }

  @override
  void dispose() {
    super.dispose();
    pdfViwerRef.close();
    pdfViwerRef.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bottomHeight = widget.bottomHeight == null ? 150.0 : widget.bottomHeight;
    if (_rect == null) {
      _rect = _buildRect(context);
      pdfViwerRef.launch(
        widget.path,
        rect: _rect,
      );
    } else {
      final rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = new Timer(new Duration(milliseconds: 300), () {
          pdfViwerRef.resize(_rect);
        });
      }
    }
    return new Scaffold(
        appBar: widget.appBar,
        body: Container(
          // height: 500,
          child: const Center(child: const CircularProgressIndicator()),
        ));
  }

  Rect _buildRect(BuildContext context) {
    final fullscreen = widget.appBar == null;

    final mediaQuery = MediaQuery.of(context);
    final topPadding = widget.primary ? mediaQuery.padding.top : 0.0;
    final top =
        fullscreen ? 0.0 : widget.appBar.preferredSize.height + topPadding;
    var height = mediaQuery.size.height - top - bottomHeight;
    if (height < 0.0) {
      height = 0.0;
    }

    return new Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }
}
