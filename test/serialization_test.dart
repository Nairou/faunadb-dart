import 'package:flutter_test/flutter_test.dart';

import 'package:faunadb/faunadb.dart';

// Many of these test scenarios have been adapted from the official C# and JS
// drivers, to ensure comparable coverage.

void expectJson(Expr actual, String match) => expect(actual.toJson(), match);

void main() {
  test('TestLiteralValues', () {
    expectJson(Value(10), "10");
    expectJson(Value("a string"), "\"a string\"");
    expectJson(Value(3.14), "3.14");
    expectJson(Value(-1.0), "-1.0");
    expectJson(Value(true), "true");
    expectJson(Value(false), "false");
    expectJson(Value(null), "null");
  });

  test('TestArrayValues', () {
    expectJson(Expr.fromObject([10, 3.14, "a string", true, false, null]), "[10,3.14,\"a string\",true,false,null]");
  });

  test('TestObjectValues', () {
    expectJson(Expr.fromObject({}), "{\"object\":{}}");

    expectJson(Expr.fromObject({"k0": "v0", "k1": "v1"}), "{\"object\":{\"k0\":\"v0\",\"k1\":\"v1\"}}");

    expectJson(Expr.fromObject({"foo": "bar"}), "{\"object\":{\"foo\":\"bar\"}}");

    expectJson(Expr.fromObject({"long": 10, "double": 2.78}), "{\"object\":{\"long\":10,\"double\":2.78}}");
  });

  test('TestObjectAndArrays', () {
    expectJson(
        Expr.fromObject({
          "foo": ["bar"]
        }),
        "{\"object\":{\"foo\":[\"bar\"]}}");

    expectJson(
        Expr.fromObject({
          "foo": [
            "bar",
            {"foo": "bar"}
          ]
        }),
        "{\"object\":{\"foo\":[\"bar\",{\"object\":{\"foo\":\"bar\"}}]}}");
  });

  test('TestComplexObjects', () {
    expectJson(
        Expr.fromObject({
          "a": {
            "b": {"c": "d"}
          }
        }),
        "{\"object\":{\"a\":{\"object\":{\"b\":{\"object\":{\"c\":\"d\"}}}}}}");
  });

  test('TestRef', () {
    expectJson(Ref(Collection("people"), "id1"), "{\"ref\":{\"collection\":\"people\"},\"id\":\"id1\"}");
  });

//   test('TestTimestamp', () {
//     expectJson(Timestamp("1970-01-01T00:00:00Z"), "{\"@ts\":\"1970-01-01T00:00:00Z\"}");

//     expectJson(Timestamp.fromDateTime(DateTime.utc(1970, 1, 1, 0, 0, 0, 0)), "{\"@ts\":\"1970-01-01T00:00:00.000Z\"}");
//   });

//   test('TestDate', () {
//     expectJson(Date("2000-01-01"), "{\"@date\":\"2000-01-01\"}");

//     expectJson(Date.fromDateTime(DateTime(2000, 1, 1)), "{\"@date\":\"2000-01-01\"}");
//   });

//   test('TestBytes', () {
//     expectJson(Bytes([0x1, 0x2, 0x3, 0x4]), "{\"@bytes\":\"AQIDBA==\"}");

//     expectJson(Bytes([0x0, 0x0, 0x0, 0x0]), "{\"@bytes\":\"AAAAAA==\"}");
//   });

  test('TestAbort', () {
    expectJson(Abort("message"), "{\"abort\":\"message\"}");
  });

  test('TestAt', () {
    expectJson(At(1, Paginate(Collections())), "{\"at\":1,\"expr\":{\"paginate\":{\"collections\":null}}}");

    expectJson(At(Time("1970-01-01T00:00:00.000Z"), Paginate(Collections())), "{\"at\":{\"time\":\"1970-01-01T00:00:00.000Z\"},\"expr\":{\"paginate\":{\"collections\":null}}}");
  });

  test('TestLet', () {
    expectJson(Let({"x": 10}, Var("x")), "{\"let\":[{\"x\":10}],\"in\":{\"var\":\"x\"}}");

    expectJson(Let({"x": 10, "y": 20}, Add([Var("x"), Var("y")])), "{\"let\":[{\"x\":10},{\"y\":20}],\"in\":{\"add\":[{\"var\":\"x\"},{\"var\":\"y\"}]}}");
  });

  test('TestVar', () {
    expectJson(Var("x"), "{\"var\":\"x\"}");
  });

  test('TestIf', () {
    expectJson(If(true, 1, 0), "{\"if\":true,\"then\":1,\"else\":0}");
  });

  test('TestDo', () {
    expectJson(Do([If(true, 1, 0), "a string"]), "{\"do\":[{\"if\":true,\"then\":1,\"else\":0},\"a string\"]}");
  });

  test('TestLamda', () {
    expectJson(Lambda("x", Var("x")), "{\"lambda\":\"x\",\"expr\":{\"var\":\"x\"}}");

    expectJson(Lambda(["x", "y"], Add([Var("x"), Var("y")])), "{\"lambda\":[\"x\",\"y\"],\"expr\":{\"add\":[{\"var\":\"x\"},{\"var\":\"y\"}]}}");
  });

  test('TestMap', () {
    expectJson(Map_([1, 2, 3], Lambda("x", Var("x"))), "{\"map\":{\"lambda\":\"x\",\"expr\":{\"var\":\"x\"}},\"collection\":[1,2,3]}");

    expectJson(
        Map_([
          [1, 2],
          [3, 4]
        ], Lambda(["x", "y"], Add([Var("x"), Var("y")]))),
        "{\"map\":{\"lambda\":[\"x\",\"y\"],\"expr\":{\"add\":[{\"var\":\"x\"},{\"var\":\"y\"}]}},\"collection\":[[1,2],[3,4]]}");
  });

  test('TestForeach', () {
    expectJson(Foreach([1, 2, 3], Lambda("x", Var("x"))), "{\"foreach\":{\"lambda\":\"x\",\"expr\":{\"var\":\"x\"}},\"collection\":[1,2,3]}");

    expectJson(
        Foreach([
          [1, 2],
          [3, 4]
        ], Lambda(["x", "y"], Add([Var("x"), Var("y")]))),
        "{\"foreach\":{\"lambda\":[\"x\",\"y\"],\"expr\":{\"add\":[{\"var\":\"x\"},{\"var\":\"y\"}]}},\"collection\":[[1,2],[3,4]]}");
  });

  test('TestFilter', () {
    expectJson(Filter([1, 2, 3], Lambda("x", Var("x"))), "{\"filter\":{\"lambda\":\"x\",\"expr\":{\"var\":\"x\"}},\"collection\":[1,2,3]}");

    expectJson(
        Filter([
          [1, 2],
          [3, 4]
        ], Lambda(["x", "y"], Add([Var("x"), Var("y")]))),
        "{\"filter\":{\"lambda\":[\"x\",\"y\"],\"expr\":{\"add\":[{\"var\":\"x\"},{\"var\":\"y\"}]}},\"collection\":[[1,2],[3,4]]}");
  });

  test('TestTake', () {
    expectJson(Take(2, [1, 2, 3]), "{\"take\":2,\"collection\":[1,2,3]}");
  });

  test('TestDrop', () {
    expectJson(Drop(1, [1, 2, 3]), "{\"drop\":1,\"collection\":[1,2,3]}");
  });

  test('TestPrepend', () {
    expectJson(Prepend([1, 2, 3], [4, 5, 6]), "{\"prepend\":[1,2,3],\"collection\":[4,5,6]}");
  });

  test('TestAppend', () {
    expectJson(Append([1, 2, 3], [4, 5, 6]), "{\"append\":[1,2,3],\"collection\":[4,5,6]}");
  });

  test('TestIsEmpty', () {
    expectJson(IsEmpty([1, 2, 3]), "{\"is_empty\":[1,2,3]}");
  });

  test('TestIsNonEmpty', () {
    expectJson(IsNonEmpty([1, 2, 3]), "{\"is_nonempty\":[1,2,3]}");
  });

//   test('TestGet', () {
//     expectJson(Get(Ref(Collection("thing"), "123456789")), "{\"get\":{\"ref\":{\"collection\":\"thing\"},\"id\":\"123456789\"}}");
//   });

//   test('TestKeyFromSecret', () {
//     expectJson(KeyFromSecret("s3cr3t"), "{\"key_from_secret\":\"s3cr3t\"}");
//   });

  test('TestPaginate', () {
    expectJson(Paginate(Databases()), "{\"paginate\":{\"databases\":null}}");

    expectJson(Paginate(Databases(), after: Ref(Collection("thing"), "123456789")), "{\"paginate\":{\"databases\":null},\"after\":{\"ref\":{\"collection\":\"thing\"},\"id\":\"123456789\"}}");

    expectJson(Paginate(Databases(), before: Ref(Collection("thing"), "123456789")), "{\"paginate\":{\"databases\":null},\"before\":{\"ref\":{\"collection\":\"thing\"},\"id\":\"123456789\"}}");

    expectJson(Paginate(Databases(), ts: Time("1970-01-01T00:00:00Z")), "{\"paginate\":{\"databases\":null},\"ts\":{\"time\":\"1970-01-01T00:00:00.000Z\"}}");

    expectJson(Paginate(Databases(), size: 10), "{\"paginate\":{\"databases\":null},\"size\":10}");

    expectJson(Paginate(Databases(), events: true), "{\"paginate\":{\"databases\":null},\"events\":true}");

    expectJson(Paginate(Databases(), sources: true), "{\"paginate\":{\"databases\":null},\"sources\":true}");
  });

// test('TestExists', ()
// {
//     expectJson(Exists(Ref(Collection("thing"), "123456789")),
//         "{\"exists\":{\"ref\":{\"collection\":\"thing\"},\"id\":\"123456789\"}}");

//     expectJson(Exists(Ref(Collection("thing"), "123456789"), Time("1970-01-01T00:00:00.123Z")),
//         "{\"exists\":{\"ref\":{\"collection\":\"thing\"},\"id\":\"123456789\"},\"ts\":{\"time\":\"1970-01-01T00:00:00.123Z\"}}");
// });

// test('TestCreate', ()
// {
//     expectJson(
//         Create(Collection("widgets"), Expr.fromObject("data", "some-data")),
//         "{\"create\":{\"collection\":\"widgets\"},\"params\":{\"object\":{\"data\":\"some-data\"}}}");
// });

// test('TestUpdate', ()
// {
//     expectJson(
//         Update(Ref(Collection("widgets"), "123456789"), Expr.fromObject("name", "things")),
//         "{\"update\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"},\"params\":{\"object\":{\"name\":\"things\"}}}");
// });

// test('TestReplace', ()
// {
//     expectJson(
//         Replace(Ref(Collection("widgets"), "123456789"), Expr.fromObject("data", Expr.fromObject("name", "Computer"))),
//         "{\"replace\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"},\"params\":{\"object\":{\"data\":{\"object\":{\"name\":\"Computer\"}}}}}");
// });

// test('TestDelete', ()
// {
//     expectJson(
//         Delete(Ref(Collection("widgets"), "123456789")),
//         "{\"delete\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"}}");
// });

// test('TestInsert', ()
// {
//     expectJson(
//         Insert(
//             Ref(Collection("widgets"), "123456789"),
//             Time("1970-01-01T00:00:00.123Z"),
//             "create",
//             Expr.fromObject("data", Expr.fromObject("name", "Computer"))),
//         "{\"insert\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"}," +
//         "\"ts\":{\"time\":\"1970-01-01T00:00:00.123Z\"}," +
//         "\"action\":\"create\"," +
//         "\"params\":{\"object\":{\"data\":{\"object\":{\"name\":\"Computer\"}}}}}");

//     expectJson(
//         Insert(
//             Ref(Collection("widgets"), "123456789"),
//             Time("1970-01-01T00:00:00.123Z"),
//             ActionType.Create,
//             Expr.fromObject("data", Expr.fromObject("name", "Computer"))),
//         "{\"insert\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"},"+
//         "\"ts\":{\"time\":\"1970-01-01T00:00:00.123Z\"},"+
//         "\"action\":\"create\","+
//         "\"params\":{\"object\":{\"data\":{\"object\":{\"name\":\"Computer\"}}}}}");
// });

// test('TestRemove', ()
// {
//     expectJson(
//         Remove(
//             Ref(Collection("widgets"), "123456789"),
//             Time("1970-01-01T00:00:00.123Z"),
//             "create"),
//         "{\"remove\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"},"+
//         "\"ts\":{\"time\":\"1970-01-01T00:00:00.123Z\"}," +
//         "\"action\":\"create\"}");

//     expectJson(
//         Remove(
//             Ref(Collection("widgets"), "123456789"),
//             Time("1970-01-01T00:00:00.123Z"),
//             ActionType.Create),
//         "{\"remove\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"}," +
//         "\"ts\":{\"time\":\"1970-01-01T00:00:00.123Z\"}," +
//         "\"action\":\"create\"}");
// });

// test('TestCreateClass', ()
// {
//     expectJson(CreateCollection(Expr.fromObject("name", "class_name")),
//         "{\"create_collection\":{\"object\":{\"name\":\"class_name\"}}}");
// });

  test('TestCreateDatabase', () {
    expectJson(CreateDatabase({"name": "db_name"}), "{\"create_database\":{\"object\":{\"name\":\"db_name\"}}}");
  });

// test('TestCreateIndex', ()
// {
//     expectJson(
//         CreateIndex(Expr.fromObject("name", "index_name", "source", Collection("class_name"))),
//         "{\"create_index\":{\"object\":{\"name\":\"index_name\",\"source\":{\"collection\":\"class_name\"}}}}");
// });

// test('TestCreateKey', ()
// {
//     expectJson(
//         CreateKey(Expr.fromObject("database", Database("db_name"), "role", "client")),
//         "{\"create_key\":{\"object\":{\"database\":{\"database\":\"db_name\"},\"role\":\"client\"}}}");
// });

// test('TestCreateRole', ()
// {
//     expectJson(
//         CreateRole(Expr.fromObject(
//             "name", "role_name",
//             "privileges", makeArray(Expr.fromObject(
//                 "resource", Databases(),
//                 "actions", Expr.fromObject("read", true)
//             ))
//         )),
//         "{\"create_role\":{\"object\":{\"name\":\"role_name\",\"privileges\":[{\"object\":{" +
//         "\"resource\":{\"databases\":null},\"actions\":{\"object\":{\"read\":true}}}}]}}}");

//     expectJson(
//         CreateRole(Expr.fromObject(
//             "name", "role_name",
//             "privileges", Expr.fromObject(
//                 "resource", Databases(),
//                 "actions", Expr.fromObject("read", true)
//             )
//         )),
//         "{\"create_role\":{\"object\":{\"name\":\"role_name\",\"privileges\":{\"object\":{" +
//         "\"resource\":{\"databases\":null},\"actions\":{\"object\":{\"read\":true}}}}}}}");
// });

// test('TestSingleton', ()
// {
//     expectJson(
//         Singleton(Ref(Collection("widget"), "123")),
//         "{\"singleton\":{\"ref\":{\"collection\":\"widget\"},\"id\":\"123\"}}");
// });

// test('TestEvents', ()
// {
//     expectJson(
//         Events(Ref(Collection("widget"), "123")),
//         "{\"events\":{\"ref\":{\"collection\":\"widget\"},\"id\":\"123\"}}");
// });

// test('TestMatch', ()
// {
//     expectJson(
//         Match(Index("all_the_things")),
//         "{\"match\":{\"index\":\"all_the_things\"}}");

//     expectJson(
//         Match(Index("widgets_by_name"), "Computer"),
//         "{\"match\":{\"index\":\"widgets_by_name\"},\"terms\":\"Computer\"}");

//     expectJson(
//         Match(Index("widgets_by_name"), "Computer", "Monitor"),
//         "{\"match\":{\"index\":\"widgets_by_name\"},\"terms\":[\"Computer\",\"Monitor\"]}");
// });

// test('TestUnion', ()
// {
//     expectJson(
//         Union(Native.DATABASES),
//         "{\"union\":{\"@ref\":{\"id\":\"databases\"}}}");

//     expectJson(
//         Union(Native.DATABASES, Collection("widgets")),
//         "{\"union\":[{\"@ref\":{\"id\":\"databases\"}},{\"collection\":\"widgets\"}]}");
// });

// test('TestIntersection', ()
// {
//     expectJson(
//         Intersection(Native.DATABASES),
//         "{\"intersection\":{\"@ref\":{\"id\":\"databases\"}}}");

//     expectJson(
//         Intersection(Native.DATABASES, Collection("widgets")),
//         "{\"intersection\":[{\"@ref\":{\"id\":\"databases\"}},{\"collection\":\"widgets\"}]}");
// });

// test('TestDifference', ()
// {
//     expectJson(
//         Difference(Native.DATABASES),
//         "{\"difference\":{\"@ref\":{\"id\":\"databases\"}}}");

//     expectJson(
//         Difference(Native.DATABASES, Collection("widgets")),
//         "{\"difference\":[{\"@ref\":{\"id\":\"databases\"}},{\"collection\":\"widgets\"}]}");
// });

// test('TestDistinct', ()
// {
//     expectJson(Distinct(Match(Index("widgets"))),
//         "{\"distinct\":{\"match\":{\"index\":\"widgets\"}}}");
// });

// test('TestJoin', ()
// {
//     expectJson(Join(Match(Index("widgets")), Index("other_widgets")),
//         "{\"join\":{\"match\":{\"index\":\"widgets\"}}," +
//         "\"with\":{\"index\":\"other_widgets\"}}");

//     expectJson(Join(Match(Index("widgets")), widget => Match(Index("widgets"), widget)),
//         "{\"join\":{\"match\":{\"index\":\"widgets\"}}," +
//         "\"with\":{\"lambda\":\"widget\",\"expr\":{\"match\":{\"index\":\"widgets\"},\"terms\":{\"var\":\"widget\"}}}}");
// });

// test('TestLogin', ()
// {
//     expectJson(Login(Ref(Collection("widgets"), "123456789"), Expr.fromObject("password", "P455w0rd")),
//           "{\"login\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"},\"params\":{\"object\":{\"password\":\"P455w0rd\"}}}");
// });

// test('TestLogout', ()
// {
//     expectJson(Logout(true), "{\"logout\":true}");
//     expectJson(Logout(false), "{\"logout\":false}");
// });

// test('TestIdentify', ()
// {
//     expectJson(Identify(Ref(Collection("widgets"), "123456789"), "P455w0rd"),
//         "{\"identify\":{\"ref\":{\"collection\":\"widgets\"},\"id\":\"123456789\"},\"password\":\"P455w0rd\"}");
// });

// test('TestIdentity', ()
// {
//     expectJson(Identity(),
//         "{\"identity\":null}");
// });

// test('TestHasIdentity', ()
// {
//     expectJson(HasIdentity(),
//         "{\"has_identity\":null}");
// });

// test('TestConcat', ()
// {
//     expectJson(Concat("str"),
//         "{\"concat\":\"str\"}");

//     expectJson(Concat("str", "/"),
//         "{\"concat\":\"str\",\"separator\":\"/\"}");

//     expectJson(Concat(makeArray("str0", "str1")),
//         "{\"concat\":[\"str0\",\"str1\"]}");

//     expectJson(Concat(makeArray("str0", "str1"), "/"),
//         "{\"concat\":[\"str0\",\"str1\"],\"separator\":\"/\"}");
// });

// test('TestCasefold', ()
// {
//     expectJson(Casefold("a string"),
//         "{\"casefold\":\"a string\"}");

//     expectJson(Casefold("a string", "NFD"),
//         "{\"casefold\":\"a string\",\"normalizer\":\"NFD\"}");

//     expectJson(Casefold("a string", Normalizer.NFD),
//         "{\"casefold\":\"a string\",\"normalizer\":\"NFD\"}");
// });

// test('TestNGram', ()
// {
//     expectJson(NGram("str"),
//         "{\"ngram\":\"str\"}");
//     expectJson(NGram("str", min: 1),
//         "{\"ngram\":\"str\",\"min\":1}");
//     expectJson(NGram("str", max: 2),
//         "{\"ngram\":\"str\",\"max\":2}");
//     expectJson(NGram("str", min: 1, max: 2),
//         "{\"ngram\":\"str\",\"min\":1,\"max\":2}");
// });

//   test('TestTime', () {
//     expectJson(Time("1970-01-01T00:00:00+00:00"), "{\"time\":\"1970-01-01T00:00:00+00:00\"}");

//     expectJson(Time("now"), "{\"time\":\"now\"}");
//   });

// test('TestEpoch', ()
// {
//     expectJson(Epoch(1, "second"),
//         "{\"epoch\":1,\"unit\":\"second\"}");

//     expectJson(Epoch(1, "millisecond"),
//         "{\"epoch\":1,\"unit\":\"millisecond\"}");

//     expectJson(Epoch(1, "microsecond"),
//         "{\"epoch\":1,\"unit\":\"microsecond\"}");

//     expectJson(Epoch(1, "nanosecond"),
//         "{\"epoch\":1,\"unit\":\"nanosecond\"}");

//     expectJson(Epoch(1, TimeUnit.Second),
//         "{\"epoch\":1,\"unit\":\"second\"}");

//     expectJson(Epoch(1, TimeUnit.Millisecond),
//         "{\"epoch\":1,\"unit\":\"millisecond\"}");

//     expectJson(Epoch(1, TimeUnit.Microsecond),
//         "{\"epoch\":1,\"unit\":\"microsecond\"}");

//     expectJson(Epoch(1, TimeUnit.Nanosecond),
//         "{\"epoch\":1,\"unit\":\"nanosecond\"}");
// });

// test('TestDateFn', ()
// {
//     expectJson(Date("1970-01-01"),
//         "{\"date\":\"1970-01-01\"}");
// });

// test('TestNewId', ()
// {
//     expectJson(NewId(),
//         "{\"new_id\":null}");
// });

//   test('TestDatabase', () {
//     expectJson(Database("db_name"), "{\"database\":\"db_name\"}");
//     expectJson(Database("db_name", Database("scope")), "{\"database\":\"db_name\",\"scope\":{\"database\":\"scope\"}}");
//   });

//   test('TestIndex', () {
//     expectJson(Index("index_name"), "{\"index\":\"index_name\"}");
//     expectJson(Index("index_name", Database("scope")), "{\"index\":\"index_name\",\"scope\":{\"database\":\"scope\"}}");
//   });

//   test('TestClass', () {
//     expectJson(Collection("class_name"), "{\"collection\":\"class_name\"}");
//     expectJson(Collection("class_name", Database("scope")), "{\"collection\":\"class_name\",\"scope\":{\"database\":\"scope\"}}");
//   });

//   test('TestFunction', () {
//     expectJson(Function("function_name"), "{\"function\":\"function_name\"}");
//     expectJson(Function("function_name", Database("scope")), "{\"function\":\"function_name\",\"scope\":{\"database\":\"scope\"}}");
//   });

//   test('TestRole', () {
//     expectJson(Role("role_name"), "{\"role\":\"role_name\"}");
//     expectJson(Role("role_name", Database("scope")), "{\"role\":\"role_name\",\"scope\":{\"database\":\"scope\"}}");
//   });

  test('TestNativeRefs', () {
    expectJson(Collections(), "{\"collections\":null}");
    expectJson(Databases(), "{\"databases\":null}");
    expectJson(Indexes(), "{\"indexes\":null}");
    expectJson(Functions(), "{\"functions\":null}");
    expectJson(Keys(), "{\"keys\":null}");
    expectJson(Tokens(), "{\"tokens\":null}");
    expectJson(Credentials(), "{\"credentials\":null}");
    expectJson(Roles(), "{\"roles\":null}");

    expectJson(Collections(Database("scope")), "{\"collections\":{\"database\":\"scope\"}}");
    expectJson(Databases(Database("scope")), "{\"databases\":{\"database\":\"scope\"}}");
    expectJson(Indexes(Database("scope")), "{\"indexes\":{\"database\":\"scope\"}}");
    expectJson(Functions(Database("scope")), "{\"functions\":{\"database\":\"scope\"}}");
    expectJson(Keys(Database("scope")), "{\"keys\":{\"database\":\"scope\"}}");
    expectJson(Tokens(Database("scope")), "{\"tokens\":{\"database\":\"scope\"}}");
    expectJson(Credentials(Database("scope")), "{\"credentials\":{\"database\":\"scope\"}}");
    expectJson(Roles(Database("scope")), "{\"roles\":{\"database\":\"scope\"}}");
  });

// test('TestEquals', ()
// {
//     expectJson(EqualsFn("value"),
//         "{\"equals\":\"value\"}");

//     expectJson(EqualsFn("value", 10),
//         "{\"equals\":[\"value\",10]}");
// });

// test('TestContains', ()
// {
//     expectJson(Contains(makeArray("favorites", "foods"), Expr.fromObject("favorites", Expr.fromObject("foods", makeArray("crunchings", "munchings", "lunchings")))),
//         "{\"contains\":[\"favorites\",\"foods\"],\"in\":{\"object\":{\"favorites\":{\"object\":{\"foods\":[\"crunchings\",\"munchings\",\"lunchings\"]}}}}}");
// });

// test('TestSelect', ()
// {
//     expectJson(Select(makeArray("favorites", "foods", 1), Expr.fromObject("favorites", Expr.fromObject("foods", makeArray("crunchings", "munchings", "lunchings")))),
//         "{\"select\":[\"favorites\",\"foods\",1]," +
//         "\"from\":{\"object\":{\"favorites\":{\"object\":{\"foods\":[\"crunchings\",\"munchings\",\"lunchings\"]}}}}}");

//     expectJson(Select(makeArray("favorites", "foods", 1), Expr.fromObject("favorites", Expr.fromObject("foods", makeArray("crunchings", "munchings", "lunchings"))), "defaultValue"),
//         "{\"select\":[\"favorites\",\"foods\",1]," +
//         "\"from\":{\"object\":{\"favorites\":{\"object\":{\"foods\":[\"crunchings\",\"munchings\",\"lunchings\"]}}}}," +
//         "\"default\":\"defaultValue\"}");
// });

// test('TestSelectAll', ()
// {
//     expectJson(SelectAll("foo", Expr.fromObject("foo", "bar")),
//         "{\"select_all\":\"foo\",\"from\":{\"object\":{\"foo\":\"bar\"}}}");
// });

  test('TestAdd', () {
    expectJson(Add(1), "{\"add\":1}");
    expectJson(Add([1, 2]), "{\"add\":[1,2]}");
  });

// test('TestMultiply', ()
// {
//     expectJson(Multiply(1), "{\"multiply\":1}");
//     expectJson(Multiply(1, 2), "{\"multiply\":[1,2]}");
// });

// test('TestSubtract', ()
// {
//     expectJson(Subtract(1), "{\"subtract\":1}");
//     expectJson(Subtract(1, 2), "{\"subtract\":[1,2]}");
// });

// test('TestDivide', ()
// {
//     expectJson(Divide(1), "{\"divide\":1}");
//     expectJson(Divide(1, 2), "{\"divide\":[1,2]}");
// });

// test('TestModulo', ()
// {
//     expectJson(Modulo(1), "{\"modulo\":1}");
//     expectJson(Modulo(1, 2), "{\"modulo\":[1,2]}");
// });

// test('TestLT', ()
// {
//     expectJson(LT(1), "{\"lt\":1}");
//     expectJson(LT(1, 2), "{\"lt\":[1,2]}");
// });

// test('TestLTE', ()
// {
//     expectJson(LTE(1), "{\"lte\":1}");
//     expectJson(LTE(1, 2), "{\"lte\":[1,2]}");
// });

// test('TestGT', ()
// {
//     expectJson(GT(1), "{\"gt\":1}");
//     expectJson(GT(1, 2), "{\"gt\":[1,2]}");
// });

// test('TestGTE', ()
// {
//     expectJson(GTE(1), "{\"gte\":1}");
//     expectJson(GTE(1, 2), "{\"gte\":[1,2]}");
// });

// test('TestAnd', ()
// {
//     expectJson(And(false), "{\"and\":false}");
//     expectJson(And(true, false), "{\"and\":[true,false]}");
// });

// test('TestOr', ()
// {
//     expectJson(Or(true), "{\"or\":true}");
//     expectJson(Or(true, false), "{\"or\":[true,false]}");
// });

// test('TestNot', ()
// {
//     expectJson(Not(true), "{\"not\":true}");
//     expectJson(Not(false), "{\"not\":false}");
// });

// test('TestToStringExpr', ()
// {
//     expectJson(ToStringExpr(42), "{\"to_string\":42}");
// });

// test('TestToNumber', ()
// {
//     expectJson(ToNumber("42"), "{\"to_number\":\"42\"}");
// });

// test('TestToTime', ()
// {
//     expectJson(ToTime("1970-01-01T00:00:00Z"),
//                     "{\"to_time\":\"1970-01-01T00:00:00Z\"}");
// });

// test('TestToDate', ()
// {
//     expectJson(ToDate("1970-01-01"), "{\"to_date\":\"1970-01-01\"}");
// });

// [Test]
// public void TestInstanceRef()
// {
//     expectJson(
//         RefV(
//             id: "123456789",
//             collection: RefV(id: "child-class", collection: Native.COLLECTIONS)),
//         "{\"@ref\":{\"id\":\"123456789\",\"collection\":{\"@ref\":{\"id\":\"child-class\",\"collection\":{\"@ref\":{\"id\":\"collections\"}}}}}}"
//     );

//     expectJson(
//         RefV(
//             id: "123456789",
//             collection: RefV(
//                 id: "child-class",
//                 collection: Native.COLLECTIONS,
//                 database: RefV(id: "child-database", collection: Native.DATABASES))),
//         "{\"@ref\":{\"id\":\"123456789\",\"collection\":{\"@ref\":{\"id\":\"child-class\",\"collection\":{\"@ref\":{\"id\":\"collections\"}},\"database\":{\"@ref\":{\"id\":\"child-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}}}}}"
//     );
// });

// [Test]
// public void TestClassRef()
// {
//     expectJson(
//         RefV(id: "a-class", collection: Native.COLLECTIONS),
//         "{\"@ref\":{\"id\":\"a-class\",\"collection\":{\"@ref\":{\"id\":\"collections\"}}}}"
//     );

//     expectJson(
//         RefV(id: "a-class", collection: Native.COLLECTIONS, database: RefV(id: "a-database", collection: Native.DATABASES)),
//         "{\"@ref\":{\"id\":\"a-class\",\"collection\":{\"@ref\":{\"id\":\"collections\"}},\"database\":{\"@ref\":{\"id\":\"a-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}}}"
//     );
// });

// [Test]
// public void TestDatabaseRef()
// {
//     expectJson(
//         RefV(id: "a-database", collection: Native.DATABASES),
//         "{\"@ref\":{\"id\":\"a-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}"
//     );

//     expectJson(
//         RefV(id: "child-database", collection: Native.DATABASES, database: RefV(id: "parent-database", collection: Native.DATABASES)),
//         "{\"@ref\":{\"id\":\"child-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}},\"database\":{\"@ref\":{\"id\":\"parent-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}}}"
//     );
// });

// [Test]
// public void TestIndexRef()
// {
//     expectJson(
//         RefV(id: "a-index", collection: Native.INDEXES),
//         "{\"@ref\":{\"id\":\"a-index\",\"collection\":{\"@ref\":{\"id\":\"indexes\"}}}}"
//     );

//     expectJson(
//         RefV(id: "a-index", collection: Native.INDEXES, database: RefV(id: "a-database", collection: Native.DATABASES)),
//         "{\"@ref\":{\"id\":\"a-index\",\"collection\":{\"@ref\":{\"id\":\"indexes\"}},\"database\":{\"@ref\":{\"id\":\"a-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}}}"
//     );
// });

// [Test]
// public void TestKeyRef()
// {
//     expectJson(
//         RefV(id: "a-key", collection: Native.KEYS),
//         "{\"@ref\":{\"id\":\"a-key\",\"collection\":{\"@ref\":{\"id\":\"keys\"}}}}"
//     );

//     expectJson(
//         RefV(id: "a-key", collection: Native.KEYS, database: RefV(id: "a-database", collection: Native.DATABASES)),
//         "{\"@ref\":{\"id\":\"a-key\",\"collection\":{\"@ref\":{\"id\":\"keys\"}},\"database\":{\"@ref\":{\"id\":\"a-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}}}"
//     );
// });

// [Test]
// public void TestFunctionRef()
// {
//     expectJson(
//         RefV(id: "a-function", collection: Native.FUNCTIONS),
//         "{\"@ref\":{\"id\":\"a-function\",\"collection\":{\"@ref\":{\"id\":\"functions\"}}}}"
//     );

//     expectJson(
//         RefV(id: "a-function", collection: Native.FUNCTIONS, database: RefV(id: "a-database", collection: Native.DATABASES)),
//         "{\"@ref\":{\"id\":\"a-function\",\"collection\":{\"@ref\":{\"id\":\"functions\"}},\"database\":{\"@ref\":{\"id\":\"a-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}}}"
//     );
// });

// [Test]
// public void TestRoleRef()
// {
//     expectJson(
//         RefV(id: "a-role", collection: Native.ROLES),
//         "{\"@ref\":{\"id\":\"a-role\",\"collection\":{\"@ref\":{\"id\":\"roles\"}}}}"
//     );

//     expectJson(
//         RefV(id: "a-role", collection: Native.ROLES, database: RefV(id: "a-database", collection: Native.DATABASES)),
//         "{\"@ref\":{\"id\":\"a-role\",\"collection\":{\"@ref\":{\"id\":\"roles\"}},\"database\":{\"@ref\":{\"id\":\"a-database\",\"collection\":{\"@ref\":{\"id\":\"databases\"}}}}}}"
//     );
// });

  test('TestQuery', () {
    expectJson(Query(Lambda("x", Add([Var("x"), 1]))), "{\"query\":{\"lambda\":\"x\",\"expr\":{\"add\":[{\"var\":\"x\"},1]}}}");
  });

// [Test]
// public void TestHandleNulls()
// {
//     expectJson(Year(null), "{\"year\":null}");
//     expectJson(Expr.fromObject("key", null), "{\"object\":{\"key\":null}}");
//     expectJson(makeArray("str", null, 10), "[\"str\",null,10]");
//     expectJson(Let("key", null).In(Var("key")), "{\"let\":[{\"key\":null}],\"in\":{\"var\":\"key\"}}");
//     expectJson(Add(Expr[] { null }), "{\"add\":null}");
//     expectJson(Add(Expr[] { null, null }), "{\"add\":[null,null]}");
//     expectJson(Add(null), "{\"add\":null}");
//     expectJson(Add(null, null), "{\"add\":[null,null]}");
// });

  test('TestMergeFunction', () {
    expectJson(Merge({"x": 10}, {"y": 20}), "{\"merge\":{\"object\":{\"x\":10}},\"with\":{\"object\":{\"y\":20}}}");

    expectJson(Merge({"x": 10}, {"y": 20}, Lambda("x", Var("x"))), "{\"merge\":{\"object\":{\"x\":10}},\"with\":{\"object\":{\"y\":20}},\"lambda\":{\"lambda\":\"x\",\"expr\":{\"var\":\"x\"}}}");
  });

// [Test]
// public void TestFormatFunction()
// {
//     expectJson(
//         Format("%f %d", 3.14, 10),
//         "{\"format\":\"%f %d\",\"values\":[3.14,10]}"
//     );
// });

// [Test]
// public void TestRangeFunction()
// {
//     expectJson(
//         Range(Match(Index("some_index")), 1, 10),
//         "{\"range\":{\"match\":{\"index\":\"some_index\"}},\"from\":1,\"to\":10}");
// });

// [Test]
// public void TestMathFunctions()
// {
//     expectJson(Abs(-100), "{\"abs\":-100}");
//     expectJson(Abs(-100L), "{\"abs\":-100}");
//     expectJson(Abs(-100.0), "{\"abs\":-100.0}");

//     expectJson(Acos(0), "{\"acos\":0}");
//     expectJson(Acos(0.0), "{\"acos\":0.0}");

//     expectJson(Asin(0), "{\"asin\":0}");
//     expectJson(Asin(0.0), "{\"asin\":0.0}");

//     expectJson(Atan(0), "{\"atan\":0}");

//     expectJson(BitAnd(7, 3), "{\"bitand\":[7,3]}");

//     expectJson(BitNot(-1), "{\"bitnot\":-1}");

//     expectJson(BitOr(7, 3), "{\"bitor\":[7,3]}");

//     expectJson(BitXor(7, 3), "{\"bitxor\":[7,3]}");

//     expectJson(Ceil(123.456), "{\"ceil\":123.456}");

//     expectJson(Cos(1), "{\"cos\":1}");

//     expectJson(Cosh(1), "{\"cosh\":1}");

//     expectJson(Degrees(1), "{\"degrees\":1}");

//     expectJson(Exp(1), "{\"exp\":1}");

//     expectJson(Floor(1), "{\"floor\":1}");

//     expectJson(Hypot(3, 4), "{\"hypot\":3,\"b\":4}");

//     expectJson(Ln(1), "{\"ln\":1}");

//     expectJson(Log(1), "{\"log\":1}");

//     expectJson(Max(100, 10), "{\"max\":[100,10]}");
//     expectJson(Max(makeArray(100, 10)), "{\"max\":[100,10]}");

//     expectJson(Min(100, 10), "{\"min\":[100,10]}");
//     expectJson(Min(makeArray(100, 10)), "{\"min\":[100,10]}");

//     expectJson(Multiply(100, 10), "{\"multiply\":[100,10]}");
//     expectJson(Multiply(makeArray(100, 10)), "{\"multiply\":[100,10]}");

//     expectJson(Pow(4), "{\"pow\":4}");
//     expectJson(Pow(8, 3), "{\"pow\":8,\"exp\":3}");

//     expectJson(Radians(1), "{\"radians\":1}");

//     expectJson(Round(123.456), "{\"round\":123.456}");
//     expectJson(Round(555.666, 2), "{\"round\":555.666,\"precision\":2}");

//     expectJson(Sign(1), "{\"sign\":1}");

//     expectJson(Sin(1), "{\"sin\":1}");

//     expectJson(Sinh(1), "{\"sinh\":1}");

//     expectJson(Sqrt(1), "{\"sqrt\":1}");

//     expectJson(Subtract(100, 10), "{\"subtract\":[100,10]}");
//     expectJson(Subtract(makeArray(100, 10)), "{\"subtract\":[100,10]}");

//     expectJson(Tan(1), "{\"tan\":1}");

//     expectJson(Tanh(1), "{\"tanh\":1}");

//     expectJson(Trunc(1), "{\"trunc\":1}");
//     expectJson(Trunc(123.456, 2), "{\"trunc\":123.456,\"precision\":2}");
// });

// [Test]
// public void TestStringFunctions()
// {
//     expectJson(FindStr("ABCDEF", "ABC"), "{\"findstr\":\"ABCDEF\",\"find\":\"ABC\"}");
//     expectJson(FindStr("ABCDEF", "ABC", 1), "{\"findstr\":\"ABCDEF\",\"find\":\"ABC\",\"start\":1}");

//     expectJson(FindStrRegex("ABCDEF", "BCD"), "{\"findstrregex\":\"ABCDEF\",\"pattern\":\"BCD\"}");
//     expectJson(FindStrRegex("ABCDEF", "BCD", 1), "{\"findstrregex\":\"ABCDEF\",\"pattern\":\"BCD\",\"start\":1}");
//     expectJson(FindStrRegex("ABCDEF", "BCD", 1, 3), "{\"findstrregex\":\"ABCDEF\",\"pattern\":\"BCD\",\"start\":1,\"num_results\":3}");

//     expectJson(Length("ABC"), "{\"length\":\"ABC\"}");

//     expectJson(LowerCase("ABC"), "{\"lowercase\":\"ABC\"}");

//     expectJson(LTrim("ABC"), "{\"ltrim\":\"ABC\"}");

//     expectJson(Repeat("ABC"), "{\"repeat\":\"ABC\"}");
//     expectJson(Repeat("ABC", 2), "{\"repeat\":\"ABC\",\"number\":2}");

//     expectJson(ReplaceStr("ABCDEF", "BCD", "CAR"), "{\"replacestr\":\"ABCDEF\",\"find\":\"BCD\",\"replace\":\"CAR\"}");

//     expectJson(ReplaceStrRegex("ABCDEF", "BCD", "CAR"), "{\"replacestrregex\":\"ABCDEF\",\"pattern\":\"BCD\",\"replace\":\"CAR\"}");
//     expectJson(ReplaceStrRegex("abcdef", "bcd", "car", true), "{\"replacestrregex\":\"abcdef\",\"pattern\":\"bcd\",\"replace\":\"car\",\"first\":true}");

//     expectJson(RTrim("ABC"), "{\"rtrim\":\"ABC\"}");

//     expectJson(Space(2), "{\"space\":2}");

//     expectJson(SubString("ABC"), "{\"substring\":\"ABC\"}");
//     expectJson(SubString("ABC", 2), "{\"substring\":\"ABC\",\"start\":2}");
//     expectJson(SubString("ABC", 2, 3), "{\"substring\":\"ABC\",\"start\":2,\"length\":3}");

//     expectJson(Trim("ABC"), "{\"trim\":\"ABC\"}");
//     expectJson(UpperCase("ABC"), "{\"uppercase\":\"ABC\"}");
//     expectJson(TitleCase("ABC"), "{\"titlecase\":\"ABC\"}");
// });
}
