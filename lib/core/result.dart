abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}


class LocalDatabaseFailure extends Failure {
  LocalDatabaseFailure(String message) : super(message);
}

