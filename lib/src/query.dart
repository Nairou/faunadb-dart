import 'expr.dart';
import 'types.dart';

class Abort extends Expr {
  final String msg;

  Abort(this.msg);

  String toJson() {
    return "{\"abort\":${Value(msg).toJson()}}";
  }
}

class At extends Expr {
  final Expr timestamp;
  final Expr expr;

  At(Object timestamp, this.expr) : timestamp = Expr.fromObject(timestamp);

  String toJson() {
    return "{\"at\":${timestamp.toJson()},\"expr\":${expr.toJson()}}";
  }
}

class Let extends Expr {
  final Map<String, Expr> bindings;
  final Expr inExpr;

  Let(Map<String, Object> bindingList, this.inExpr) : bindings = Map<String, Expr>() {
    bindingList.forEach((k, v) {
      bindings[k] = Expr.fromObject(v);
    });
    assert(bindings.length > 0);
  }

  String toJson() {
    var output = List<String>();
    bindings.forEach((k, v) {
      output.add("{\"$k\":${v.toJson()}}");
    });
    return "{\"let\":[${output.join(",")}],\"in\":${inExpr.toJson()}}";
  }
}

class Ref extends Expr {
  final Expr ref;
  final String id;

  Ref(this.ref, this.id);

  String toJson() {
    return "{\"ref\":${ref.toJson()},\"id\":${Value(id).toJson()}}";
  }

  factory Ref.fromJson(Map<String, dynamic> json) {
    String id = json["id"];
    if (json.containsKey("class")) {}
  }
}

class Var extends Expr {
  final String varName;

  Var(this.varName);

  String toJson() {
    return "{\"var\":${Value(varName).toJson()}}";
  }
}

class If extends Expr {
  final Expr ifExpr;
  final Expr thenExpr;
  final Expr elseExpr;

  If(Object ifExpr, Object thenExpr, Object elseExpr)
      : ifExpr = Expr.fromObject(ifExpr),
        thenExpr = Expr.fromObject(thenExpr),
        elseExpr = Expr.fromObject(elseExpr);

  String toJson() {
    return "{\"if\":${ifExpr.toJson()},\"then\":${thenExpr.toJson()},\"else\":${elseExpr.toJson()}}";
  }
}

class Do extends Expr {
  final List<Expr> args;

  Do(List<Object> argsList) : args = List<Expr>() {
    argsList.forEach((item) {
      args.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"do\":${Expr.fromObject(args).toJson()}}";
  }
}

class Lambda extends Expr {
  final Expr params;
  final Expr expr;

  Lambda(Object params, this.expr) : params = Expr.fromObject(params);

  String toJson() {
    return "{\"lambda\":${params.toJson()},\"expr\":${expr.toJson()}}";
  }
}

// class Call extends Expr {
//   final Expr ref;
//   final List<Expr> args;

//   Call(this.ref, this.args);

//   String toJson() {
//     return "{\"call\":${values.toJson()}}";
//   }
// }

class Query extends Expr {
  final Lambda lambda;

  Query(this.lambda);

  String toJson() {
    return "{\"query\":${lambda.toJson()}}";
  }
}

class Map_ extends Expr {
  final List<Expr> array;
  final Lambda lambda;

  Map_(List<Object> items, this.lambda) : array = List<Expr>() {
    items.forEach((item) {
      array.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"map\":${lambda.toJson()},\"collection\":${Expr.fromObject(array).toJson()}}";
  }
}

class Merge extends Expr {
  final Obj object1;
  final Obj object2;
  final Lambda resolver;

  Merge(Map<String, Object> object1, Map<String, Object> object2, [this.resolver])
      : object1 = Obj(object1),
        object2 = Obj(object2);

  String toJson() {
    List<String> output = ["\"merge\":${object1.toJson()}", "\"with\":${object2.toJson()}"];
    if (resolver != null) {
      output.add("\"lambda\":${resolver.toJson()}");
    }
    return "{${output.join(",")}}";
  }
}

class Foreach extends Expr {
  final List<Expr> array;
  final Lambda lambda;

  Foreach(List<Object> items, this.lambda) : array = List<Expr>() {
    items.forEach((item) {
      array.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"foreach\":${lambda.toJson()},\"collection\":${Expr.fromObject(array).toJson()}}";
  }
}

class Filter extends Expr {
  final List<Expr> array;
  final Lambda lambda;

  Filter(List<Object> items, this.lambda) : array = List<Expr>() {
    items.forEach((item) {
      array.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"filter\":${lambda.toJson()},\"collection\":${Expr.fromObject(array).toJson()}}";
  }
}

class Take extends Expr {
  final int num;
  final List<Expr> array;

  Take(this.num, List<Object> items) : array = List<Expr>() {
    items.forEach((item) {
      array.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"take\":${Value(num).toJson()},\"collection\":${Expr.fromObject(array).toJson()}}";
  }
}

class Drop extends Expr {
  final int num;
  final List<Expr> array;

  Drop(this.num, List<Object> items) : array = List<Expr>() {
    items.forEach((item) {
      array.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"drop\":${Value(num).toJson()},\"collection\":${Expr.fromObject(array).toJson()}}";
  }
}

class Prepend extends Expr {
  final List<Expr> base;
  final List<Expr> elems;

  Prepend(List<Object> baseList, List<Object> elemList)
      : base = List<Expr>(),
        elems = List<Expr>() {
    baseList.forEach((item) {
      base.add(Expr.fromObject(item));
    });
    elemList.forEach((item) {
      elems.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"prepend\":${Expr.fromObject(base).toJson()},\"collection\":${Expr.fromObject(elems).toJson()}}";
  }
}

class Append extends Expr {
  final List<Expr> base;
  final List<Expr> elems;

  Append(List<Object> baseList, List<Object> elemList)
      : base = List<Expr>(),
        elems = List<Expr>() {
    baseList.forEach((item) {
      base.add(Expr.fromObject(item));
    });
    elemList.forEach((item) {
      elems.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"append\":${Expr.fromObject(base).toJson()},\"collection\":${Expr.fromObject(elems).toJson()}}";
  }
}

class IsEmpty extends Expr {
  final List<Expr> array;

  IsEmpty(List<Object> items) : array = List<Expr>() {
    items.forEach((item) {
      array.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"is_empty\":${Expr.fromObject(array).toJson()}}";
  }
}

class IsNonEmpty extends Expr {
  final List<Expr> array;

  IsNonEmpty(List<Object> items) : array = List<Expr>() {
    items.forEach((item) {
      array.add(Expr.fromObject(item));
    });
  }

  String toJson() {
    return "{\"is_nonempty\":${Expr.fromObject(array).toJson()}}";
  }
}

// class IsNumber extends Expr {
//     IsNumber(expr: ExprArg) {}
// }
// class IsDouble extends Expr {
//     IsDouble(expr: ExprArg) {}
// }
// class IsInteger extends Expr {
//     IsInteger(expr: ExprArg) {}
// }
// class IsBoolean extends Expr {
//     IsBoolean(expr: ExprArg) {}
// }
// class IsNull extends Expr {
//     IsNull(expr: ExprArg) {}
// }
// class IsBytes extends Expr {
//     IsBytes(expr: ExprArg) {}
// }
// class IsTimestamp extends Expr {
//     IsTimestamp(expr: ExprArg) {}
// }
// class IsDate extends Expr {
//     IsDate(expr: ExprArg) {}
// }
// class IsString extends Expr {
//     IsString(expr: ExprArg) {}
// }
// class IsArray extends Expr {
//     IsArray(expr: ExprArg) {}
// }
// class IsObject extends Expr {
//     IsObject(expr: ExprArg) {}
// }
// class IsRef extends Expr {
//     IsRef(expr: ExprArg) {}
// }
// class IsSet extends Expr {
//     IsSet(expr: ExprArg) {}
// }
// class IsDoc extends Expr {
//     IsDoc(expr: ExprArg) {}
// }
// class IsLambda extends Expr {
//     IsLambda(expr: ExprArg) {}
// }
// class IsCollection extends Expr {
//     IsCollection(expr: ExprArg) {}
// }
// class IsDatabase extends Expr {
//     IsDatabase(expr: ExprArg) {}
// }
// class IsIndex extends Expr {
//     IsIndex(expr: ExprArg) {}
// }
// class IsFunction extends Expr {
//     IsFunction(expr: ExprArg) {}
// }
// class IsKey extends Expr {
//     IsKey(expr: ExprArg) {}
// }
// class IsToken extends Expr {
//     IsToken(expr: ExprArg) {}
// }
// class IsCredentials extends Expr {
//     IsCredentials(expr: ExprArg) {}
// }
// class IsRole extends Expr {
//     IsRole(expr: ExprArg) {}
// }

// class Get extends Expr {
//   Get(Ref ref, {Object ts}) : super({"get": ref, "ts": Expr.fromObject(ts)}) {
//     assert(ts == null || ts is int || ts is Time);
//   }
// }

// class KeyFromSecret extends Expr {
//   KeyFromSecret(String secret) : super({"key_from_secret": Expr.fromObject(secret)});
// }

// class Reduce extends Expr {
//     Reduce(lambda: ExprArg, initial: ExprArg, collection: ExprArg) {}
// }

class Paginate extends Expr {
  final Expr input;
  final Expr ts;
  final Expr after;
  final Expr before;
  final int size;
  final bool events;
  final bool sources;

  Paginate(this.input, {Object ts, this.after, this.before, this.size, this.events, this.sources}) : ts = Expr.fromObject(ts) {
    assert(ts == null || ts is int || ts is Time);
  }

  String toJson() {
    List<String> output = ["\"paginate\":${input.toJson()}"];
    if (ts != null && !ts.isNull()) {
      output.add("\"ts\":${ts.toJson()}");
    }
    if (before != null && !before.isNull()) {
      output.add("\"before\":${before.toJson()}");
    }
    if (after != null && !after.isNull()) {
      output.add("\"after\":${after.toJson()}");
    }
    if (size != null) {
      output.add("\"size\":${Value(size).toJson()}");
    }
    if (events != null) {
      output.add("\"events\":${Value(events).toJson()}");
    }
    if (sources != null) {
      output.add("\"sources\":${Value(sources).toJson()}");
    }
    return "{${output.join(",")}}";
  }
}

// class Exists extends Expr {
//     Exists(ref: ExprArg, ts?: ExprArg) {}
// }

// class Create extends Expr {
//     Create(collection_ref: ExprArg, params?: ExprArg) {}
// }
// class Update extends Expr {
//     Update(ref: ExprArg, params: ExprArg) {}
// }
// class Replace extends Expr {
//     Replace(ref: ExprArg, params: ExprArg) {}
// }
// class Delete extends Expr {
//     Delete(ref: ExprArg) {}
// }
// class Insert extends Expr {
//     Insert(ref: ExprArg, ts: ExprArg, action: ExprArg, params: ExprArg) {}
// }
// class Remove extends Expr {
//     Remove(ref: ExprArg, ts: ExprArg, action: ExprArg) {}
// }
// class CreateClass extends Expr {
//     CreateClass(params: ExprArg) {}
// }
// class CreateCollection extends Expr {
//     CreateCollection(params: ExprArg) {}
// }

class CreateDatabase extends Expr {
  final Obj values;

  CreateDatabase(Map<String, Object> parameters) : values = Obj(parameters);

  String toJson() {
    return "{\"create_database\":${values.toJson()}}";
  }
}

// class CreateIndex extends Expr {
//     CreateIndex(params: ExprArg) {}
// }
// class CreateKey extends Expr {
//     CreateKey(params: ExprArg) {}
// }
// class CreateFunction extends Expr {
//     CreateFunction(params: ExprArg) {}
// }
// class CreateRole extends Expr {
//     CreateRole(params: ExprArg) {}
// }

// class Singleton extends Expr {
//     Singleton(ref: ExprArg) {}
// }
// class Events extends Expr {
//     Events(ref_set: ExprArg) {}
// }
// class Match extends Expr {
//     Match(index: ExprArg, terms: ExprArg[]) {}
// }
// class Union extends Expr {
//     Union(sets: ExprArg[]) {}
// }
// class Intersection extends Expr {
//     Intersection(sets: ExprArg[]) {}
// }
// class Difference extends Expr {
//     Difference(sets: ExprArg[]) {}
// }
// class Distinct extends Expr {
//     Distinct(set: ExprArg) {}
// }
// class Join extends Expr {
//     Join(source: ExprArg, target: ExprArg | Lambda) {}
// }

// class Range extends Expr {
//     Range(set: ExprArg, from: ExprArg, to: ExprArg) {}
// }
// class Login extends Expr {
//     Login(ref: ExprArg, params: ExprArg) {}
// }
// class Logout extends Expr {
//     Logout(delete_tokens: ExprArg) {}
// }
// class Identify extends Expr {
//     Identify(ref: ExprArg, password: ExprArg) {}
// }
// class Identity extends Expr {
//     Identity() {}
// }
// class HasIdentity extends Expr {
//     HasIdentity() {}
// }

// class Concat extends Expr {
//     Concat(strings: ExprArg, separator?: ExprArg) {}
// }
// class Casefold extends Expr {
//     Casefold(string: ExprArg, normalizer?: ExprArg) {}
// }
// class ContainsStr extends Expr {
//     ContainsStr(value: ExprArg, search: ExprArg) {}
// }
// class ContainsStrRegex extends Expr {
//     ContainsStrRegex(value: ExprArg, pattern: ExprArg) {}
// }
// class StartsWith extends Expr {
//     StartsWith(value: ExprArg, search: ExprArg) {}
// }
// class EndsWith extends Expr {
//     EndsWith(value: ExprArg, search: ExprArg) {}
// }
// class RegexEscape extends Expr {
//     RegexEscape(value: ExprArg) {}
// }
// class FindStr extends Expr {
//     FindStr(value: ExprArg, find: ExprArg, start?: ExprArg) {}
// }
// class FindStrRegex extends Expr {
//     FindStrRegex(value: ExprArg, find: ExprArg, start?: ExprArg, numResults?: ExprArg) {}
// }
// class Length extends Expr {
//     Length(expr: ExprArg) {}
// }
// class LowerCase extends Expr {
//     LowerCase(expr: ExprArg) {}
// }
// class LTrim extends Expr {
//     LTrim(expr: ExprArg) {}
// }
// class NGram extends Expr {
//     NGram(terms: ExprArg, min?: ExprArg, max?: ExprArg) {}
// }
// class Repeat extends Expr {
//     Repeat(expr: ExprArg, number?: ExprArg) {}
// }
// class ReplaceStr extends Expr {
//     ReplaceStr(expr: ExprArg, find: ExprArg, replace: ExprArg) {}
// }
// class ReplaceStrRegex extends Expr {
//     ReplaceStrRegex(expr: ExprArg, find: ExprArg, replace: ExprArg, first?: ExprArg) {}
// }
// class RTrim extends Expr {
//     RTrim(expr: ExprArg) {}
// }
// class Space extends Expr {
//     Space(expr: ExprArg) {}
// }
// class SubString extends Expr {
//     SubString(expr: ExprArg, start?: ExprArg, length?: ExprArg) {}
// }
// class TitleCase extends Expr {
//     TitleCase(value: ExprArg) {}
// }
// class Trim extends Expr {
//     Trim(expr: ExprArg) {}
// }
// class UpperCase extends Expr {
//     UpperCase(expr: ExprArg) {}
// }
// class Format extends Expr {
//     Format(string: ExprArg, values: ExprArg) {}
// }

class Time extends Expr {
  final DateTime time;

  Time(String date) : time = DateTime.parse(date);

  Time.fromDateTime(this.time);

  String toJson() {
    return "{\"time\":${Value(time.toIso8601String()).toJson()}}";
  }
}

// class Epoch extends Expr {
//     Epoch(number: ExprArg, unit: ExprArg) {}
// }
// class TimeAdd extends Expr {
//     TimeAdd(base: ExprArg, offset: ExprArg, unit: ExprArg) {}
// }
// class TimeSubtract extends Expr {
//     TimeSubtract(base: ExprArg, offset: ExprArg, unit: ExprArg) {}
// }
// class TimeDiff extends Expr {
//     TimeDiff(start: ExprArg, finish: ExprArg, unit: ExprArg) {}
// }
// class Date extends Value {
//   Date(String string) : super(null) {
//     value = DateTime.parse(string);
//   }
//   Date.fromDateTime(DateTime date) : super(null) {
//     value = date.toUtc();
//   }

//   String toJson() {
//     DateTime date = value;
//     var year = date.year.toString().padLeft(4, "0");
//     var month = date.month.toString().padLeft(2, "0");
//     var day = date.day.toString().padLeft(2, "0");
//     return "{\"@date\":\"$year-$month-$day\"}";
//   }
// }
// class Now extends Expr {
//     Now() {}
// }
// class DayOfWeek extends Expr {
//     DayOfWeek(expr: ExprArg) {}
// }
// class DayOfYear extends Expr {
//     DayOfYear(expr: ExprArg) {}
// }
// class DayOfMonth extends Expr {
//     DayOfMonth(expr: ExprArg) {}
// }
// class Hour extends Expr {
//     Hour(expr: ExprArg) {}
// }
// class Minute extends Expr {
//     Minute(expr: ExprArg) {}
// }
// class Second extends Expr {
//     Second(expr: ExprArg) {}
// }
// class Year extends Expr {
//     Year(expr: ExprArg) {}
// }
// class Month extends Expr {
//     Month(expr: ExprArg) {}
// }

// class NextId extends Expr {
//     NextId() {}
// }
// class NewId extends Expr {
//     NewId() {}
// }

class Database extends Expr {
  final String name;
  final Expr scope;

  Database(this.name, [this.scope]);

  String toJson() {
    if (scope != null) {
      return "{\"database\":${Value(name).toJson()},\"scope\":${scope.toJson()}}";
    } else {
      return "{\"database\":${Value(name).toJson()}}";
    }
  }
}

class Index extends Expr {
  final String name;
  final Expr scope;

  Index(this.name, [this.scope]);

  String toJson() {
    if (scope != null) {
      return "{\"index\":${Value(name).toJson()},\"scope\":${scope.toJson()}}";
    } else {
      return "{\"index\":${Value(name).toJson()}}";
    }
  }
}

class Class extends Expr {
  final String name;
  final Expr scope;

  Class(this.name, [this.scope]);

  String toJson() {
    if (scope != null) {
      return "{\"class\":${Value(name).toJson()},\"scope\":${scope.toJson()}}";
    } else {
      return "{\"class\":${Value(name).toJson()}}";
    }
  }
}

class Collection extends Expr {
  final String name;
  final Expr scope;

  Collection(this.name, [this.scope]);

  String toJson() {
    if (scope != null) {
      return "{\"collection\":${Value(name).toJson()},\"scope\":${scope.toJson()}}";
    } else {
      return "{\"collection\":${Value(name).toJson()}}";
    }
  }
}

class Function extends Expr {
  final String name;
  final Expr scope;

  Function(this.name, [this.scope]);

  String toJson() {
    if (scope != null) {
      return "{\"function\":${Value(name).toJson()},\"scope\":${scope.toJson()}}";
    } else {
      return "{\"function\":${Value(name).toJson()}}";
    }
  }
}

class Role extends Expr {
  final String name;
  final Expr scope;

  Role(this.name, [this.scope]);

  String toJson() {
    if (scope != null) {
      return "{\"role\":${Value(name).toJson()},\"scope\":${scope.toJson()}}";
    } else {
      return "{\"role\":${Value(name).toJson()}}";
    }
  }
}

class Databases extends Expr {
  final Expr database;

  Databases([this.database]);

  String toJson() {
    return "{\"databases\":${database?.toJson()}}";
  }
}

class Classes extends Expr {
  final Expr scope;

  Classes(this.scope);

  String toJson() {
    return "{\"classes\":${scope.toJson()}}";
  }
}

class Collections extends Expr {
  final Expr scope;

  Collections([this.scope]);

  String toJson() {
    return "{\"collections\":${scope?.toJson()}}";
  }
}

class Indexes extends Expr {
  final Expr database;

  Indexes([this.database]);

  String toJson() {
    return "{\"indexes\":${database?.toJson()}}";
  }
}

class Functions extends Expr {
  final Expr database;

  Functions([this.database]);

  String toJson() {
    return "{\"functions\":${database?.toJson()}}";
  }
}

class Roles extends Expr {
  final Expr database;

  Roles([this.database]);

  String toJson() {
    return "{\"roles\":${database?.toJson()}}";
  }
}

class Keys extends Expr {
  final Expr database;

  Keys([this.database]);

  String toJson() {
    return "{\"keys\":${database?.toJson()}}";
  }
}

class Tokens extends Expr {
  final Expr database;

  Tokens([this.database]);

  String toJson() {
    return "{\"tokens\":${database?.toJson()}}";
  }
}

class Credentials extends Expr {
  final Expr database;

  Credentials([this.database]);

  String toJson() {
    return "{\"credentials\":${database?.toJson()}}";
  }
}

// class Equals extends Expr {
//     Equals(args: ExprArg[]) {}
// }
// class Contains extends Expr {
//     Contains(path: ExprArg, _in: ExprArg) {}
// }
// class Select extends Expr {
//     Select(path: ExprArg, from: ExprArg, _default?: ExprArg) {}
// }
// class SelectAll extends Expr {
//     SelectAll(path: ExprArg, from: ExprArg) {}
// }
// class Abs extends Expr {
//     Abs(expr: ExprArg) {}
// }

class Add extends Expr {
  final List<Expr> args;

  Add(Object items) : args = List<Expr>() {
    if (items is List) {
      items.forEach((item) {
        args.add(Expr.fromObject(item));
      });
    } else {
      args.add(Expr.fromObject(items));
    }
  }

  String toJson() {
    return "{\"add\":${Expr.fromObject(args.length > 1 ? args : args[0]).toJson()}}";
  }
}

// class BitAnd extends Expr {
//     BitAnd(args: ExprArg[]) {}
// }
// class BitNot extends Expr {
//     BitNot(expr: ExprArg) {}
// }
// class BitOr extends Expr {
//     BitOr(args: ExprArg[]) {}
// }
// class BitXor extends Expr {
//     BitXor(args: ExprArg[]) {}
// }
// class Ceil extends Expr {
//     Ceil(expr: ExprArg) {}
// }
// class Divide extends Expr {
//     Divide(args: ExprArg[]) {}
// }
// class Floor extends Expr {
//     Floor(expr: ExprArg) {}
// }
// class Max extends Expr {
//     Max(args: ExprArg[]) {}
// }
// class Min extends Expr {
//     Min(args: ExprArg[]) {}
// }
// class Modulo extends Expr {
//     Modulo(args: ExprArg[]) {}
// }
// class Multiply extends Expr {
//     Multiply(args: ExprArg[]) {}
// }
// class Round extends Expr {
//     Round(value: ExprArg, precision?: ExprArg) {}
// }
// class Subtract extends Expr {
//     Subtract(args: ExprArg[]) {}
// }
// class Sign extends Expr {
//     Sign(expr: ExprArg) {}
// }
// class Sqrt extends Expr {
//     Sqrt(expr: ExprArg) {}
// }
// class Trunc extends Expr {
//     Trunc(value: ExprArg, precision?: ExprArg) {}
// }
// class Count extends Expr {
//     Count(expr: ExprArg) {}
// }
// class Sum extends Expr {
//     Sum(expr: ExprArg) {}
// }
// class Mean extends Expr {
//     Mean(expr: ExprArg) {}
// }
// class Any extends Expr {
//     Any(expr: ExprArg) {}
// }
// class All extends Expr {
//     All(expr: ExprArg) {}
// }
// class Acos extends Expr {
//     Acos(expr: ExprArg) {}
// }
// class Asin extends Expr {
//     Asin(expr: ExprArg) {}
// }
// class Atan extends Expr {
//     Atan(expr: ExprArg) {}
// }
// class Cos extends Expr {
//     Cos(expr: ExprArg) {}
// }
// class Cosh extends Expr {
//     Cosh(expr: ExprArg) {}
// }
// class Degrees extends Expr {
//     Degrees(expr: ExprArg) {}
// }
// class Exp extends Expr {
//     Exp(expr: ExprArg) {}
// }
// class Hypot extends Expr {
//     Hypot(value: ExprArg, exp?: ExprArg) {}
// }
// class Ln extends Expr {
//     Ln(expr: ExprArg) {}
// }
// class Log extends Expr {
//     Log(expr: ExprArg) {}
// }
// class Pow extends Expr {
//     Pow(value: ExprArg, exp?: ExprArg) {}
// }
// class Radians extends Expr {
//     Radians(expr: ExprArg) {}
// }
// class Sin extends Expr {
//     Sin(expr: ExprArg) {}
// }
// class Sinh extends Expr {
//     Sinh(expr: ExprArg) {}
// }
// class Tan extends Expr {
//     Tan(expr: ExprArg) {}
// }
// class Tanh extends Expr {
//     Tanh(expr: ExprArg) {}
// }
// class LT extends Expr {
//     LT(args: ExprArg[]) {}
// }
// class LTE extends Expr {
//     LTE(args: ExprArg[]) {}
// }
// class GT extends Expr {
//     GT(args: ExprArg[]) {}
// }
// class GTE extends Expr {
//     GTE(args: ExprArg[]) {}
// }
// class And extends Expr {
//     And(args: ExprArg[]) {}
// }
// class Or extends Expr {
//     Or(args: ExprArg[]) {}
// }
// class Not extends Expr {
//     Not(bool: ExprArg) {}
// }

// class ToString extends Expr {
//     ToString(expr: ExprArg) {}
// }
// class ToNumber extends Expr {
//     ToNumber(expr: ExprArg) {}
// }
// class ToObject extends Expr {
//     ToObject(expr: ExprArg) {}
// }
// class ToArray extends Expr {
//     ToArray(expr: ExprArg) {}
// }
// class ToDouble extends Expr {
//     ToDouble(expr: ExprArg) {}
// }
// class ToInteger extends Expr {
//     ToInteger(expr: ExprArg) {}
// }
// class ToTime extends Expr {
//     ToTime(expr: ExprArg) {}
// }
// class ToDate extends Expr {
//     ToDate(expr: ExprArg) {}
// }
// class ToSeconds extends Expr {
//     ToSeconds(expr: ExprArg) {}
// }
// class ToMillis extends Expr {
//     ToMillis(expr: ExprArg) {}
// }
// class ToMicros extends Expr {
//     ToMicros(expr: ExprArg) {}
// }

// class MoveDatabase extends Expr {
//     MoveDatabase(from: ExprArg, to: ExprArg) {}
// }
// class Documents extends Expr {
//     Documents(collection: ExprArg) {}
// }
