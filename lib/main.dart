import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/getwidget.dart';

import 'Controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter CSV import',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter CSV import'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CSV> csvFiles = [];
  List<CSV> selectedFiles = [];
  final Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 3,
        actions: [

        ],
      ),
      body: Container(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: csvFiles.isEmpty ? Text('No CSV files'.toUpperCase())
                      : ListView.builder(
                      itemCount: csvFiles.length,
                      itemBuilder: (context,index){
                        CSV csv = csvFiles[index];
                        return GFCheckboxListTile(
                          value: csv.isChecked,
                          onChanged: (bool value) {
                            setState(() {
                              csv.isChecked = value;
                              csv.isChecked ? selectedFiles.add(csv) : selectedFiles.remove(csv);
                            });
                          },
                          titleText: csv.title,
                          subtitleText: csv.shortDescription??null,
                          avatar: GFAvatar(
                            child: Text('CSV'),
                          ),
                          activeBgColor: Colors.blue,
                          type: GFCheckboxType.circle,
                          activeIcon: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                          inactiveIcon: null,
                        );
                      }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton.icon(
                      color: Colors.blue,
                      onPressed: () async {
                        final file = OpenFilePicker()
                          ..filterSpecification = {
                            'CSV Files': '*csv',
                            'All Files': '*,*',
                          }
                          ..defaultFilterIndex = 0
                          ..defaultExtension = 'csv'
                          ..title = 'Select a document';
                        final result = file.getFile();
                        if (result != null) {
                          setState(() {
                            csvFiles.add(CSV(csv: result,title: result.path,));
                          });
                        }
                      },
                      icon: Icon(Icons.add,color: Colors.white,),
                      height: 50,
                      label: Text('Add CSV file',style: TextStyle(color: Colors.white),),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    if(selectedFiles.length==1) SizedBox(width: 40,),
                    if(selectedFiles.length==1)
                      Obx(()=>FlatButton.icon(
                        color: Colors.blue,
                        onPressed: () async {
                          await controller.uploadFile(
                              file: selectedFiles.first.csv,
                              id: selectedFiles.first.csv.path,
                          );
                        },
                        icon: controller.loading.value ? CircularProgressIndicator(backgroundColor: Colors.white,) :Icon(Icons.add,color: Colors.white,),
                        height: 50,
                        label: Text('Import into database',style: TextStyle(color: Colors.white),),
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
      ),
    );
  }
}

class CSV{
  final String title;
  final String shortDescription;
  bool isChecked;
  final File csv;

  CSV({@required this.title, this.shortDescription, this.isChecked=false,@required this.csv});
}