import 'package:ditonton/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/tv/entities/tv_detail.dart';

import '../entities/tv.dart';

abstract class TvRepository{
  Future<Either<Failure, List<Tv>>> getTvOnTheAir();
  Future<Either<Failure, List<Tv>>> getPopularTv();
  Future<Either<Failure, List<Tv>>> getTopRatedTv();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTv(String query);
  Future<Either<Failure, String>> saveWatchListTv(TvDetail tvDetail);
  Future<Either<Failure, String>> removeWatchListTv(TvDetail tvDetail);
  Future<bool> isAddedToWatchList(int id);
  Future<Either<Failure, List<Tv>>> getWatchListTv();
}