import 'package:equatable/equatable.dart';

/// Una clase base abstracta para los Fallos (Errores) en la app.
/// Usamos Equatable para poder compararlos.
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// Fallos generales de la app
class ServerFailure extends Failure {} // Error del servidor (500, etc.)
class NetworkFailure extends Failure {} // Error de conexión
class CacheFailure extends Failure {} // Error de caché (ej. SharedPreferences)