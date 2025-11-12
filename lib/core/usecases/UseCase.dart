import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:osito_polar_app/core/error/Failures.dart'; // Importa tu Failure

/// La plantilla (molde) para todos los UseCases.
/// Define que cada UseCase debe tener un método 'call' que
/// devuelve un 'Future' con un 'Either' (un Failure o un Éxito 'Type').
///
/// [Type] es el tipo de dato que devuelve si es exitoso (ej. List<EquipmentEntity>)
/// [Params] es el objeto que le pasamos con los parámetros (ej. un ID)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Un objeto 'Params' genérico para cuando un UseCase
/// no necesita ningún parámetro (ej. "obtener todos los equipos").
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}