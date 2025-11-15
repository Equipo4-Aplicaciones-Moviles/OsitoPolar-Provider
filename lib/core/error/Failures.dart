import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // ¡Modificado para aceptar un 'message'!
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

/// Falla General del Servidor (4xx, 5xx)
class ServerFailure extends Failure {
  // ¡Ahora le pasamos el 'message' a la clase base!
  const ServerFailure({String? message}) : super(message: message);
}

class NetworkFailure extends Failure {
  final String message;

  NetworkFailure(this.message); // Tu provider usa 'failure.message'
}

/// Falla de Caché (SharedPreferences, etc.)
class CacheFailure extends Failure {
  const CacheFailure({String? message}) : super(message: message);
}