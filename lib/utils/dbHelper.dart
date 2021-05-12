import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:waterreminder/models/water.dart';
import 'package:waterreminder/models/user.dart';

class DatabaseHelper {
  static Database _database;

  String _waterAmount = "waterAmount2";
  String _columnID = "id";
  String _columnAmount = "amount";
  String _columnCreatedDate = "createdDate";

  String _user = "user";
  String _userWeight = "userWeight";
  String _dailyAmount = "dailyAmount";

  String nowDate = Jiffy(DateTime.now()).format('yyyy-MM-dd HH:mm:ss');
  String todayDate =
      Jiffy(DateTime.now().add(Duration(days: 1))).format('yyyy-MM-dd ');

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = p.join(databasesPath, "waterAmount2.db");
    var waterAmountDb =
        await openDatabase(dbPath, version: 1, onCreate: createDb);
    return waterAmountDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "Create table $_waterAmount($_columnID integer primary key, $_columnAmount text, $_columnCreatedDate text)");
    await db.execute(
        "Create table $_user($_columnID integer primary key, $_userWeight text, $_dailyAmount text, $_columnCreatedDate text)");
  }

  //Crud Methods Water
  Future<List<WatersAmount>> getAllData() async {
    Database db = await this.database;
    var result = await db.query("$_waterAmount");
    return List.generate(result.length, (i) {
      return WatersAmount.fromMap(result[i]);
    });
  }

  Future<List<WatersAmount>> getTodayDayData() async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "select * from $_waterAmount where `$_columnCreatedDate` < '$todayDate' and `$_columnCreatedDate` >= '$nowDate' ");
    return List.generate(result.length, (i) {
      return WatersAmount.fromMap(result[i]);
    });
  }

  Future<int> insert(WatersAmount waterAmount) async {
    Database db = await this.database;
    var result = await db.insert("$_waterAmount", waterAmount.toMap());
    return result;
  }

  Future<int> delete() async {
    Database db = await this.database;
    var result = await db.rawDelete(
        "delete from $_waterAmount where id=(Select MAX(id) from $_waterAmount)");
    return result;
  }

  Future<int> update(WatersAmount waterAmount) async {
    Database db = await this.database;
    var result = await db.update("$_waterAmount", waterAmount.toMap(),
        where: "id=?", whereArgs: [waterAmount.id]);
    return result;
  }

  Future<int> deleteAllRecords() async {
    Database db = await this.database;
    var result = await db.rawDelete("delete from $_waterAmount");
    return result;
  }

  //Crud For User

  Future<List<User>> getUserInfo() async {
    Database db = await this.database;
    var result = await db.rawQuery("select * from $_user");
    return List.generate(result.length, (i) {
      return User.fromMap(result[i]);
    });
  }

  Future<int> insertUser(User user) async {
    Database db = await this.database;
    var result = await db.insert("$_user", user.toMap());
    return result;
  }

  Future<int> deleteUser() async {
    Database db = await this.database;
    var result = await db.rawDelete("delete from $_user)");
    return result;
  }
}
