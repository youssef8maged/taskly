import 'package:flutter/material.dart';

class MyTaskOptions {
   final List<int> reminders = [0, 5, 15, 30, 45];

  final List<String> repeats = ['None', 'Daily', 'Weekly', 'Monthly'];
  
  final Map<int, Color> colors = {
  1: Colors.orange,  
  2: Colors.blue,    
  3: Colors.green,   
  4: Colors.pink,    
  5: Colors.grey,
  6: Colors.lime     
};


  MyTaskOptions._privateConstructor();
  static final MyTaskOptions _instance = MyTaskOptions._privateConstructor();
  factory MyTaskOptions() => _instance;


}