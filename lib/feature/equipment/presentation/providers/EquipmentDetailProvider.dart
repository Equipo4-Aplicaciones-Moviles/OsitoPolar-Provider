import 'package:flutter/material.dart';
import 'package:osito_polar_app/core/error/Failures.dart';

// Entidades
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentEntity.dart';
import 'package:osito_polar_app/feature/equipment/domain/entities/EquipmentHealthEntity.dart';

// Casos de Uso
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentByIdUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentHealthUseCase.dart'; // <--- NUEVO IMPORT

/// Define los posibles estados de la UI para la pantalla de "Detalle de Equipo".
enum EquipmentDetailState {
  initial,
  loading,
  success,
  error
}

/// El "ViewModel" para la pantalla de ProviderEquipmentDetailPage.
class EquipmentDetailProvider extends ChangeNotifier {
  final GetEquipmentByIdUseCase getEquipmentByIdUseCase;
  // --- NUEVA DEPENDENCIA ---
  final GetEquipmentHealthUseCase getEquipmentHealthUseCase;

  EquipmentDetailProvider({
    required this.getEquipmentByIdUseCase,
    required this.getEquipmentHealthUseCase,
  });

  // --- Estados de la UI ---
  EquipmentDetailState _state = EquipmentDetailState.initial;
  EquipmentDetailState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Datos del Equipo
  EquipmentEntity? _equipment;
  EquipmentEntity? get equipment => _equipment;

  // --- NUEVOS DATOS: ANALÍTICAS ---
  EquipmentHealthEntity? _healthMetrics;
  EquipmentHealthEntity? get healthMetrics => _healthMetrics;

  // Estado separado para la carga de salud (para no bloquear toda la pantalla si falla)
  bool _isHealthLoading = false;
  bool get isHealthLoading => _isHealthLoading;

  /// Método que la UI llamará en `initState()` para cargar los datos del equipo.
  Future<void> fetchEquipmentDetails(int equipmentId) async {
    _state = EquipmentDetailState.loading;
    // Limpiamos datos anteriores para no mostrar basura de otro equipo
    _equipment = null;
    _healthMetrics = null;
    notifyListeners();

    // 1. Llamada principal: Datos del equipo
    final failureOrEquipment = await getEquipmentByIdUseCase(equipmentId);

    failureOrEquipment.fold(
          (failure) {
        // --- Caso de Error ---
        _errorMessage = _mapFailureToMessage(failure);
        _state = EquipmentDetailState.error;
        notifyListeners();
      },
          (equipmentData) {
        // --- Caso de Éxito ---
        _equipment = equipmentData;
        _state = EquipmentDetailState.success;
        notifyListeners();

        // 2. ¡Automáticamente cargamos la salud en segundo plano!
        fetchHealthMetrics(equipmentId);
      },
    );
  }

  /// Nuevo método para cargar solo las analíticas
  Future<void> fetchHealthMetrics(int equipmentId) async {
    _isHealthLoading = true;
    notifyListeners();

    // Por defecto analizamos los últimos 7 días
    final params = GetHealthParams(equipmentId: equipmentId, days: 7);
    final failureOrHealth = await getEquipmentHealthUseCase(params);

    failureOrHealth.fold(
          (failure) {
        // Si fallan las analíticas, no cambiamos el estado global a error,
        // solo dejamos _healthMetrics en null y la UI mostrará "No disponible".
        print("Error cargando salud: ${_mapFailureToMessage(failure)}");
        _isHealthLoading = false;
        notifyListeners();
      },
          (healthData) {
        _healthMetrics = healthData;
        _isHealthLoading = false;
        notifyListeners();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Error del servidor. No se pudo cargar el equipo.';
    } else if (failure is NotFoundFailure) {
      return failure.message ?? 'Elemento no encontrado.';
    }
    return 'Un error inesperado ocurrió.';
  }
}