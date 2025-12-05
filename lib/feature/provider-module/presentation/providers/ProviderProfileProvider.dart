import 'package:flutter/material.dart';
import '../../domain/entities/ProviderProfileEntity.dart';

class ProviderProfileProvider extends ChangeNotifier {
  // Aquí inyectarías tu caso de uso: final GetProviderProfileUseCase getProfile;

  ProviderProfileEntity? _profile;
  ProviderProfileEntity? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Llama a esto cuando entres a la pantalla
  Future<void> loadProfile(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // --- AQUÍ IRÍA LA LLAMADA REAL A TU API ---
      // final result = await getProfile(userId);

      // POR AHORA: Simulamos una carga de red exitosa con datos de prueba
      await Future.delayed(const Duration(seconds: 1));

      _profile = const ProviderProfileEntity(
        profileId: 101,
        companyName: "CoolingWorks S.A.C.",
        taxId: "20123456789",
        balance: 1250.00,
        planName: "Plan Pro (Ice Bear)",
        maxClients: 50,
        currentClientCount: 12,
        activeServiceRequests: 5,
      );

      _errorMessage = '';
    } catch (e) {
      _errorMessage = "Error cargando perfil: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}