import 'types.dart';

abstract class Expr {
  Expr();

  factory Expr.fromObject(Object parameter) {
    if (parameter is Expr) {
      return parameter;
    }
    if (parameter is Map) {
      if (parameter.length == 0) {
        return Obj(null);
      }
      return Obj(parameter);
    } else if (parameter is List) {
      return Array(parameter);
    } else {
      return Value(parameter);
    }
  }

  String toJson();
  bool isNull() => false;
}
