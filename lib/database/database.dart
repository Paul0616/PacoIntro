import 'dart:io';

import 'package:pacointro/models/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static final String tableProducts = 'Products';
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "paco.db");
    return await openDatabase(
      path,
      version: 6,
      onOpen: (db) {},
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableProducts ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "code INTEGER,"
        "name TEXT,"
        "measureUnit TEXT,"
        "quantity REAL DEFAULT 0,"
        "productType BIT,"
        "belongsToOrder BIT,"
        "createdAt INTEGER"
        ")");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE IF EXISTS $tableProducts;");
      await _onCreate(db, newVersion);
    }
  }

  Future close() async => _database.close();

  //PRODUCTS---------------------------------------
  Future<int> insertProduct(
      ProductModel product, ProductType productType) async {
    final db = await database;
    var raw = await db.insert(
        tableProducts, product.toDatabaseMap(productType: productType),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<int> insertBulkProduct(
      List<ProductModel> products, ProductType productType) async {
    final db = await database;
    int count = 0;
    for (ProductModel product in products) {
//      if(await checkProduct(code: product.id, productType: true))
//        await deleteProductsByOrderType()
      //int deleted = await deleteProduct(code: product.id, productType: ProductType.ORDER);
      product.belongsToOrder = true;
      product.createdAt = DateTime.now().millisecondsSinceEpoch;
      var raw = await db.insert(
          tableProducts, product.toDatabaseMap(productType: productType),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (raw > 0) count++;
    }
    return count;
  }

  Future<int> getCountProductsByOrderType({ProductType productType}) async {
    final db = await database;
    var res = await db.query(tableProducts,
        where: "productType = ? ",
        whereArgs: [(productType == ProductType.ORDER ? 1 : 0)]);
    return res.length;
  }

  Future<List<ProductModel>> getProductsByOrderType(
      {ProductType productType}) async {
    final db = await database;
    var res = await db.query(tableProducts,
        where: "productType = ? ",
        whereArgs: [(productType == ProductType.ORDER ? 1 : 0)],
        orderBy: "name");
    List<ProductModel> list = res.isNotEmpty
        ? res.map((product) => ProductModel.fromDatabase(product)).toList()
        : [];
    return list;
  }

  Future<List<ProductModel>> getProductsByBarcode(
      {int code, ProductType productType}) async {
    final db = await database;
    var res = await db.query(tableProducts,
        where: "code = ? AND productType = ?",
        whereArgs: [code, (productType == ProductType.ORDER ? 1 : 0)]);
    List<ProductModel> list = res.isNotEmpty
        ? res.map((product) => ProductModel.fromDatabase(product)).toList()
        : [];
    return list;
  }

  Future<bool> checkProduct({int code, ProductType productType}) async {
    final db = await database;
    var res = await db.query(tableProducts,
        where: "code = ? AND productType = ?",
        whereArgs: [code, (productType == ProductType.ORDER ? 1 : 0)]);
    return res.isNotEmpty;
  }

  Future<int> deleteProductById({int id}) async {
    final db = await database;
    return await db.delete(tableProducts,
        where: "id = ?",
        whereArgs: [id]);
  }

  Future<int> deleteProductsByOrderType({ProductType productType}) async {
    final db = await database;
    return await db.delete(tableProducts,
        where: "productType = ?",
        whereArgs: [(productType == ProductType.ORDER ? 1 : 0)]);
  }

  Future<int> deleteAllFromTable() async {
    final db = await database;
    return await db.rawDelete("DELETE FROM $tableProducts");
  }

  updateScannedQuantity({ProductModel product}) async {
    final db = await database;
    var res = await db.update(tableProducts,
        product.toDatabaseMap(productType: ProductType.RECEPTION),
        where: "code = ? AND productType = ?", whereArgs: [product.code, 0]);
    return res;
  }
}

enum ProductType { ORDER, RECEPTION }
