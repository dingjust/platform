目前插件full_pdf_viewer_plugin  需在FlutterFullPdfViewerManager 添加 .enableAnnotationRendering(true) 支持印章显示。后续需重写pdf插件


pdfView.fromFile(new File(path))
                .defaultPage(0)
                .onPageChange(this)
                .enableAnnotationRendering(true) //印章显示
                .onLoad(this)
                .scrollHandle(new DefaultScrollHandle(this))
                .spacing(10)
                .onPageError(this)
                .load();