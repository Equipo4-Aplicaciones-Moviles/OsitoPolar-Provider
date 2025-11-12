// Ruta: feature/equipment/domain/usecases/DeleteEquipmentUseCase.dart

import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart'; // <-- ¡Importa el molde!
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';

// --- ¡MODIFICADO! ---
// 1. Implementa el "molde" UseCase
// 2. Dice que devuelve 'void' (nada) y recibe un 'int'
class DeleteEquipmentUseCase implements UseCase<void, int> {
  final EquipmentRepository repository;

  DeleteEquipmentUseCase(this.repository);

  // --- ¡MODIFICADO! ---
  // 3. El 'call' ahora acepta un 'int'
  @override
  Future<Either<Failure, void>> call(int equipmentId) async {
    return await repository.deleteEquipment(equipmentId);
  }
}