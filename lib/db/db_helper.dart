import 'package:appentus_assessment/util/constant.dart';
import 'package:hive/hive.dart';

class DbHelper {
  Box? _userBox;

  DbHelper() {
    initDb();
  }

  Future initDb() async {
    if (_userBox == null) {
      _userBox = await Hive.openBox(Constant.userBox);
    }
  }

  void deleteLocalDatabase() {
    if (_userBox == null) {
      _userBox = Hive.box(Constant.userBox);
    }
    _userBox!.deleteFromDisk();
  }

  Box? getUserBox() {
    if (_userBox == null) {
      _userBox = Hive.box(Constant.userBox);
    }
    return _userBox;
  }
}
