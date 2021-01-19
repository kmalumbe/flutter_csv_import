import 'dart:convert';
import 'dart:io';
import 'package:flutter_csv_import/BatchModel.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class Api {
  // String ROOT = "https://legal-manager-test.000webhostapp.com";
  static String ROOT = "http://34.123.83.77/logistixpro";
  static String _uri = "$ROOT/csv_import.php";
  Future<String> uploadCsvFile(
      {@required File file, @required String id}) async {
    print('Uploading file...');
    String result;
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    final url = Uri.parse(_uri);
    var request = http.MultipartRequest('POST', url);
    request.fields['action'] = 'UPLOAD_CSV';
    request.fields['id'] = id;
    print('File path: ${basename(id)}');
    var multiPartFile =
        http.MultipartFile("file", stream, length, filename: basename(id));
    request.files.add(multiPartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      result = await response.stream.transform(utf8.decoder).join();
      print('$result');
      return result;
    } else {
      print('error');
    }
  }

  Future<List<Batch>> getBatches() async {
    print("loading batches");
    try {
      final response = await http.post(
        Uri.encodeFull(_uri),
        headers: {"Accept": "application/json"},
        body: {
          'action': 'GET_ALL_BATCH_NUMBERS',
        },
      );
      if (response.statusCode == 200) {
        print("response batch: true");
        List<Batch> batchList = batchFromJson(response.body);
        // feenoteList.sort((a, b) => b.feenoteid.toString().compareTo(a.feenoteid.toString()));
        return batchList;
      } else {
        return List<Batch>();
      }
    } on Exception catch (e) {
      print(e);
      return List<Batch>();
    }
  }
}
