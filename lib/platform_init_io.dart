import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void platformInit() {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
