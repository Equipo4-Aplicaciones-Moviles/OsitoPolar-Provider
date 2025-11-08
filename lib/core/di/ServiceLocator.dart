import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// --- IMPORTACIONES DE AUTHENTICATION ---
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/authentication/data/repositories/AuthRepositoryImpl.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignInUseCase.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';

// --- ¡NUEVO! IMPORTACIONES DE EQUIPMENT ---
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSource.dart';
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/equipment/data/repositories/EquipmentRepositoryImpl.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';


final sl = GetIt.instance;

void setupLocator() {
  // --- FEATURES ---

  // 1. Authentication (Esto ya estaba)
  sl.registerFactory(() => ProviderLoginProvider(signInUseCase: sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // 2. ¡NUEVO! Equipment Stack
  //    Registramos todo el stack para la feature de Equipos
  sl.registerFactory(
        () => ProviderHomeProvider(getEquipmentsUseCase: sl()),
  );
  sl.registerLazySingleton(() => GetEquipmentsUseCase(sl()));
  sl.registerLazySingleton<EquipmentRepository>(
        () => EquipmentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<EquipmentRemoteDataSource>(
        () => EquipmentRemoteDataSourceImpl(client: sl()),
  );

  // TODO: Registrar los stacks de Client, Technician, ServiceRequest...

  // --- CORE & EXTERNAL ---
  sl.registerLazySingleton(() => http.Client());
  // TODO: Registrar SharedPreferences
}