import 'package:flutter/material.dart';
import 'package:flutter_login/src/bloc/product_bloc.dart';

class ProviderBloc extends InheritedWidget {
  final _productBloc = new ProductBloc();

  static ProviderBloc _instance;

  factory ProviderBloc({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new ProviderBloc._internal(key: key, child: child);
    }

    return _instance;
  }
  ProviderBloc._internal({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ProductBloc productBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ProviderBloc) as ProviderBloc)
        ._productBloc;
  }
}
