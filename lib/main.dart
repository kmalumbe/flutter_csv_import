import 'dart:io';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grizzly_io/io_loader.dart';
import 'BatchModel.dart';
import 'Controller.dart';
import 'package:grizzly_io/grizzly_io.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  List<List<String>> csvPreviewList = [];
  List<Batch> batchList = [];
  List<Batch> selectedBatches = [];
  List<Batch> allBatchesList = [];
  bool _showEditBatch = false;
  final Controller controller = Get.put(Controller());
  bool _sort = false;
  int _columnIndex = 0;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  void onSortColumn(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          // allBatchesList.sort((a, b) => a.feenoteid.compareTo(b.feenoteid));
        } else {
          // allBatchesList.sort((a, b) => b.feenoteid.compareTo(a.feenoteid));
        }
        break;
      case 1:
        if (ascending) {
          // allBatchesList.sort((a, b) => a.clientname.compareTo(b.clientname));
        } else {
          // allBatchesList.sort((a, b) => b.clientname.compareTo(a.clientname));
        }
        break;
      case 2:
        if (ascending) {
          // allBatchesList.sort((a, b) => a.caseId.compareTo(b.caseId));
        } else {
          // allBatchesList.sort((a, b) => b.caseId.compareTo(a.caseId));
        }
        break;
      case 3:
        if (ascending) {
          // allBatchesList.sort((a, b) => a.dateissued.compareTo(b.dateissued));
        } else {
          // allBatchesList.sort((a, b) => b.dateissued.compareTo(a.dateissued));
        }
        break;
    }
  }

  void onSelectedRow(bool selected, {Batch batch}) async {
    setState(() {
      selected ? selected = false : selected = true;
      print('Selected after negation:$selected');
      !selectedBatches.contains(batch)
          ? selectedBatches.add(batch)
          : selectedBatches.remove(batch);
      // print('Selected after negation:$selected');
      selectedBatches.length == 1
          ? _showEditBatch = true
          : _showEditBatch = false;
    });
  }
  @override
  void initState() {
    controller.fetchBatches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(color: Colors.blue),),
        backgroundColor: Colors.white,
        elevation: 4,
        actions: [
          if(selectedFiles.length==1)
            Obx(()=>Container(
              margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
              child: FlatButton.icon(
                color: Colors.blue,
                onPressed: () async {
                  String result = await controller.uploadFile(
                    file: selectedFiles.first.csv,
                    id: selectedFiles.first.csv.path,
                  );
                  if(result!=null)
                    Get.snackbar(result.toUpperCase(), '',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.grey.withOpacity(0.4),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      // titleText: Text(result.toUpperCase()),
                    );
                },
                icon: controller.loading.value ? CircularProgressIndicator(backgroundColor: Colors.white,) :Icon(Icons.add,color: Colors.white,),
                height: 50,
                label: Text('Import into database',style: TextStyle(color: Colors.white),),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
            child: FlatButton.icon(
              color: Colors.blue,
              onPressed: () async {
                final file = OpenFilePicker()
                  ..filterSpecification = {
                    'CSV Files': '*csv',
                  }
                  ..defaultFilterIndex = 0
                  ..defaultExtension = 'csv'
                  ..title = 'Select a document';
                final result = file.getFile();
                CSV csv = CSV(csv: result,title: result.path,isChecked: true);
                if (result != null) {
                  setState(() {
                    csvFiles.add(csv);
                  });
                }
                Get.defaultDialog(
                  title: 'Import the following records?',
                  content: GFCheckboxListTile(
                    value: csv.isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        // csv.isChecked = value;
                        // csv.isChecked ? selectedFiles.add(csv) : selectedFiles.remove(csv);
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
                  ),
                  textConfirm: 'Import',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  barrierDismissible: false,
                  onConfirm: ()async{
                    Get.back();
                    String result = await controller.uploadFile(
                      file: csv.csv,
                      id: csv.csv.path,
                    );
                    if(result!=null){
                      // GFToast(text: result.toUpperCase(),);
                      Get.snackbar(result.toUpperCase(), '',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.grey.withOpacity(0.4),
                        margin: EdgeInsets.symmetric(vertical: 20),
                        // padding: EdgeInsets.symmetric(horizontal: 20),
                        // titleText: Text(result.toUpperCase()),
                      );
                    }
                    controller.fetchBatches();
                  },
                  onCancel: ()=>Get.back(),

                );
              },
              icon: Icon(Icons.add,color: Colors.white,),
              height: 50,
              label: Text('Add CSV file',style: TextStyle(color: Colors.white),),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],

      ),
      body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: Obx(()=> controller.loading.value ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RefreshProgressIndicator(),
                SizedBox(height: 20,),
                Text('Loading...'),
              ],
            ) : PaginatedDataTable(
                headingRowHeight: 30,
                columnSpacing: 30,
                sortAscending: _sort,
                sortColumnIndex: _columnIndex,
                columns: [
                  DataColumn(
                      label: Text(
                        'Batch ID',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _columnIndex = 0;
                          _sort = !_sort;
                        });
                        onSortColumn(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Item Id'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _columnIndex = 1;
                          _sort = !_sort;
                        });
                        onSortColumn(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Batch Number'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _columnIndex = 2;
                          _sort = !_sort;
                        });
                        onSortColumn(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Expiry date'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _columnIndex = 3;
                          _sort = !_sort;
                        });
                        onSortColumn(columnIndex, ascending);
                      }),
                  DataColumn(
                    label: Text('Quantity received'),
                  ),
                  DataColumn(
                    label: Text(
                      'Balance',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                  DataColumn(
                    label: Text('Deleted'),
                  ),
                  DataColumn(
                    label: Text('Date Created'),
                  ),
                ],
                header: Text('Batches'),
                source: DTS(
                  rowsCount: allBatchesList.length,
                  batchList: allBatchesList,
                  selectedBatches: selectedBatches,
                  onSelectRow: (bool selected,
                      {Batch batch}) {
                    setState(() {
                      onSelectedRow(selected, batch: batch);
                    });
                  },
                ),
                onRowsPerPageChanged: (rows) {
                  setState(() {
                    _rowsPerPage = rows;
                  });
                  print('ROWS PER PAGE: $rows');
                },
                rowsPerPage: _rowsPerPage,
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      selectedBatches.clear();
                      await controller.fetchBatches();
                      setState(() {
                        allBatchesList = controller.batchList;
                      });
                    },
                  )
                ],
          ),
            ),
      ),
    )
    );
  }
}

class DTS extends DataTableSource {
  final int rowsCount;
  bool selected;
  void Function(bool selected, {Batch batch}) onSelectRow;
  List<Batch> batchList = [];
  List<Batch> selectedBatches = [];
  double _dataFontSize = 12;
  DTS(
      {@required this.rowsCount,
        this.selected = false,
        @required this.onSelectRow,
        @required this.selectedBatches,
        @required this.batchList});

  @override
  DataRow getRow(int index) {
    final batch = batchList[index];
    return DataRow.byIndex(
        index: index,
        selected: selectedBatches.contains(batch),
        onSelectChanged: (__) => onSelectRow(selected, batch: batch),
        cells: [
          DataCell(
              Text(
                batch.idbatchNumbers.toString(),
                style: TextStyle(fontSize: _dataFontSize),
              ),
              onTap: () {}),
          //Client name
          DataCell(
              Text(
                batch.idItem.toString(),
                style: TextStyle(fontSize: _dataFontSize),
              ),
              onTap: () {}),
          //Case Title
          DataCell(
            Text(
              batch.batchNum.toString(),
              style: TextStyle(fontSize: _dataFontSize),
            ),
            onTap: () {},
          ),
          //Date issued
          DataCell(
            Text(
              batch.dateExpiry.toString().substring(0, 10),
              style: TextStyle(fontSize: _dataFontSize),
            ),
            onTap: () {},
          ),
          //Quantity
          DataCell(
            Text(batch.qtyReceived.toString(),
              style: TextStyle(fontSize: _dataFontSize),
            ),
            onTap: () {},
          ),
          //Balance
          DataCell(
            Text(batch.balance.toString(),
              style: TextStyle(fontSize: _dataFontSize),
            ),
            onTap: () {},
          ),

          //Status
          DataCell(
            Text(
              batch.status.toString(),
              style: TextStyle(fontSize: _dataFontSize),
            ),
            onTap: () {},
          ),
          //Details
          DataCell(Text(batch.deleted == '0'?'false':'true')),
          DataCell(Text(batch.dateCreated.toString().substring(0,19))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rowsCount;

  @override
  int get selectedRowCount => selectedBatches.length;
}


class CSV{
  final String title;
  final String shortDescription;
  bool isChecked;
  final File csv;

  CSV({@required this.title, this.shortDescription, this.isChecked=false,@required this.csv});
}