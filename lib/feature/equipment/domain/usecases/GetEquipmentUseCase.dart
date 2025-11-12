// Ruta: feature/equipment/domain/usecases/GetEquipmentUseCase.dart

import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart'; // <-- ¡Importa el molde!
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

// --- ¡MODIFICADO! ---
// 1. Implementa el "molde" UseCase
// 2. Dice que devuelve List<EquipmentEntity> y recibe NoParams
class GetEquipmentsUseCase implements UseCase<List<EquipmentEntity>, NoParams> {
  final EquipmentRepository repository;

  GetEquipmentsUseCase(this.repository);

  // --- ¡MODIFICADO! ---
  // 3. El 'call' ahora acepta (NoParams params)
  @override
  Future<Either<Failure, List<EquipmentEntity>>> call(NoParams params) async {
    return await repository.getEquipments();
  }
}