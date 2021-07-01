# b2b_commerce

A new Flutter project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


<!-- ## 打开Andorid，找flutter_webview_plugin包，路径：android:src/main/java/com/flutter_webview_plugin/WebviewManage.java
## 把当前readme目录下的overwrite_webview文件内容覆盖到WebviewManage.java里，重新启动APP -->



flutter_webview_plugin 中的 FileProvider  合并清单时冲突，对应fileprovider 报空指针。
解决:继承重写FileProvider，修改WebviewManage 的引用。

FlutterWebviewFileProvider.java   详见：./overwrite_webview-20200815.calss

WebviewManager.java 修改 .fileprovider  => .flutter_webview_fileprovider

AndroidManifest.xml  :

android:name="androidx.core.content.FileProvider"
android:authorities="${applicationId}.fileprovider"


修改=>

android:name=".FlutterWebviewFileProvider"
android:authorities="${applicationId}.flutter_webview_fileprovider"

flutter_qr_reader   与 qr_code_scanner 依赖重复,  其中flutter_qr_reader OpenCameraInterface类需重写类名(CustomOpenCameraInterface)
