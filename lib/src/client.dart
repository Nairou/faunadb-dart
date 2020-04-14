import 'expr.dart';

class FaunaClient {
  final String secret;

  FaunaClient({this.secret});

  Expr query(Expr parameter) {
    return parameter;
  }
}
