
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyThemeMode {
  final GetStorage getStorage = GetStorage();

  MyThemeMode._privateConstructor();
  static final MyThemeMode _instance = MyThemeMode._privateConstructor();
  factory MyThemeMode() => _instance;

  void setThemeMode({required bool toLight}) async {
    Get.changeThemeMode(toLight ? ThemeMode.light : ThemeMode.dark);
    await getStorage.write("isStoredLight", toLight);
  }

  ThemeMode getThemeMode() {
    bool isStoredLight = getStorage.read<bool>("isStoredLight") ?? true;
    return isStoredLight ? ThemeMode.light : ThemeMode.dark;
  }

}
