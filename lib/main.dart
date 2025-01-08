
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/Helpers/methods.dart';
import 'package:todo/Logic/my_theme_mode.dart';
import 'package:todo/Splash%20Screen/splashing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
      final bool isGetStorageInizialized = await GetStorage.init();
    Methods().showOutput("GetStorage is $isGetStorageInizialized");

  
  runApp(const CustomMaterial(),);
}

class CustomMaterial extends StatelessWidget {

  const CustomMaterial({super.key,});
  
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Taskly",
      theme: getCustomThemeData(isLight: true),
      darkTheme: getCustomThemeData(isLight: false),
      themeMode: MyThemeMode().getThemeMode(),
      home:  const Splashing(),
    );
  }

  ThemeData getCustomThemeData({required bool isLight}) {
    final TextTheme myTextTheme = getCustomTextTheme();
    final Brightness myBrightness =
        isLight ? Brightness.light : Brightness.dark;
    return ThemeData.from(
      useMaterial3: true,
      textTheme: myTextTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: myBrightness,
      ),
    );
  }

  TextTheme getCustomTextTheme() {
    return TextTheme(
      headlineLarge: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineMedium: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineSmall: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      titleLarge: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      titleMedium: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      titleSmall: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }


}
