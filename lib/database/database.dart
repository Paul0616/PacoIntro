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
      version: 1,
      onOpen: (db) {},
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableProducts ("
        "id TEXT PRIMARY KEY,"
        "code INTEGER,"
        "name TEXT,"
        "measureUnit TEXT,"
        "quantity REAL DEFAULT 0,"
        "isInOrder BIT DEFAULT 0,"
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
  Future<int> insertProduct(ProductModel product, bool isInOrder) async {
    final db = await database;
    var raw = await db.insert(tableProducts, product.toDatabaseMap(isInOrder),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<int> insertBulkProduct(
      List<ProductModel> products, bool isInOrder) async {
    final db = await database;
    int count = 0;
    for (ProductModel product in products) {
//      if(await checkProduct(code: product.id, isInOrder: true))
//        await deleteProductsByOrderType()
      int deleted = await deleteProduct(code: product.id, isInOrder: true);
      var raw = await db.insert(tableProducts, product.toDatabaseMap(isInOrder),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (raw > 0) count++;
    }
    return count;
  }

  Future<int> getCountProductsByOrderType({bool isInOrder}) async {
    final db = await database;
    var res = await db.query(tableProducts,
        where: "isInOrder = ? ", whereArgs: [(isInOrder ? 1 : 0)]);
    return res.length;
  }

  Future<List<ProductModel>> getProductsByOrderType({bool isInOrder}) async {
    final db = await database;
    var res = await db.query(tableProducts,
        where: "isInOrder = ? ", whereArgs: [(isInOrder ? 1 : 0)]);
    List<ProductModel> list = res.isNotEmpty
        ? res.map((product) => ProductModel.fromMap(product)).toList()
        : [];
    return list;
  }

  Future<bool> checkProduct({int code, bool isInOrder}) async {
    final db = await database;
    var res = await db.query(tableProducts,
        where: "code = ? AND isInOrder = ?",
        whereArgs: [code, (isInOrder ? 1 : 0)]);
    return res.isNotEmpty;
  }

  Future<int> deleteProduct({int code, bool isInOrder}) async {
    final db = await database;
    return await db.delete(tableProducts,
        where: "isInOrder = ? AND code = ?",
        whereArgs: [(isInOrder ? 1 : 0), code]);
  }

  Future<int> deleteProductsByOrderType({bool isInOrder}) async {
    final db = await database;
    return await db.delete(tableProducts,
        where: "isInOrder = ?", whereArgs: [(isInOrder ? 1 : 0)]);
  }

  updateScannedQuantity({ProductModel product}) async {
    final db = await database;
    var res = await db.update(tableProducts, product.toDatabaseMap(false),
        where: "id = ?", whereArgs: [product.id]);
    return res;
  }
}
