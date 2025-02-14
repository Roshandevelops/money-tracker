import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/provider/category_provider.dart';
import 'package:money_tracker/provider/transaction_provider.dart';
import 'package:money_tracker/screens/splash_screen.dart';
import 'package:provider/provider.dart';

const setkey = "";
const setStringKey = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return TransactionProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return CategoryProvider();
          },
        ),
      ],
      child: MaterialApp(
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Money Tracker',
        theme: ThemeData(
          fontFamily: "acme",
          hintColor: Colors.grey,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
