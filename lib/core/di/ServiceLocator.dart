import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// --- AUTH IMPORTS ---
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSource.dart';
import 'package:osito_polar_app/feature/authentication/data/datasource/AuthRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/authentication/data/repositories/AuthRepositoryImpl.dart';
import 'package:osito_polar_app/feature/authentication/domain/repositories/AuthRepository.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/SignInUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/CreateRegistrationCheckoutUseCase.dart';
import 'package:osito_polar_app/feature/authentication/domain/usecases/CompleteRegistrationUseCase.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/LoginProvider.dart';
import 'package:osito_polar_app/feature/authentication/presentation/providers/RegisterProvider.dart';

// --- EQUIPMENT IMPORTS ---
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSource.dart';
import 'package:osito_polar_app/feature/equipment/data/datasource/EquipmentRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/equipment/data/repositories/EquipmentRepositoryImpl.dart';
import 'package:osito_polar_app/feature/equipment/domain/repositories/EquipmentRepository.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/CreateEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/GetEquipmentByIdUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/DeleteEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/UpdateEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/PublishEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/domain/usecases/UnpublishEquipmentUseCase.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/AddEquipmentProvider.dart';
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentDetailProvider.dart';
// ¡NUEVO PROVIDER DE EQUIPMENT!
import 'package:osito_polar_app/feature/equipment/presentation/providers/EquipmentProvider.dart';

// --- SERVICE REQUEST IMPORTS ---
import 'package:osito_polar_app/feature/service_request/data/datasource/ServiceRequestRemoteDataSource.dart';
import 'package:osito_polar_app/feature/service_request/data/datasource/ServiceRequestRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/service_request/data/repositories/ServiceRequestRepositoryImpl.dart';
import 'package:osito_polar_app/feature/service_request/domain/repositories/ServiceRequestRepository.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/GetAvailableServiceRequestsUseCase.dart';
import 'package:osito_polar_app/feature/service_request/domain/usecases/AcceptServiceRequestUseCase.dart';
// ¡NUEVO PROVIDER DE MARKETPLACE!
import 'package:osito_polar_app/feature/service_request/presentation/providers/MarketplaceProvider.dart';

// --- PROVIDER DASHBOARD (HOME) IMPORTS ---
// ¡EL PROVIDER DEL DASHBOARD/RESUMEN!
import 'package:osito_polar_app/feature/provider-dashboard/presentation/providers/ProviderHomeProvider.dart';
//TECHNICIAN IMPORTS

import 'package:osito_polar_app/feature/technician/domain/repositories/TechnicianRepository.dart';
import 'package:osito_polar_app/feature/technician/data/repositories/TechnicianRepositoryImpl.dart';
import 'package:osito_polar_app/feature/technician/data/datasource/TechnicianRemoteDataSource.dart';
import 'package:osito_polar_app/feature/technician/data/datasource/TechnicianRemoteDataSourceImpl.dart';
import 'package:osito_polar_app/feature/technician/domain/usecases/GetTechnicianUseCase.dart';
import 'package:osito_polar_app/feature/technician/domain/usecases/CreateTechnicianUseCase.dart';
import 'package:osito_polar_app/feature/technician/presentation/providers/TechnicianProvider.dart'; // (Lo crearemos en el siguiente paso)

final sl = GetIt.instance;

Future<void> setupLocator() async {
  await sl.reset();

  // --- PASO 1: CORE/EXTERNAL ---
  sl.registerLazySingleton(() => http.Client());
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // --- PASO 2: FEATURES ---

  // --- Authentication ---
  // (Sin cambios)
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => CreateRegistrationCheckoutUseCase(sl()));
  sl.registerLazySingleton(() => CompleteRegistrationUseCase(sl()));
  sl.registerFactory(() => ProviderLoginProvider(signInUseCase: sl(), prefs: sl()));
  sl.registerFactory(() => RegisterProvider(
    createRegistrationCheckoutUseCase: sl(),
    completeRegistrationUseCase: sl(),
    prefs: sl(),
  ));

  // --- Equipment Stack ---
  sl.registerLazySingleton<EquipmentRemoteDataSource>(() => EquipmentRemoteDataSourceImpl(client: sl(), prefs: sl()));
  sl.registerLazySingleton<EquipmentRepository>(() => EquipmentRepositoryImpl(remoteDataSource: sl(), prefs: sl()));
  sl.registerLazySingleton(() => GetEquipmentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateEquipmentUseCase(sl()));
  sl.registerLazySingleton(() => GetEquipmentByIdUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEquipmentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEquipmentUseCase(sl()));
  sl.registerLazySingleton(() => PublishEquipmentUseCase(sl()));
  sl.registerLazySingleton(() => UnpublishEquipmentUseCase(sl()));

  sl.registerFactory(() => AddEquipmentProvider(
    createEquipmentUseCase: sl(),
    updateEquipmentUseCase: sl(),
    getEquipmentByIdUseCase: sl(),
  ));
  sl.registerFactory(() => EquipmentDetailProvider(getEquipmentByIdUseCase: sl()));

  // ¡NUEVO PROVIDER DE EQUIPMENT (para la pág. Mis Equipos)!
  sl.registerFactory(() => EquipmentProvider(
    getEquipmentsUseCase: sl(),
    deleteEquipmentUseCase: sl(),
    publishEquipmentUseCase: sl(),
    unpublishEquipmentUseCase: sl(),
  ));

  // --- ServiceRequest Stack ---
  sl.registerLazySingleton<ServiceRequestRemoteDataSource>(() => ServiceRequestRemoteDataSourceImpl(client: sl(), prefs: sl()));
  sl.registerLazySingleton<ServiceRequestRepository>(() => ServiceRequestRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetAvailableServiceRequestsUseCase(sl()));
  sl.registerLazySingleton(() => AcceptServiceRequestUseCase(sl()));

  // ¡NUEVO PROVIDER DE MARKETPLACE (para la pág. Marketplace)!
  sl.registerFactory(() => MarketplaceProvider(
    getAvailableServiceRequestsUseCase: sl(),
    acceptServiceRequestUseCase: sl(),
  ));

  // --- ProviderHome Stack (Dashboard/Resumen) ---
  // ¡EL PROVIDER DEL DASHBOARD!
  sl.registerFactory(() => ProviderHomeProvider(
    getEquipmentsUseCase: sl(), // (Necesita esto para el conteo)
    getAvailableServiceRequestsUseCase: sl(), // (Necesita esto para el conteo)
  ));


  // --- Technician Stack ---

  // D. DataSources
  sl.registerLazySingleton<TechnicianRemoteDataSource>(
        () => TechnicianRemoteDataSourceImpl(client: sl(), prefs: sl()),
  );

  // C. Repositories
  sl.registerLazySingleton<TechnicianRepository>(
        () => TechnicianRepositoryImpl(remoteDataSource: sl()),
  );

  // B. UseCases
  sl.registerLazySingleton(() => GetTechniciansUseCase(sl()));
  sl.registerLazySingleton(() => CreateTechnicianUseCase(sl()));

  // A. Providers
  sl.registerFactory(() => TechnicianProvider(
    getTechniciansUseCase: sl(),
    createTechnicianUseCase: sl(),
  ));
}