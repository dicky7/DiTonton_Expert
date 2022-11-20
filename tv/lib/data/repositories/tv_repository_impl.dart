import 'dart:io';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/repositories/tv_repository.dart';
import '../datasources/tv_local_data_source.dart';
import '../datasources/tv_remote_data_source.dart';
import '../model/tv_table.dart';


class TvRepositoryImpl implements TvRepository {
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;

  TvRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      });

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async{
    try {
      final result = await remoteDataSource.getTvPopular();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async{
    try{
      final result = await remoteDataSource.getTopRated();
      return Right(result.map((model) => model.toEntity()).toList());
    }on ServerException{
      return Left(ServerFailure(""));
    }on SocketException{
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async{
    try{
      final result = await remoteDataSource.getTvDetail(id);
      return Right(result.toEntity());
    }on ServerException{
      return Left(ServerFailure(""));
    }on SocketException{
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvOnTheAir() async{
    try{
      final result = await remoteDataSource.getTvOnTheAir();
      return Right(result.map((model) => model.toEntity()).toList());
    }on ServerException{
      return Left(ServerFailure(""));
    }on SocketException{
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async{
    try{
      final result = await remoteDataSource.getTvRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    }on ServerException{
      return Left(ServerFailure(""));
    }on SocketException{
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async{
    try{
      final result = await remoteDataSource.searchTv(query);
      return Right(result.map((model) => model.toEntity()).toList());
    }on ServerException{
      return Left(ServerFailure(""));
    }on SocketException{
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchListTv() async{
    final result = await localDataSource.getWatchlistTv();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchList(int id) async{
    final result = await localDataSource.getTvById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchListTv(TvDetail tvDetail) async{
    try{
      final result = await localDataSource.removeWatchlistTv(TvTable.fromEntity(tvDetail));
      return Right(result);
    }on DatabaseException catch(e){
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchListTv(TvDetail tvDetail) async{
    try{
      final result = await localDataSource.insertWatchlistTv(TvTable.fromEntity(tvDetail));
      return Right(result);
    }on DatabaseException catch(e){
      return Left(DatabaseFailure(e.message));
    }catch(e){
      throw e;
    }
  }

}
