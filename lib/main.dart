
import 'package:expense_tracker/features/login/presentation/ui/LoginPage.dart';
import 'package:expense_tracker/service_locator.dart';
import 'package:flutter/material.dart';

import 'features/home/presentation/ui/home.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();
  runApp( new MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple
      ),
      home: LoginPage(),
    );
  }
}
