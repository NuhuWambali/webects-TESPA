import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:ects/model/saledate.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';




class DatabaseHelperdd {
  static final DatabaseHelperdd instance = DatabaseHelperdd._privateConstructor();

  static Database? _database;

  DatabaseHelperdd._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ects123.db');
    return await openDatabase(path, version: 200, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {

    await db.execute(
        'CREATE TABLE Sales (id INTEGER PRIMARY KEY,    sale_date TEXT, start_date_time TEXT,end_date TEXT, vehicle_number TEXT,chasis_number TEXT,tzl TEXT,driver_name TEXT,border_id TEXT,driver_number TEXT,serial_no TEXT,amount TEXT,currency TEXT,gate_number TEXT,sales_person TEXT,passport TEXT,container_number TEXT,vehicle_type_id TEXT,customer_type_id TEXT,company_name TEXT,customer_id TEXT,agent TEXT,trip_status TEXT,sale_type TEXT,sale_id TEXT,trailerno TEXT,offline_receipt_number TEXT)');


  }

  Future saveSaleslocal(SaleAdd sale) async {
    Database db = await instance.database;

    try {
      print('Songs savingtosqlite ${sale}');
      var resp = await db.insert('Songs', sale.toJson());

      print(resp);
      print("savenewsavings");
      print(sale.toJson());
    } catch (e) {
      print("songserro");
      print(e);
    }

    // try {
    //   var resp = await db.insert('Songs', song.toMap());
    //   print(resp);
    //   print("not savings");
    // } catch (e) {
    //   print("songserro");
    //   print(e);
    // }





    // // Check if the row exists
    // List<Map<String, dynamic>> result = await db.rawQuery(
    //   'SELECT * FROM Songs WHERE mediaId = ?',
    //   [song.mediaId],
    // );
    //
    //
    // if (result.isNotEmpty) {
    //
    //
    //
    //   print('No songs Songs Existestes');
    //
    // }else{
    //
    //
    //
    //
    //
    // }


    // checkifdwonloaded(song.mediaId);



  }


  Future<List<Map<String, dynamic>>> getsales() async {
    Database db = await instance.database;
    return await db.query('Sales');
  }



 Future<bool> checkifdwonloaded(mediaId) async {
  Database db = await instance.database;


  // Check if the row exists
  List<Map<String, dynamic>> result = await db.rawQuery(
    'SELECT * FROM Sales WHERE mediaId = ?',
    [mediaId],
  );

  if (result.isNotEmpty) {
    print('Songs updated');
    log('${result}');
    return true;

  }else{
    print('Songsamna');
    log('uploaded zipo ${result}');
    print('No sales');

    return false;
  }





}

}
// bool downled = await DatabaseHelper.instance.checkifdwonloaded(widget.mediaModel.mediaId);
// if (downled) {
//
// apiController.downloaded.value= true;
//
// }  else{
// apiController.downloaded.value= false;
//
// }