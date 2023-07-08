import 'package:flutter/material.dart';
import 'package:hellokitty/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'model/task_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        title: "Hello Kitty",
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.initial,
        routes: AppPages.routes,
        theme: ThemeData(
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            hourMinuteShape: const CircleBorder(),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
              .copyWith(secondary: Colors.redAccent),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                      (state) => Colors.black))),
        ),
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
      ),
    );
  }
}
