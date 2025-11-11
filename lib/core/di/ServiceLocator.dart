import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// --- IMPORTACIONES DE AUTHENTICATION ---
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/authentication/data/repositories/AuthRepositoryImpl.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignInUseCase.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignUpUseCase.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';

// --- IMPORTACIONES DE EQUIPMENT ---
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSource.dart';
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/equipment/data/repositories/EquipmentRepositoryImpl.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';

import 'package:osito_polar_app/feature/equipment/domain/usecases/CreateEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentByIdUseCase.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/DeleteEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/UpdateEquipmentUseCase.dart';

// --- ¡AÑADIDO! Importaciones del nuevo stack de ServiceRequest ---
import 'package:osito_polar_app/feature/service_request/data/datasource/ServiceRequestRemoteDataSource.dart';
import 'package:osito_polar_app/feature/service_request/data/datasource/ServiceRequestRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/service_request/data/repositories/ServiceRequestRepositoryImpl.dart';
import 'package:osito_polar_app/feature/service_request/domain/repositories/ServiceRequestRepository.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/GetServiceRequestsUseCase.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {

  // 1. Resetea el locator para evitar errores de Hot Restart
  await sl.reset();


  // --- ¡PASO 1: REGISTRAR CORE Y EXTERNAL PRIMERO! ---
  // Estas son las dependencias base que no dependen de nada.
  sl.registerLazySingleton(() => http.Client());
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // --- ¡PASO 2: REGISTRAR FEATURES (DE ABAJO HACIA ARRIBA) ---

  // --- Authentication ---

  // D. DataSources (Depende de 'http.Client')
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // C. Repositories (Depende de 'AuthRemoteDataSource')
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // B. UseCases (Depende de 'AuthRepository')
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));


  // A. Providers (Depende de 'UseCases' y 'SharedPreferences')
  sl.registerFactory(
        () => ProviderLoginProvider(signInUseCase: sl(), prefs: sl()),
  );
  sl.registerFactory(
        () => RegisterProvider(signUpUseCase: sl()),
  );

  // --- Equipment Stack ---

  // D. DataSources (Depende de 'http.Client' y 'SharedPreferences')
  sl.registerLazySingleton<EquipmentRemoteDataSource>(
        () => EquipmentRemoteDataSourceImpl(client: sl(), prefs: sl()),
  );

  // C. Repositories (Depende de 'EquipmentRemoteDataSource' y 'SharedPreferences')
  sl.registerLazySingleton<EquipmentRepository>(
        () => EquipmentRepositoryImpl(remoteDataSource: sl(), prefs: sl()),
  );

  // B. UseCases (Depende de 'EquipmentRepository')
  sl.registerLazySingleton(() => GetEquipmentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateEquipmentUseCase(sl()));
  sl.registerLazySingleton(() => GetEquipmentByIdUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEquipmentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEquipmentUseCase(sl()));
  // A. Providers (Depende de 'UseCases')

  sl.registerFactory(
        () => AddEquipmentProvider(
            createEquipmentUseCase: sl(),
            updateEquipmentUseCase: sl(), // <-- ¡AÑADIDO!
            getEquipmentByIdUseCase: sl(), ),
  );
  sl.registerFactory(
        () => EquipmentDetailProvider(getEquipmentByIdUseCase: sl()),
  );

  // --- ¡AÑADIDO! ServiceRequest Stack ---

  // D. DataSources
  sl.registerLazySingleton<ServiceRequestRemoteDataSource>(
        () => ServiceRequestRemoteDataSourceImpl(client: sl(), prefs: sl()),
  );
  // C. Repositories
  sl.registerLazySingleton<ServiceRequestRepository>(
        () => ServiceRequestRepositoryImpl(remoteDataSource: sl()),
  );
  // B. UseCases
  sl.registerLazySingleton(() => GetServiceRequestsUseCase(sl()));

  // A. Providers
  // (Actualizamos el 'ProviderHomeProvider' que ya existía)
  sl.registerFactory(
    // --- ¡MODIFICADO! ---
        () => ProviderHomeProvider(
      getEquipmentsUseCase: sl(),
      deleteEquipmentUseCase: sl(),
      getServiceRequestsUseCase: sl(), // <-- ¡AÑADIDO!
    ),
  );

}