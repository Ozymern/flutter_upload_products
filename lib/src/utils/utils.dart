bool isNumber(String value) {
  if (value.isEmpty) {
    return false;
  }
  //saber si se puede parsear en un numero, si no puede retornara un null
  final number = num.tryParse(value);

  return (number == null) ? false : true;
}
