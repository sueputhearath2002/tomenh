abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message) {
    // showMessage(msg: message, status: MessageStatus.errors);
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  late String _message = "";

  NetworkFailure(String message) : super(message) {
    // showMessage(msg: message, status: MessageStatus.errors);
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
