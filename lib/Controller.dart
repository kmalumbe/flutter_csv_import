import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_csv_import/ApiService.dart';
import 'package:get/get.dart';

import 'BatchModel.dart';

class Controller extends GetxController{
  final Api api = Get.put(Api());
  var loading = false.obs;
  List<Batch> batchList = [];
  Future<String> uploadFile({@required File file,@required String id})async{
    loading(true);
      String result = await api.uploadCsvFile(file: file, id: id);
    loading(false);
      return result;
  }

  Future<List<Batch>> fetchBatches() async {
    loading(true);
    batchList = await api.getBatches();
    if (batchList != null){
      loading(false);
      return batchList;
    }
    loading(false);

  }
}