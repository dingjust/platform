import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class MultipartFileUpload {
  final StreamController _multiFileUploadController =
      StreamController<List<double>>.broadcast();

  Future<void> multipartFileUpload(
      List<File> files, List<MediaModel> medias, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            StreamBuilder<List<double>>(
                stream: _multiFileUploadController.stream,
                initialData: [0, 0, 0, 0, 0],
                builder: (BuildContext context,
                    AsyncSnapshot<List<double>> snapshot) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Column(
                      children: files
                          .map((file) => Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      '文件${file.path}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Center(
                                    child: LinearProgressIndicator(
                                      value: snapshot.data[files.indexOf(file)],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('进度:',
                                          style: TextStyle(fontSize: 12)),
                                      Text(
                                          '${((snapshot.data[files.indexOf(file)] / 1) * 100).round()}%',
                                          style: TextStyle(fontSize: 12))
                                    ],
                                  )
                                ],
                              ))
                          .toList(),
                    ),
                  );
                })
          ],
        );
      },
    );

    try {
      List<double> progress = [0, 0, 0, 0, 0];
      for (int i = 0; i < files.length; i++) {
        // FormData formData =
        //     FormData.fromFile({"file": MultipartFile(files[i], "file")});
        //           FormData formData = FormData.fromMap({
        // "file":MultipartFile.fromFile(files[i].path,filename: "file"),
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(files[i].path, filename: "file")
        });
        Response<Map<String, dynamic>> response = await http$.post(
          Apis.upload(),
          data: formData,
          queryParameters: {'conversionGroup': 'DefaultProductConversionGroup'},
          options: Options(
            headers: {'Content-Type': 'multipart/form-data'},
          ),
          onSendProgress: (int sent, int total) {
            progress[i] = sent / total;
            _multiFileUploadController.sink.add(progress);
          },
        );
        if (response != null && response.statusCode == 200) {
          medias.add(MediaModel.fromJson(response.data));
        }
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }
}
