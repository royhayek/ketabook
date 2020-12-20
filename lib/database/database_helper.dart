// import 'dart:io';

// import 'package:ketabook/models/book.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static final _databaseName = "AppDB.db";
//   static final _databaseVersion = 1;

//   static final tableCart = 'wish_list';

//   static final cartId = 'cart_id';
//   static final bookId = 'book_id';
//   static final bookUserId = 'user_id';

//   // make this a singleton class
//   DatabaseHelper._privateConstructor();

//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   // only have a single app-wide reference to the database
//   static Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;
//     // lazily instantiate the db the first time it is accessed
//     _database = await _initDatabase();
//     return _database;
//   }

//   // this opens the database (and creates it if it doesn't exist)
//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     return await openDatabase(path,
//         version: _databaseVersion, onCreate: _onCreate);
//   }

//   // SQL code to create the database table
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $tableCart (
//             $cartId INTEGER PRIMARY KEY AUTOINCREMENT,
//             $bookUserId INTEGER NOT NULL,
//             $bookId TEXT NOT NULL UNIQUE
//           )
//           ''');
//   }

//   // Helper methods
//   Future<int> insertToCart(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(tableCart, row);
//   }

//   Future<List<Book>> getAllBooks() async {
//     Database db = await instance.database;
//     List<Book> list = new List<Book>();
//     var book = await db.query(tableCart);
//     book.forEach((itemMap) {
//       list.add(Book.fromMap(itemMap));
//     });
//     return list;
//   }

//   Future<Book> getBook(String id) async {
//     Database db = await instance.database;
//     var wishList = await db.rawQuery(
//         "SELECT * FROM $tableCart WHERE $bookId = $id");
//     if (wishList.isNotEmpty) return Book.fromMap(wishList.first);
//     return null;
//   }

//   Future<int> removeFromCart(int id, int customerId) async {
//     Database db = await instance.database;
//     return await db.delete(tableCart,
//         where: '$bookId = ? AND $bookUserId = ?',
//         whereArgs: [id, customerId]);
//   }
// }
