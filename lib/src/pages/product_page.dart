import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login/src/bloc/product_bloc.dart';
import 'package:flutter_login/src/bloc/provider_bloc.dart';
import 'package:flutter_login/src/models/product_model.dart';
import 'package:flutter_login/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //creo la key para formulario, para poder controlarlo
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  File filePhoto;

  ProductModel product = new ProductModel();
  // final productProvider = new ProductProvider();
  ProductBloc productBloc;
  @override
  Widget build(BuildContext context) {
    productBloc = ProviderBloc.productBloc(context);
    //recuperto el producto del navigator
    final ProductModel prodArgs = ModalRoute.of(context).settings.arguments;
    if (prodArgs != null) {
      product = prodArgs;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.photo), onPressed: _selectPhoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePhoto)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _showPhoto(),
                  _crateName(),
                  _createPrice(),
                  _createAvailable(context),
                  SizedBox(
                    height: 10.0,
                  ),
                  _createBtnSend(context)
                ],
              )),
        ),
      ),
    );
  }

  Widget _crateName() {
    //TextFormField a diferencia del TextFormInput este trabaja directamente con un formulario, y tiene el campo  inicialValue
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      //validar si tiene un error se regresa ese String, sino tiene error se devuelve un null
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese nombre del prodcuto';
        } else {
          return null;
        }
      },
      //onSave se ejecuta despues de haber validado los campos
      onSaved: (value) => product.title = value,
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) {
        if (utils.isNumber(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
      //onSave se ejecuta despues de haber validado los campos
      onSaved: (value) => product.value = int.parse(value),
    );
  }

  Widget _createAvailable(BuildContext context) {
    return SwitchListTile(
      value: product.available,
      activeColor: Theme.of(context).primaryColor,
      title: Text('Disponible'),
      onChanged: (value) {
        setState(() {
          product.available = value;
        });
      },
    );
  }

  Widget _createBtnSend(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: (_loading) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    //verificar el estado actual del formulario, si el formulario esta validado va a regresar true
    if (formKey.currentState.validate()) {
      //formKey.currentState.save para disparar onSave donde almacena los valores
      formKey.currentState.save();

      setState(() {
        _loading = true;
      });

      //subir la imagen
      if (filePhoto != null) {
        product.photoUrl = await productBloc.uploadImg(filePhoto);
      }

      if (product.id == null) {
        productBloc.createProduct(product);
        showSnackbar('Registro guardado');
      } else {
        productBloc.updateProduct(product);
        showSnackbar('Registro editado');
      }

      showSnackbar('Registro guardado');
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  //snackbar requiere una referenci al Scaffold porque es quien puede emitir y mostrar el snackbar
  void showSnackbar(String message) async {
    //construyo el snackbar
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    //muestro el snackbar
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showPhoto() {
    if (product.photoUrl != null) {
      //todo  tengo que hacer esto
      return FadeInImage(
        image: NetworkImage(product.photoUrl),
        placeholder: AssetImage('assets/loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        //  pregunta si la fotografia tiene un valor, y si tiene un valor toma el path, sin embargo si es nulo toma el assets
        image: AssetImage(
          filePhoto?.path ?? 'assets/placeholder.png',
        ),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _selectPhoto() async {
//    //me abre la galeria de imagenes para seleccionar una imagen
//    filePhoto = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if (filePhoto != null) {}
//    setState(() {});

    _processImage(ImageSource.gallery);
  }

  _takePhoto() async {
//    //se abre  la camara para tomar una fotografia
//    filePhoto = await ImagePicker.pickImage(source: ImageSource.camera);
//    if (filePhoto != null) {}
//    setState(() {});

    _processImage(ImageSource.camera);
  }

  //metodo para optimizar las imagenes
  _processImage(ImageSource origin) async {
    filePhoto = await ImagePicker.pickImage(source: origin);
    if (filePhoto != null) {
      product.photoUrl = null;
    }
    setState(() {});
  }
}
