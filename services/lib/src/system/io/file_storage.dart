import 'dart:async';
import 'dart:io';

abstract class AbstractFileStorage {
  final String tag;
  final Future<Directory> Function() getDirectory;

  const AbstractFileStorage(
    this.tag,
    this.getDirectory,
  );

  Future<List<dynamic>> load();

  Future<File> save(List<dynamic> models);

  Future<File> getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/HybrisStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await getLocalFile();

    return file.delete();
  }
}
