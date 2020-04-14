import 'expr.dart';

class Value extends Expr {
  Object value;

  Value(Object item) {
    assert(!(item is Map) && !(item is List));
    value = item;
  }

  String toJson() {
    if (value is String) {
      return "\"${value.toString()}\"";
    }
    return value.toString();
  }
}

class Obj extends Expr {
  Map<String, Expr> values;

  Obj(Map<String, Object> parameters) {
    values = Map<String, Expr>();
    parameters?.forEach((k, v) {
      values[k] = Expr.parse(v);
    });
  }

  String toJson() {
    var output = List<String>();
    values.forEach((k, v) {
      assert(v is Expr);
      output.add("\"$k\":${v.toJson()}");
    });
    return "{\"object\":{${output.join(",")}}}";
  }
}

class Array extends Expr {
  List<Expr> values;

  Array(List<Object> parameters) {
    values = List<Expr>();
    parameters?.forEach((item) {
      values.add(Expr.parse(item));
    });
  }

  String toJson() {
    var output = List<String>();
    values.forEach((item) {
      output.add(item.toJson());
    });
    return "[${output.join(",")}]";
  }
}

// class Bytes extends Value {
//   Bytes(List<int> bytes) : super({"@bytes": Expr.fromObject(base64.encode(bytes))});
// }

// class Native {
//   static Ref COLLECTIONS = Ref("collections");
// }
