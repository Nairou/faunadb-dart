library faunadb;

class FaunaClient {
  final String secret;

  FaunaClient({this.secret});

  Expr query(Expr parameter) {
    return parameter;
  }
}

class Expr {
  Object value;

  Expr(Object item) {
    value = item;
  }

  Expr.fromMap(Map<String, Object> parameters) {
    var values = Map<String, Expr>();
    parameters?.forEach((k, v) {
      values[k] = wrap(v);
    });

    value = values;
  }

  Expr.fromArray(List<Object> parameters) {
    var values = List<Expr>();
    parameters?.forEach((item) {
      values.add(wrap(item));
    });

    value = values;
  }

  String toJson() {
    if (value is Map) {
      var output = List<String>();
      (value as Map<String, Expr>).forEach((k, v) {
        output.add("\"$k\":${v.toJson()}");
      });
      return "{${output.join(",")}}";
    } else if (value is List) {
      var output = List<String>();
      (value as List<Expr>).forEach((item) {
        output.add(item.toJson());
      });
      return "[${output.join(",")}]";
    } else if (value is String) {
      return "\"${value.toString()}\"";
    }
    return value.toString();
  }
}

Expr wrap(Object item) {
  if (item is Expr) {
    return item;
  } else if (item is Map) {
    if (item.isEmpty) {
      return Expr({"object": Expr.fromMap(null)});
    }
    return Expr({"object": Expr.fromMap(item)});
  } else if (item is List) {
    return Expr.fromArray(item);
  } else {
    return Value(item);
  }
}

class Value extends Expr {
  Value(Object item) : super(item);
}

// class Ref extends Expr {
//     Ref(ref: ExprArg, id?: ExprArg) {}
// }
// class Bytes extends Expr {
//     Bytes(bytes: ExprArg | ArrayBuffer | Uint8Array) {}
// }
// class Abort extends Expr {
//     Abort(msg: ExprArg) {}
// }
// class At extends Expr {
//     At(timestamp: ExprArg, expr: ExprArg) {}
// }
// class Let extends Expr {
//     Let(vars: ExprArg, in_expr: ExprArg) {}
// }
// class Var extends Expr {
//     Var(varName: ExprArg) {}
// }
// class If extends Expr {
//     If(condition: ExprArg, then: ExprArg | null, _else: ExprArg | null) {}
// }
// class Do extends Expr {
//     Do(args: ExprArg[]) {}
// }
// class Object extends Expr {
//     Object(fields: ExprArg) {}
// }
// class Lambda extends Expr {
//     Lambda(f: Lambda) {}
// }
// class Lambda extends Expr {
//     Lambda(var_name: ExprArg, expr: ExprArg) {}
// }
// class Call extends Expr {
//     Call(ref: ExprArg, args: ExprArg[]) {}
// }
// class Query extends Expr {
//     Query(lambda: ExprArg | Lambda) {}
// }
// class Map extends Expr {
//     Map(collection: ExprArg, lambda_expr: ExprArg | Lambda) {}
// }
// class Merge extends Expr {
//     Merge(object: ExprArg, values: ExprArg, resolver?: Expr | Lambda) {}
// }
// class Foreach extends Expr {
//     Foreach(collection: ExprArg, lambda_expr: ExprArg | Lambda) {}
// }
// class Filter extends Expr {
//     Filter(collection: ExprArg, lambda_expr: ExprArg | Lambda) {}
// }
// class Take extends Expr {
//     Take(number: ExprArg, collection: ExprArg) {}
// }
// class Drop extends Expr {
//     Drop(number: ExprArg, collection: ExprArg) {}
// }
// class Prepend extends Expr {
//     Prepend(elements: ExprArg, collection: ExprArg) {}
// }
// class Append extends Expr {
//     Append(elements: ExprArg, collection: ExprArg) {}
// }
// class IsEmpty extends Expr {
//     IsEmpty(collection: ExprArg) {}
// }
// class IsNonEmpty extends Expr {
//     IsNonEmpty(collection: ExprArg) {}
// }
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
//     Get(ref: ExprArg, ts?: ExprArg) {}
// }
// class KeyFromSecret extends Expr {
//     KeyFromSecret(secret: ExprArg) {}
// }
// class Reduce extends Expr {
//     Reduce(lambda: ExprArg, initial: ExprArg, collection: ExprArg) {}
// }
// class Paginate extends Expr {
//     Paginate(set: ExprArg, opts?: object) {}
// }
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
  CreateDatabase(Map<String, Object> parameters) : super({"create_database": wrap(parameters)});
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

// class Time extends Expr {
//     Time(string: ExprArg) {}
// }
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
class Date extends Value {
  Date(String string) : super(null) {
    value = DateTime.tryParse(string);
  }
  Date.fromDateTime(DateTime date) : super(null) {
    value = date.toUtc();
  }

  String toJson() {
    DateTime date = value;
    var year = date.year.toString().padLeft(4, "0");
    var month = date.month.toString().padLeft(2, "0");
    var day = date.day.toString().padLeft(2, "0");
    return "{\"@date\":\"$year-$month-$day\"}";
  }
}
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
// class Database extends Expr {
//     Database(name: ExprArg, scope?: ExprArg) {}
// }
// class Index extends Expr {
//     Index(name: ExprArg, scope?: ExprArg) {}
// }
// class Class extends Expr {
//     Class(name: ExprArg, scope?: ExprArg) {}
// }
// class Collection extends Expr {
//     Collection(name: ExprArg, scope?: ExprArg) {}
// }
// class Function extends Expr {
//     Function(name: ExprArg, scope?: ExprArg) {}
// }
// class Role extends Expr {
//     Role(name: ExprArg, scope?: ExprArg) {}
// }
// class Databases extends Expr {
//     Databases(scope?: ExprArg) {}
// }
// class Classes extends Expr {
//     Classes(scope?: ExprArg) {}
// }
// class Collections extends Expr {
//     Collections(scope?: ExprArg) {}
// }
// class Indexes extends Expr {
//     Indexes(scope?: ExprArg) {}
// }
// class Functions extends Expr {
//     Functions(scope?: ExprArg) {}
// }
// class Roles extends Expr {
//     Roles(scope?: ExprArg) {}
// }
// class Keys extends Expr {
//     Keys(scope?: ExprArg) {}
// }
// class Tokens extends Expr {
//     Tokens(scope?: ExprArg) {}
// }
// class Credentials extends Expr {
//     Credentials(scope?: ExprArg) {}
// }
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
// class Add extends Expr {
//     Add(args: ExprArg[]) {}
// }
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
