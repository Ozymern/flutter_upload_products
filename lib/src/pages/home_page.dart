import 'package:flutter/material.dart';
import 'package:flutter_login/src/bloc/product_bloc.dart';
import 'package:flutter_login/src/bloc/provider_bloc.dart';
import 'package:flutter_login/src/models/product_model.dart';

class HomePage extends StatelessWidget {
  // final productProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {
    final productBloc = ProviderBloc.productBloc(context);
    productBloc.listProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _createListProducts(productBloc),
      floatingActionButton: _createFloatinActionButton(context),
    );
  }

  _createFloatinActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, 'product'));
  }

  Widget _createListProducts(ProductBloc productBloc) {
    //con bloc
    return StreamBuilder(
        stream: productBloc.productStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            //ListView.builde constructor crea una lista perezosa. Cuando el usuario se desplaza hacia abajo en la lista, Flutter crea los widgets "a pedido"
            return ListView.builder(
                itemCount: snapshot.data.length,
                //itemBuilder como se va a crear cada uno de los elementos
                itemBuilder: (context, i) {
                  return _createItem(snapshot.data[i], productBloc, context);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });

    //sin bloc
//    return FutureBuilder(
//        future: productProvider.listProducts(),
//        builder:
//            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
//          if (snapshot.hasData) {
//            //ListView.builde constructor crea una lista perezosa. Cuando el usuario se desplaza hacia abajo en la lista, Flutter crea los widgets "a pedido"
//            return ListView.builder(
//                itemCount: snapshot.data.length,
//                //itemBuilder como se va a crear cada uno de los elementos
//                itemBuilder: (context, i) {
//                  return _createItem(snapshot.data[i], context);
//                });
//          } else {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          }
//        });
  }

  Widget _createItem(
      ProductModel prod, ProductBloc productBloc, BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          //Borrar producto
          //     productProvider.deleteProduct(prod.id);
          //con bloc
          productBloc.deleteProduct(prod.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (prod.photoUrl == null)
                  ? Image(image: AssetImage('assets/placeholder.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/loading.gif'),
                      image: NetworkImage(prod.photoUrl),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${prod.title} - ${prod.value}'),
                subtitle: Text(prod.id),
                onTap: () =>
                    Navigator.pushNamed(context, 'product', arguments: prod),
              ),
            ],
          ),
        ));
  }
}
