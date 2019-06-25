import 'package:flutter/material.dart';
import 'package:flutter_login/src/models/product_model.dart';
import 'package:flutter_login/src/services/product_service.dart';

class HomePage extends StatelessWidget {
  final productService = new ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _createListProducts(),
      floatingActionButton: _createFloatinActionButton(context),
    );
  }

  _createFloatinActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, 'product'));
  }

  Widget _createListProducts() {
    return FutureBuilder(
        future: productService.listProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            //ListView.builde constructor crea una lista perezosa. Cuando el usuario se desplaza hacia abajo en la lista, Flutter crea los widgets "a pedido"
            return ListView.builder(
                itemCount: snapshot.data.length,
                //itemBuilder como se va a crear cada uno de los elementos
                itemBuilder: (context, i) {
                  return _createItem(snapshot.data[i], context);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _createItem(ProductModel prod, BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          //Borrar producto
          productService.deleteProduct(prod.id);
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
