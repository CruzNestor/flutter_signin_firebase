import 'package:equatable/equatable.dart';

// ignore: constant_identifier_names
const String CONNECTION_FAILURE_MESSAGE = 'Not internet connection';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;
  
  @override
  List<Object> get props => [message];
}

class NetworkConnectionFailure extends Failure {
  const NetworkConnectionFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}