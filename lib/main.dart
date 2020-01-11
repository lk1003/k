import 'package:flutter/material.dart';
import 'package:jdshop/provider/Cart.dart';
import 'package:jdshop/provider/CheckOut.dart';
import 'package:provider/provider.dart';
import 'routers/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>Cart()),
         ChangeNotifierProvider(create: (_)=>CheckOut())
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(
        primaryColor: Colors.white
      ),
    ),
    );
  }
}