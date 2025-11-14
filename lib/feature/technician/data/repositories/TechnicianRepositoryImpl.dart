import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/error/Exceptions.dart';
import 'package:osito_polar_app/feature/technician/data/datasource/TechnicianRemoteDataSource.dart';
import 'package:osito_polar_app/feature/technician/domain/entities/TechnicianEntity.dart';
import 'package:osito_polar_app/feature/technician/domain/repositories/TechnicianRepository.dart';

class TechnicianRepositoryImpl implements TechnicianRepository {
  final TechnicianRemoteDataSource remoteDataSource;

  TechnicianRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TechnicianEntity>>> getTechnicians() async {
    try {
      final technicianModels = await remoteDataSource.getTechnicians();
      // Convertimos la lista de Modelos a una lista de Entidades
      return Right(technicianModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TechnicianEntity>> createTechnician(
      {required Map<String, dynamic> technicianData}) async {
    try {
      final technicianModel = await remoteDataSource.createTechnician(
          technicianData: technicianData);
      return Right(technicianModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TechnicianEntity>> getTechnicianById(
      int technicianId) async {
    try {
      final technicianModel =
      await remoteDataSource.getTechnicianById(technicianId);
      return Right(technicianModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}