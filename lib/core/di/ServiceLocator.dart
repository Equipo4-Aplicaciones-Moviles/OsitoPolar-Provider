import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// --- 1. USANDO TUS NOMBRES DE ARCHIVO 'PascalCase.dart' ---
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/authentication/data/repositories/AuthRepositoryImpl.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignInUseCase.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart'; // Tu archivo se llama así

/// [GetIt] es un localizador de servicios simple (Service Locator).
final sl = GetIt.instance;

/// Inicializa todas las dependencias de la app.
void setupLocator() {
  // --- FEATURES ---
  // 1. Authentication

  // A. Provider (ViewModel)
  sl.registerFactory(
    // 2. USANDO TU NOMBRE DE CLASE 'ProviderLoginProvider'
        () => ProviderLoginProvider(signInUseCase: sl()),
  );

  // B. UseCases
  sl.registerLazySingleton(() => SignInUseCase(sl()));

  // C. Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // D. DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // --- CORE & EXTERNAL ---
  sl.registerLazySingleton(() => http.Client());
}