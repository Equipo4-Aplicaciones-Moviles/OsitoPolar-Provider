import 'package:dartz/dartz.dart';
import 'package:osito_polar_app/core/error/Failures.dart';
import 'package:osito_polar_app/core/error/Exceptions.dart';
import 'package:osito_polar_app/core/usecases/UseCase.dart';

import '../../domain/entities/WithdrawalBalanceEntity.dart';
import '../models/WithdrawalModel.dart';



abstract class WithdrawalRepository {
  Future<Either<Failure, WithdrawalBalanceEntity>> getBalance();
  Future<Either<Failure, void>> requestWithdrawal(double amount, String method);
}

// --- IMPLEMENTACIÓN ---
class WithdrawalRepositoryImpl implements WithdrawalRepository {
  final WithdrawalRemoteDataSource remoteDataSource;

  WithdrawalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WithdrawalBalanceEntity>> getBalance() async {
    try {
      final result = await remoteDataSource.getProviderBalance();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestWithdrawal(double amount, String method) async {
    try {
      await remoteDataSource.requestWithdrawal(amount: amount, paymentMethod: method);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

// --- CASOS DE USO ---
class GetProviderBalanceUseCase implements UseCase<WithdrawalBalanceEntity, NoParams> {
  final WithdrawalRepository repository;
  GetProviderBalanceUseCase(this.repository);

  @override
  Future<Either<Failure, WithdrawalBalanceEntity>> call(NoParams params) {
    return repository.getBalance();
  }
}

class RequestWithdrawalUseCase {
  final WithdrawalRepository repository;
  RequestWithdrawalUseCase(this.repository);

  Future<Either<Failure, void>> call(double amount, String method) {
    return repository.requestWithdrawal(amount, method);
  }
}