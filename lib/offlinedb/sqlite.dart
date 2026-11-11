import 'dart:developer';

import 'package:ects/model/saledate.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../controller/controllerconstant.dart';
import '../model/device.dart';

class DatabaseHelper {
  static Database? _database;
  static const String salesTable = 'Sales';
  static const String slavesTable = 'Slaves';

  static const String mastdTable = 'Masterdevice';
  static const String slaveDTable = 'Slavedevice';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'ects555_database.db');

    return await openDatabase(
      path,
      version: 203,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $salesTable (id INTEGER PRIMARY KEY,    sale_date TEXT, start_date_time TEXT,end_date TEXT, vehicle_number TEXT,chasis_number TEXT,tzl TEXT,driver_name TEXT,border_id TEXT,driver_number TEXT,serial_no TEXT,amount TEXT,currency TEXT,gate_number TEXT,sales_person TEXT,passport TEXT,container_number TEXT,vehicle_type_id TEXT,customer_type_id TEXT,company_name TEXT,customer_id TEXT,agent TEXT,trip_status TEXT,sale_type TEXT,sale_id TEXT,trailerno TEXT, receipt_number TEXT, offline_receipt_number TEXT,prev_offline_receipt_number TEXT,borderName TEXT,gateName TEXT,tagger TEXT)');
        await db.execute('''
          CREATE TABLE $slavesTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            saleId INTEGER,
            serial_no TEXT,
            FOREIGN KEY (saleId) REFERENCES $salesTable (id)
          )
        ''');


        await db.execute(
            'CREATE TABLE $mastdTable (idi INTEGER PRIMARY KEY, id INTEGER, serial_no TEXT,selected INTEGER)');

        await db.execute(
            'CREATE TABLE $slaveDTable (idi INTEGER PRIMARY KEY, id INTEGER, serial_no TEXT,selected INTEGER)');
      },
    );
  }

  Future<int> insertSale(SaleAdd sale) async {
    final db = await database;
    final id = await db.insert(salesTable, sale.toMap());
    log("Sale  ${sale.toJson()}");

    // Insert slaves
    for ( Slave slave in sale.slaves??[]) {

      slave.saleId = id;
      print("Slave ${slave.toMap()}");
      await db.insert(slavesTable, slave.toMap());
    }

    apiController.salead.value = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);

    await updateMaster(sale.serialNo,1 );
    for (Slave slave  in sale.slaves??[]) {
      await updateSlave(slave.serialNo,1 );
    }

    return id;
  }



  Future<int> insertMaster(DeviceElement sale) async {
    final db = await database;

    print("delectedmaster");
    final id = await db.insert(mastdTable, sale.toJson());
    log("Sale  ${sale.toJson()}");

    return id;
  }


  Future<int> insertSlave(DeviceElement sale) async {
    final db = await database;
    // await db.delete( slaveDTable);

    print("delectedslave");
    final id = await db.insert(slaveDTable, sale.toJson());
    log("Sale  ${sale.toJson()}");

    return id;
  }


  Future<void> deletemasterAllRows() async {
    final db = await database;
    // Delete all rows from the table
    await db.delete(mastdTable);

    // Close the database
    // await db.close();
  }

  Future<void> deleteslaveAllRows() async {
    final db = await database;
    // Delete all rows from the table
    await db.delete(slaveDTable);

    // Close the database
    // await db.close();
  }


  Future<int> updateMaster(serialNo,selected,) async {
    final db = await database;

    Map<String, dynamic> updateDate ={'serial_no': serialNo,'selected':selected};

    return await db.update(
      mastdTable,
      updateDate,
      where: 'serial_no = ?',
      whereArgs: [serialNo],
    );
  }

  Future<int> updateSlave(serialNo,selected,) async {
    final db = await database;

    Map<String, dynamic> updateDate ={'serial_no': serialNo,'selected':selected};

    return await db.update(
      slaveDTable,
      updateDate,
      where: 'serial_no = ?',
      whereArgs: [serialNo],
    );
  }



  // sale_id TEXT,trailerno TEXT, receipt_number TEXT
  Future<int> updateSales(String saleId,String receiptnumber, String tzl,) async {
    final db = await database;

    Map<String, dynamic> updateDate ={'sale_id': saleId,'receipt_number': receiptnumber};


    //
    // return  await db.rawUpdate(
    //     'UPDATE $salesTable SET sale_id = ?, receipt_number = ? WHERE sale_id = ${saleId}',
    //     [saleId,receiptnumber]);


    return await db.update(
      salesTable,
      updateDate,
      where: 'tzl = ?',
      whereArgs: [tzl],
    );
  }


  Future<List<Map<String, dynamic>>> getSalesWithSlaves() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM $salesTable
      LEFT JOIN $slavesTable ON $salesTable.id = $slavesTable.saleId
    ''');
  }



  Future<List<DeviceElement>> getmaster(int selected) async {
    final db = await database;

    final List<Map<String, dynamic>> saleMaps = await db.query(mastdTable,
      where: 'selected = ?',
      whereArgs: [selected],);
    final List<DeviceElement> sales = [];

    for (var saleMap in saleMaps) {
      final sale = DeviceElement.fromJson(saleMap);



      sales.add(sale);
    }
    return sales;
  }


  Future<List<DeviceElement>> getSlaved(int selected) async {
    final db = await database;

    final List<Map<String, dynamic>> saleMaps = await db.query(slaveDTable,
      where: 'selected = ?',
      whereArgs: [selected],);
    final List<DeviceElement> sales = [];

    for (var saleMap in saleMaps) {
      final sale = DeviceElement.fromJson(saleMap);



      sales.add(sale);
    }
    return sales;
  }

  Future<List<SaleAdd>> getSales() async {
    final db = await database;

    final List<Map<String, dynamic>> saleMaps = await db.query(salesTable);
    final List<SaleAdd> sales = [];

    for (var saleMap in saleMaps) {
      final sale = SaleAdd.fromJson(saleMap);

       List<Slave> slaves=[];

      if (sale.id!=null) {
        slaves = await getSlaves(sale.id??0);
        // sale.slaves = slaves;
        // sales.add(sale);

      }else{
        slaves = [];

        }
      sale.slaves = slaves;
      sales.add(sale);
    }

    return sales;
  }


  Future<List<Slave>> getSlaves(int saleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      slavesTable,
      where: 'saleId = ?',
      whereArgs: [saleId],
    );

    return List.generate(maps.length, (i) {
      return Slave.fromJson(maps[i]);
    });
  }




  Future<bool> doesDataExist(String tzl) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      salesTable,
      where: 'tzl = ?',
      whereArgs: [tzl],
    );
    return result.isNotEmpty;
  }
}


  // Future<List<SaleAdd>> getSales() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> saleMaps = await db.query(salesTable);
  //
  //   return List.generate(saleMaps.length, (i) {
  //     final sale = SaleAdd.fromJson(saleMaps[i]);
  //
  //     // Retrieve related slaves
  //     final List<Map<String, dynamic>> slaveMaps =   await db.rawQuery(
  //       'SELECT * FROM $slavesTable WHERE saleId = ?',
  //       [sale.id],
  //     );
  //
  //     sale.slaves = List.generate(slaveMaps.length, (j) {
  //       return Slave.fromJson(slaveMaps[j]);
  //     });
  //
  //     return sale;
  //   });
  // }

