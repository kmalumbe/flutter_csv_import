import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_csv_import/ApiService.dart';
import 'package:get/get.dart';

class Controller extends GetxController{
  final Api api = Get.put(Api());
  var loading = false.obs;

  Future<String> uploadFile({@required File file,@required String id})async{
    loading(true);
      String result = await api.uploadCsvFile(file: file, id: id);
    loading(false);
      return result;
  }
}