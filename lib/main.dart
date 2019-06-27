import 'package:flutter/material.dart';
import 'package:flutter_login/src/bloc/provider_bloc.dart';
import 'package:flutter_login/src/pages/home_page.dart';
import 'package:flutter_login/src/pages/product_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderBloc(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: 'home',
        routes: {
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage()
        },
        theme: ThemeData(primaryColor: Colors.purple),
      ),
    );
  }
}
